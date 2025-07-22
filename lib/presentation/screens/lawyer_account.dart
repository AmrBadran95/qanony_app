import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/widgets/Lawyer_calender.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/models/lawyer_model.dart';
import 'package:qanony/data/static/egypt_governorates.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/services/cubits/lawyer_info/lawyer_info_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

class AccountLawyerScreen extends StatefulWidget {
  final String lawyerId;
  const AccountLawyerScreen({super.key, required this.lawyerId});

  @override
  State<AccountLawyerScreen> createState() => _AccountLawyerScreenState();
}

class _AccountLawyerScreenState extends State<AccountLawyerScreen> {
  late LawyerCubit _lawyerCubit;

  @override
  void initState() {
    super.initState();
    _lawyerCubit = LawyerCubit(LawyerFirestoreService());
    _lawyerCubit.getLawyerById(widget.lawyerId);
  }

  @override
  // void dispose() {
  //   _lawyerCubit.close();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lawyerCubit,
      child: LawyerBaseScreen(
        body: BlocBuilder<LawyerCubit, LawyerState>(
          builder: (context, state) {
            if (state is LawyerInitial) {
              return Center(child: Text('الرجاء انتظار تحميل البيانات...'));
            }
            if (state is LawyerLoading || state is LawyerUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LawyerLoaded) {
              final lawyer = state.lawyer;

              if (lawyer == null) {
                return const Center(
                  child: Text("لم يتم العثور على بيانات المحامي"),
                );
              }
              final dateOfBirth = lawyer.dateOfBirth;
              String dateOfBirthText;

              dateOfBirthText =
                  (lawyer.dateOfBirth != null &&
                      lawyer.dateOfBirth is Timestamp)
                  ? (lawyer.dateOfBirth as Timestamp).toDate().toString().split(
                      ' ',
                    )[0]
                  : 'غير متوفر';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              (lawyer.profilePictureUrl != null &&
                                  lawyer.profilePictureUrl!.isNotEmpty)
                              ? NetworkImage(lawyer.profilePictureUrl!)
                              : const AssetImage(
                                      'assets/images/default_profile.png',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(height: 8),
                        Text(lawyer.fullName ?? '', style: AppText.title),
                      ],
                    ),
                    const SizedBox(height: 16),

                    sectionCard(
                      title: "البيانات الشخصية",
                      icon: Icons.edit,
                      onPressed: () {
                        showEditProfileDialog(context, lawyer);
                      },
                      children: [
                        infoRow(
                          "رقم الهاتف",
                          lawyer.phone.isNotEmpty ? lawyer.phone : 'غير متوفر',
                        ),
                        infoRow(
                          "البريد الإلكتروني",
                          lawyer.email.isNotEmpty ? lawyer.email : 'غير متوفر',
                        ),
                        infoRow(" النوع", lawyer.gender ?? 'غير متوفر'),
                        infoRow(" المحافظه", lawyer.governorate ?? 'غير متوفر'),
                      ],
                    ),

                    if (lawyer.specialty != null &&
                        lawyer.specialty!.isNotEmpty)
                      sectionCard(
                        title: "التخصص",
                        icon: Icons.edit,
                        onPressed: () {},
                        children: [
                          BlocSelector<LawyerCubit, LawyerState, List<String>>(
                            selector: (state) {
                              return state is LawyerLoaded
                                  ? state.lawyer.specialty ?? []
                                  : [];
                            },
                            builder: (context, specialties) {
                              return Wrap(
                                spacing: 10,
                                children: specialties
                                    .map((e) => chip(e))
                                    .toList(),
                              );
                            },
                          ),
                          // Wrap(
                          //   spacing: 10,
                          //   children: lawyer.specialty!
                          //       .map((e) => chip(e))
                          //       .toList(),
                          // ),
                        ],
                      ),
                    sectionCard(
                      title: " نبذة عني",
                      icon: Icons.edit,
                      onPressed: () {},
                      children: [
                        Text(
                          lawyer.bio ?? 'لا توجد معلومات متاحة',
                          style: const TextStyle(color: AppColor.dark),
                        ),
                      ],
                    ),
                    sectionCard(
                      title: "طرق التواصل",
                      icon: Icons.edit,
                      onPressed: () {},
                      children: [
                        infoRow(
                          lawyer.offersCall == true ? 'مكالمه فيديو/صوت' : '',
                          lawyer.offersCall == true
                              ? lawyer.callPrice?.toString() ?? ''
                              : '',
                        ),
                        infoRow(
                          lawyer.offersOffice == true ? 'جلسة بالمكتب' : '',
                          lawyer.offersOffice == true
                              ? lawyer.officePrice?.toString() ?? ''
                              : '',
                        ),
                      ],
                    ),
                    sectionCard(
                      title: "نوع الاشتراك",
                      icon: Icons.edit,
                      onPressed: () {},
                      children: [
                        infoRow(
                          "النوع",
                          lawyer.subscriptionType ?? 'غير متوفر',
                        ),
                        infoRow(
                          "بداية",
                          lawyer.subscriptionStart?.toLocal().toString().split(
                                ' ',
                              )[0] ??
                              'غير متوفر',
                        ),
                        infoRow(
                          "نهاية",
                          lawyer.subscriptionEnd?.toLocal().toString().split(
                                ' ',
                              )[0] ??
                              'غير متوفر',
                        ),
                      ],
                    ),
                    sectionCard(
                      title: 'المواعيد المتاحه',
                      children: [WeeklyCalendarWidget(lawyerId: lawyer.uid!)],
                    ),

                    sectionCard(
                      title: 'معلومات اضافيه',
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('تغيير كلمة المرور'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('  حذف الحساب'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is LawyerError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _getStatusArabic(String status) {
    switch (status) {
      case 'pending':
        return "قيد الانتظار";
      case 'approved':
        return "مقبول";
      case 'rejected':
        return "مرفوض";
      default:
        return "غير معروف";
    }
  }

  Widget sectionCard({
    required String title,
    VoidCallback? onPressed,
    IconData? icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (icon != null)
                  IconButton(
                    icon: Icon(icon, color: Colors.grey),
                    onPressed: onPressed,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget chip(String label) {
    return Chip(label: Text(label), backgroundColor: Colors.red[100]);
  }

  void showEditProfileDialog(BuildContext context, LawyerModel userData) {
    final TextEditingController phoneController = TextEditingController(
      text: userData.phone,
    );
    final TextEditingController emailController = TextEditingController(
      text: userData.email,
    );

    String selectedGender = userData.gender ?? '';
    String selectedGovernorate = userData.governorate ?? '';
    List<String> genderOptions = ['ذكر', 'أنثى'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تعديل البيانات الشخصية'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الالكتروني',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                DropdownButtonFormField<String>(
                  value: selectedGender.isNotEmpty ? selectedGender : null,
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'النوع'),
                  onChanged: (String? newValue) {
                    if (newValue != null) selectedGender = newValue;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedGovernorate.isNotEmpty
                      ? selectedGovernorate
                      : null,
                  items: egyptGovernorates.map((String gov) {
                    return DropdownMenuItem<String>(
                      value: gov,
                      child: Text(gov),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'المحافظة'),
                  onChanged: (String? newValue) {
                    if (newValue != null) selectedGovernorate = newValue;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  'phone': phoneController.text,
                  'email': emailController.text,
                  'gender': selectedGender,
                  'governorate': selectedGovernorate,
                };

                context.read<LawyerCubit>().editLawyerData(
                  userData.uid,
                  updatedData,
                );
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}
