import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/widgets/lawyer_calender.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/models/lawyer_model.dart';
import 'package:qanony/data/static/egypt_governorates.dart';
import 'package:qanony/data/static/lawyer_specializations.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/subscription_screen.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/cubits/lawyer_info/lawyer_info_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';
import 'package:qanony/services/validators/signin_signup_validators.dart';

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
    _lawyerCubit.removePastAppointments(lawyerId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lawyerCubit,
      child: BlocBuilder<LawyerInfoCubit, LawyerInfoState>(
        builder: (context, state) {
          if (state is LawyerInitial) {
            return Center(
              child: Text(
                'الرجاء انتظار تحميل البيانات...',
                style: AppText.bodyLarge.copyWith(color: AppColor.dark),
              ),
            );
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
              padding: AppPadding.paddingMedium,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.sp,
                        backgroundImage:
                            (lawyer.profilePictureUrl != null &&
                                lawyer.profilePictureUrl!.isNotEmpty)
                            ? NetworkImage(lawyer.profilePictureUrl!)
                            : const AssetImage(
                                    'assets/images/default_profile.png',
                                  )
                                  as ImageProvider,
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        lawyer.fullName ?? '',
                        style: AppText.title.copyWith(color: AppColor.dark),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.sp),

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
                        lawyer.offersCall == true ? 'مكالمة فيديو/صوت' : '',
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
                      infoRow(
                        "النوع",
                        lawyer.subscriptionType == "fixed"
                            ? "الباقه الشهريه"
                            : lawyer.subscriptionType == "free"
                            ? "الباقة المجانية"
                            : "الأكثر إنتشاراً",
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
                    title: 'المواعيد المتاحة',
                    children: [WeeklyCalendarWidget(lawyerId: lawyer.uid)],
                  ),

                  sectionCard(
                    title: 'معلومات اضافية',
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
            return Center(
              child: Text(
                state.message,
                style: AppText.bodySmall.copyWith(color: AppColor.primary),
              ),
            );
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
      margin: EdgeInsets.only(bottom: AppPadding.medium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: AppPadding.paddingMedium,
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
                    icon: Icon(icon, color: AppColor.dark),
                    onPressed: onPressed,
                  ),
              ],
            ),
            SizedBox(height: 10.sp),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppText.bodyMedium.copyWith(color: AppColor.primary),
          ),
          Text(value, style: AppText.bodySmall.copyWith(color: AppColor.dark)),
        ],
      ),
    );
  }

  Widget chip(String label) {
    return Chip(
      label: Text(
        label,
        style: AppText.bodySmall.copyWith(color: AppColor.light),
      ),
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
            style: AppText.title.copyWith(color: AppColor.dark),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneController,
                  validator: AppValidators.validatePhone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    labelStyle: AppText.bodyLarge.copyWith(
                      color: AppColor.dark,
                    ),
                  ),
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: AppValidators.validateEmail,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الالكتروني',
                    labelStyle: AppText.bodyLarge.copyWith(
                      color: AppColor.dark,
                    ),
                  ),
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColor.grey,
                  value: selectedGovernorate.isNotEmpty
                      ? selectedGovernorate
                      : null,
                  items: egyptGovernorates.map((String gov) {
                    return DropdownMenuItem<String>(
                      value: gov,
                      child: Text(
                        gov,
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'المحافظة',
                    labelStyle: AppText.bodyLarge.copyWith(
                      color: AppColor.dark,
                    ),
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
                style: AppText.bodySmall.copyWith(color: AppColor.error),
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
                style: AppText.bodySmall.copyWith(color: AppColor.green),
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
              title: Text(
                'اختر التخصصات',
                style: AppText.title.copyWith(color: AppColor.dark),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: lawyerSpecializations.map((specialty) {
                    return CheckboxListTile(
                      activeColor: AppColor.green,
                      checkColor: AppColor.light,
                      title: Text(
                        specialty,
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                      ),
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
                    style: AppText.bodySmall.copyWith(color: AppColor.error),
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
            style: AppText.title.copyWith(color: AppColor.dark),
          ),
          content: TextField(
            controller: bioController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب نبذة عنك هنا...',
              hintStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
              border: OutlineInputBorder(),
            ),
            style: AppText.bodyMedium.copyWith(color: AppColor.dark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: AppText.bodySmall.copyWith(color: AppColor.error),
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
                style: AppText.bodySmall.copyWith(color: AppColor.green),
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
              title: Text(
                'تعديل طرق التواصل',
                style: AppText.title.copyWith(color: AppColor.dark),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      activeColor: AppColor.green,
                      checkColor: AppColor.light,
                      title: Text(
                        'مكالمة فيديو/صوت',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                      ),
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
                        decoration: InputDecoration(
                          labelText: 'سعر المكالمة',
                          labelStyle: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    SizedBox(height: 12.sp),
                    CheckboxListTile(
                      activeColor: AppColor.green,
                      checkColor: AppColor.light,
                      title: Text(
                        'جلسة بالمكتب',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                      ),
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
                        decoration: InputDecoration(
                          labelText: 'سعر الجلسة بالمكتب',
                          labelStyle: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: AppText.bodySmall.copyWith(color: AppColor.error),
                  ),
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
                  child: Text(
                    'حفظ',
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
                style: TextStyle(color: AppColor.error),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('lawyers')
                      .doc(lawyerId)
                      .delete();
                  AppCache.setLoggedIn(false);
                  AppCache.setIsLawyer(false);
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseRoleScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'فشل حذف الحساب، حاول مرة أخرى.',
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.error,
                          ),
                        ),
                        backgroundColor: AppColor.grey,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'حذف',
                style: AppText.bodySmall.copyWith(color: AppColor.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
