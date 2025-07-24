import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/widgets/Lawyer_calender.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/models/lawyer_model.dart';
import 'package:qanony/data/static/egypt_governorates.dart';
import 'package:qanony/data/static/lawyer_specializations.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/subscription_screen.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/cubits/lawyer_info/lawyer_info_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

class AccountLawyerScreen extends StatefulWidget {
  const AccountLawyerScreen({super.key});
  @override
  State<AccountLawyerScreen> createState() => _AccountLawyerScreenState();
}

class _AccountLawyerScreenState extends State<AccountLawyerScreen> {
  late LawyerInfoCubit _lawyerCubit;
  final lawyerId = AuthService().currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _lawyerCubit = LawyerInfoCubit(LawyerFirestoreService());

    _lawyerCubit.getLawyerById(lawyerId ?? '');
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lawyerCubit,
      child: BlocBuilder<LawyerInfoCubit, LawyerInfoState>(
        builder: (context, state) {
          if (state is LawyerInitial) {
            return Center(child: Text('الرجاء انتظار تحميل البيانات...'));
          }
          if (state is LawyerLoading || state is LawyerUpdating) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LawyerLoaded) {
            final lawyer = state.lawyer;
            final dateOfBirth = lawyer.dateOfBirth;
            String dateOfBirthText;

            dateOfBirthText =
                (lawyer.dateOfBirth != null && lawyer.dateOfBirth is Timestamp)
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
                      SizedBox(height: 8),
                      Text(
                        lawyer.fullName ?? '',
                        style: AppText.title.copyWith(color: AppColor.dark),
                      ),
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
                      infoRow(" المحافظه", lawyer.governorate ?? 'غير متوفر'),
                    ],
                  ),

