import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/widgets/custom_text_form_field.dart';

import '../../Core/widgets/custom_button.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({super.key});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedType;
  final List<String> caseTypes = [
    'قضية جنائية',
    'قضية مدنية',
    'قضية أحوال شخصية',
    'قضية تجارية',
    'قضية عمالية',
    'قضية إدارية',
    'قضية مالية',
    'قضية عقارية',
    'قضية مرورية',
    'قضية تأمينية',
  ];

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.primary,
            colorScheme: ColorScheme.light(primary: AppColor.primary),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateController.text = formatted;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إضافة الموعد بنجاح')));

      Navigator.pop(context);
    }
  }

  final textStyle = const TextStyle(fontSize: 16, color: AppColor.dark);
  final hintStyle = TextStyle(color: AppColor.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.light),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'إضافة موعد',
          style: TextStyle(color: AppColor.light),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "اسم المحامي",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.dark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: nameController,
                hintText: '',
                textStyle: textStyle,
                hintStyle: hintStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.medium,
                  vertical: AppPadding.small,
                ),
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.grey,
                validator: (value) =>
                    value == null || value.isEmpty ? "برجاء إدخال الاسم" : null,
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "نوع القضية",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.dark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: caseTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val),
                decoration: InputDecoration(
                  labelText: 'نوع القضية',
                  labelStyle: const TextStyle(color: AppColor.dark),
                  filled: true,
                  fillColor: AppColor.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'اختر نوع القضية' : null,
              ),
              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "وصف الموعد",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.dark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: descriptionController,
                hintText: 'وصف الموعد',
                textStyle: textStyle,
                hintStyle: hintStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                width: double.infinity,
                height: 100,
                backgroundColor: AppColor.grey,
                validator: (value) =>
                    value == null || value.isEmpty ? "برجاء إدخال الوصف" : null,
              ),
              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "السعر",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.dark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: priceController,
                hintText: 'السعر بالجنيه',
                keyboardType: TextInputType.number,
                textStyle: textStyle,
                hintStyle: hintStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.grey,
                validator: (value) =>
                    value == null || value.isEmpty ? "برجاء إدخال السعر" : null,
              ),
              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "تاريخ الموعد",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.dark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    controller: dateController,
                    hintText: 'اختر التاريخ',
                    textStyle: textStyle,
                    hintStyle: hintStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    width: double.infinity,
                    height: 60,
                    backgroundColor: AppColor.grey,
                    validator: (value) => value == null || value.isEmpty
                        ? "اختر تاريخ الموعد"
                        : null,
                    logo: const Icon(Icons.calendar_today, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: 'اضافه قضيه',
                onTap: _saveForm,
                width: 200,
                height: 50,
                backgroundColor: AppColor.secondary,
                textStyle: const TextStyle(
                  color: AppColor.light,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
