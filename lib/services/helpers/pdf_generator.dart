import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> generateSubscriptionPdf({
  required String subscriptionType,
  required DateTime subscriptionStart,
  required DateTime subscriptionEnd,
  required String paymentMethod,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'تفاصيل الاشتراك',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'الباقة الحالية: $subscriptionType',
              style: pw.TextStyle(fontSize: 18),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'تاريخ الاشتراك: ${subscriptionStart.toLocal().toString().split(' ')[0]}',
              style: pw.TextStyle(fontSize: 18),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'تاريخ الانتهاء: ${subscriptionEnd.toLocal().toString().split(' ')[0]}',
              style: pw.TextStyle(fontSize: 18),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'وسيلة الدفع: $paymentMethod',
              style: pw.TextStyle(fontSize: 18),
            ),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/subscription_details.pdf');
  await file.writeAsBytes(await pdf.save());

  return file.path;
}