                  if (lawyer.specialty != null && lawyer.specialty!.isNotEmpty)
                    sectionCard(
                      title: "التخصص",
                      icon: Icons.edit,
                      onPressed: () => _showSpecialtyDialog(context, lawyer),
                      children: [
                        BlocSelector<
                          LawyerInfoCubit,
                          LawyerInfoState,
                          List<String>
                        >(
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
                      ],
                    ),
                  sectionCard(
                    title: " نبذة عني",
                    icon: Icons.edit,
                    onPressed: () => _showBioDialog(context, lawyer),
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
                    onPressed: () => _showCommunicationDialog(context, lawyer),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionScreen(),
                        ),
                      );
                    },
                    children: [
                      infoRow("النوع", lawyer.subscriptionType ?? 'غير متوفر'),
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
                    children: [WeeklyCalendarWidget(lawyerId: lawyer.uid)],
                  ),

                  sectionCard(
                    title: 'معلومات اضافيه',
                    children: [
                      TextButton(
                        onPressed: () =>
                            _showDeleteAccountDialog(context, lawyer.uid),
                        child: Text(
                          '  حذف الحساب',
                          style: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
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
    );
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
                  style: AppText.title.copyWith(color: AppColor.dark),
                ),
                if (icon != null)
                  IconButton(
                    icon: Icon(icon, color: AppColor.darkgrey),
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
            child: Text(
              label,
              style: AppText.bodyMedium.copyWith(color: AppColor.primary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.bodySmall.copyWith(color: AppColor.dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget chip(String label) {
    return Chip(
      label: Text(label, style: TextStyle(color: AppColor.light)),
      backgroundColor: AppColor.primary,
    );
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
          title: Text(
            'تعديل البيانات الشخصية',
            style: AppText.headingMedium.copyWith(color: AppColor.dark),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    labelStyle: AppText.title.copyWith(color: AppColor.dark),
                  ),
                  style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الالكتروني',
                    labelStyle: AppText.title.copyWith(color: AppColor.dark),
                  ),
                  style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                  keyboardType: TextInputType.emailAddress,
                ),

                DropdownButtonFormField<String>(
                  value: selectedGovernorate.isNotEmpty
                      ? selectedGovernorate
                      : null,
                  items: egyptGovernorates.map((String gov) {
                    return DropdownMenuItem<String>(
                      value: gov,
                      child: Text(
                        gov,
                        style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'المحافظة',
                    labelStyle: AppText.title.copyWith(color: AppColor.dark),
                  ),
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
              child: Text(
                'إلغاء',
                style: AppText.bodyMedium.copyWith(color: AppColor.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  'phone': phoneController.text,
                  'email': emailController.text,
                  'governorate': selectedGovernorate,
                };

                context.read<LawyerInfoCubit>().editLawyerData(
                  userData.uid,
                  updatedData,
                );
                Navigator.pop(context);
              },
              child: Text(
                'حفظ',
                style: AppText.bodyMedium.copyWith(color: AppColor.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSpecialtyDialog(BuildContext context, LawyerModel lawyer) {
    List<String> selectedSpecialties = List.from(lawyer.specialty ?? []);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('اختر التخصصات'),
              content: SingleChildScrollView(
                child: Column(
                  children: lawyerSpecializations.map((specialty) {
                    return CheckboxListTile(
                      activeColor: AppColor.green,
                      checkColor: AppColor.light,
                      title: Text(specialty),
                      value: selectedSpecialties.contains(specialty),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedSpecialties.add(specialty);
                          } else {
                            selectedSpecialties.remove(specialty);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: AppText.bodyMedium.copyWith(color: AppColor.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<LawyerInfoCubit>().editLawyerData(lawyer.uid, {
                      'specialty': selectedSpecialties,
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'حفظ',
                    style: AppText.bodyMedium.copyWith(color: AppColor.green),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBioDialog(BuildContext context, LawyerModel lawyer) {
    TextEditingController bioController = TextEditingController(
      text: lawyer.bio ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تعديل السيرة الذاتية',
            style: AppText.headingMedium.copyWith(color: AppColor.dark),
          ),
          content: TextField(
            controller: bioController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب نبذة عنك هنا...',
              hintStyle: AppText.title.copyWith(color: AppColor.dark),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: AppText.bodyMedium.copyWith(color: AppColor.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LawyerInfoCubit>().editLawyerData(lawyer.uid, {
                  'bio': bioController.text.trim(),
                });
                Navigator.pop(context);
              },
              child: Text(
                'حفظ',
                style: AppText.bodyMedium.copyWith(color: AppColor.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCommunicationDialog(BuildContext context, LawyerModel lawyer) {
    bool offersCall = lawyer.offersCall ?? false;
    bool offersOffice = lawyer.offersOffice ?? false;
    TextEditingController callPriceController = TextEditingController(
      text: lawyer.callPrice?.toString() ?? '',
    );
    TextEditingController officePriceController = TextEditingController(
      text: lawyer.officePrice?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تعديل طرق التواصل'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text('مكالمة فيديو/صوت'),
                      value: offersCall,
                      onChanged: (bool? value) {
                        setState(() {
                          offersCall = value ?? false;
                        });
                      },
                    ),
                    if (offersCall)
                      TextField(
                        controller: callPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'سعر المكالمة',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('جلسة بالمكتب'),
                      value: offersOffice,
                      onChanged: (bool? value) {
                        setState(() {
                          offersOffice = value ?? false;
                        });
                      },
                    ),
                    if (offersOffice)
                      TextField(
                        controller: officePriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'سعر الجلسة بالمكتب',
                          border: OutlineInputBorder(),
                        ),
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
                  onPressed: () {
                    context.read<LawyerInfoCubit>().editLawyerData(lawyer.uid, {
                      'offersCall': offersCall,
                      'callPrice': offersCall
                          ? double.tryParse(callPriceController.text.trim()) ??
                                0
                          : null,
                      'offersOffice': offersOffice,
                      'officePrice': offersOffice
                          ? double.tryParse(
                                  officePriceController.text.trim(),
                                ) ??
                                0
                          : null,
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, String lawyerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: AppColor.dark),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('lawyers')
                      .doc(lawyerId)
                      .delete();
                  AppCache.setLoggedIn(false);
                  AppCache.setIsLawyer(false);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('فشل حذف الحساب، حاول مرة أخرى.'),
                    ),
                  );
                }
              },
              child: const Text('حذف', style: TextStyle(color: AppColor.light)),
            ),
          ],
        );
      },
    );
  }
}
