import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/data/static/lawyer_specializations.dart';
import 'package:qanony/services/cubits/appointments/appointments_cubit.dart';

import '../../Core/widgets/my_appointments_widget.dart';

class MyAppointmentsTab extends StatefulWidget {
  const MyAppointmentsTab({super.key});

  @override
  State<MyAppointmentsTab> createState() => _MyAppointmentsTabState();
}

class _MyAppointmentsTabState extends State<MyAppointmentsTab> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final communicationType = TextEditingController();
  String? selectedSpecialty;
  DateTime? selectedDate;
  String? editingId;

  void _clearControllers() {
    nameController.clear();
    descriptionController.clear();
    communicationType.clear();
    selectedSpecialty = null;
    selectedDate = null;
    editingId = null;
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(date);
  }

  void _showAddDialog(BuildContext context, {DocumentSnapshot? appointment}) {
    final isEdit = appointment != null;

    if (isEdit) {
      nameController.text = appointment['name'];
      descriptionController.text = appointment['description'];
      communicationType.text = appointment['communication'];
      selectedSpecialty = appointment['specialty'];
      selectedDate = (appointment['date'] as Timestamp).toDate();
      editingId = appointment.id;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isEdit ? "تعديل الموعد" : "إضافة موعد",
                style: AppText.title.copyWith(color: AppColor.dark),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(nameController, 'اسم العميل'),
                      DropdownButtonFormField<String>(
                        dropdownColor: AppColor.grey,
                        value: selectedSpecialty,
                        items: lawyerSpecializations.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: AppText.bodyMedium.copyWith(
                                color: AppColor.dark,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSpecialty = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'نوع القضية',
                          labelStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                        validator: (value) => value == null ? 'مطلوب' : null,
                      ),
                      _buildField(descriptionController, 'وصف القضية'),
                      SizedBox(height: 10.sp),
                      _buildField(communicationType, 'طريقة التواصل مع العميل'),
                      SizedBox(height: 10.sp),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? 'لم يتم اختيار التاريخ والوقت'
                                  : '  التاريخ: ${DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(selectedDate!)}',
                              style: selectedDate == null
                                  ? AppText.bodySmall.copyWith(
                                      color: AppColor.error,
                                    )
                                  : AppText.bodyMedium.copyWith(
                                      color: AppColor.dark,
                                    ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColor.primary,
                                        onPrimary: AppColor.light,
                                        surface: AppColor.grey,
                                        onSurface: AppColor.dark,
                                      ),
                                      textTheme: TextTheme(
                                        titleLarge: AppText.title,
                                        bodyLarge: AppText.bodyLarge,
                                        bodyMedium: AppText.bodyMedium,
                                        labelLarge: AppText.bodySmall,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColor.dark,
                                          textStyle: AppText.bodySmall,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (context.mounted) {
                                if (pickedDate != null) {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          timePickerTheme: const TimePickerThemeData(
                                            confirmButtonStyle: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStatePropertyAll(
                                                    AppColor.green,
                                                  ),
                                            ),
                                            cancelButtonStyle: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStatePropertyAll(
                                                    AppColor.error,
                                                  ),
                                            ),
                                            dayPeriodColor: AppColor.primary,
                                            backgroundColor:
                                                AppColor.grey, // خلفية الدايلوج
                                            hourMinuteTextColor:
                                                AppColor.dark, // لون الأرقام
                                            dialHandColor: AppColor
                                                .primary, // لون عقرب الاختيار
                                            dialBackgroundColor:
                                                AppColor.light, // خلفية الدائرة
                                            dialTextColor: AppColor
                                                .dark, // لون الأرقام داخل الدائرة
                                            entryModeIconColor: AppColor
                                                .primary, // لون أيقونة الكتابة
                                          ),
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColor
                                                .primary, // لون الساعة المختارة والزراير
                                            onSurface: AppColor
                                                .secondary, // لون النصوص العادية
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    final fullDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    setState(() {
                                      selectedDate = fullDateTime;
                                    });
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _clearControllers();
                  },
                  child: Text(
                    "إلغاء",
                    style: AppText.bodySmall.copyWith(color: AppColor.error),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedDate != null) {
                      final cubit = context.read<AppointmentsCubit>();
                      if (isEdit) {
                        cubit.updateAppointment(
                          id: editingId!,
                          name: nameController.text.trim(),
                          specialty: selectedSpecialty!,
                          description: descriptionController.text.trim(),
                          communication: communicationType.text.trim(),
                          date: selectedDate!,
                        );
                      } else {
                        cubit.addAppointment(
                          name: nameController.text.trim(),
                          specialty: selectedSpecialty!,
                          description: descriptionController.text.trim(),
                          communication: communicationType.text.trim(),
                          date: selectedDate!,
                        );
                      }
                      Navigator.pop(context);
                      _clearControllers();
                    }
                  },
                  child: Text(
                    isEdit ? "تحديث" : "إضافة",
                    style: AppText.bodySmall.copyWith(color: AppColor.green),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.sp),
      child: TextFormField(
        controller: controller,
        style: AppText.bodyMedium.copyWith(color: AppColor.dark),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
        ),
        validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();

    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: cubit.getAppointmentsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'حدث خطأ',
                  style: AppText.bodyMedium.copyWith(color: AppColor.error),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final appointments = snapshot.data!.docs;

            if (appointments.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد مواعيد حالياً",
                  style: AppText.bodyMedium.copyWith(color: AppColor.error),
                ),
              );
            }

            return ListView.builder(
              padding: AppPadding.paddingExtraSmall,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final item = appointments[index];

                return MyAppointmentCardWidget(
                  name: item['name'],
                  specialty: item['specialty'],
                  description: item['description'],
                  date: formatDate(item['date']),
                  communication: item['communication'],
                  onDelete: () => cubit.deleteAppointment(item.id),
                  onEdit: () => _showAddDialog(context, appointment: item),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton(
            backgroundColor: AppColor.green,
            onPressed: () => _showAddDialog(context),
            child: const Icon(Icons.add, size: 30, color: AppColor.light),
          ),
        ),
      ],
    );
  }
}
