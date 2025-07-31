import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> generateSubscriptionPdf({
  required String subscriptionType,
  required DateTime subscriptionStart,
  required DateTime subscriptionEnd,
  required String paymentMethod,
}) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'تفاصيل الاشتراك',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'الباقة الحالية: $subscriptionType',
                style: pw.TextStyle(font: ttf, fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'تاريخ الاشتراك: ${subscriptionStart.toLocal().toString().split(' ')[0]}',
                style: pw.TextStyle(font: ttf, fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'تاريخ الانتهاء: ${subscriptionEnd.toLocal().toString().split(' ')[0]}',
                style: pw.TextStyle(font: ttf, fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'وسيلة الدفع: $paymentMethod',
                style: pw.TextStyle(font: ttf, fontSize: 18),
              ),
            ],
          ),
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/subscription_details.pdf');
  await file.writeAsBytes(await pdf.save());

  return file.path;
}
