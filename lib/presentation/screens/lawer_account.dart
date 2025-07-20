import 'package:flutter/material.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';

class AccountLawyerScreen extends StatelessWidget {
  const AccountLawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LawyerBaseScreen(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/lawyer1.png"),
                ),
                const SizedBox(height: 8),
                Text("Rahma omar", style: AppText.labelLarge),
              ],
            ),
            const SizedBox(height: 16),

            // البيانات الشخصية
            sectionCard(
              title: "البيانات الشخصية",
              icon: Icons.edit,
              onPressed: () {},
              children: [
                infoRow("تاريخ الميلاد", "18/7/2002"),
                infoRow("الجنس", "انثى"),
                infoRow("العنوان", "القاهرة"),
              ],
            ),

            // التخصص
            sectionCard(
              title: "التخصص",
              icon: Icons.edit,
              onPressed: () {},
              children: [
                Wrap(
                  spacing: 10,
                  children: [chip("جنائي"), chip("مدني"), chip("أحوال شخصية")],
                ),
              ],
            ),

            // طرق التواصل
            sectionCard(
              title: "طرق التواصل",
              icon: Icons.edit,
              onPressed: () {},
              children: [infoRow("الهاتف", "0100000000")],
            ),

            // جهات العمل
            sectionCard(
              title: "جهات العمل الحالية",
              icon: Icons.edit,
              onPressed: () {},
              children: [
                Wrap(
                  spacing: 10,
                  children: [chip(" مكالمه فيديو"), chip("في المكتب")],
                ),
              ],
            ),

            // المواعيد المتاحة
            sectionCard(
              title: "المواعيد المتاحه",
              icon: Icons.add,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: _AddScheduleBottomSheet(),
                    );
                  },
                );
              },
              children: [Wrap(spacing: 10, children: const [])],
            ),

           
            sectionCard(
              title: "معلومات إضافية",
              icon: Icons.edit,
              onPressed: () {},
              children: const [Text("لا توجد معلومات إضافية حاليًا.")],
            ),
          ],
        ),
      ),
    );
  }

  static Widget sectionCard({
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
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

  static Widget infoRow(String label, String value) {
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

  static Widget chip(String label) {
    return Chip(label: Text(label), backgroundColor: Colors.red[100]);
  }
}

class _AddScheduleBottomSheet extends StatelessWidget {
  const _AddScheduleBottomSheet();

  final List<String> days = const [
    "السبت",
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "اختار اليوم",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            return ChoiceChip(
              label: Text(day),
              selected: false,
              onSelected: (_) {
                Navigator.pop(context);
                showTimeRangePicker(context, day);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

void showTimeRangePicker(BuildContext context, String day) async {
  final TimeOfDay? from = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (from == null) return;

  final TimeOfDay? to = await showTimePicker(
    context: context,
    initialTime: from.replacing(hour: from.hour + 1),
  );

  if (to == null) return;

 
  Future.microtask(() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "تم تحديد: $day من ${from.format(context)} إلى ${to.format(context)}",
          ),
        ),
      );
    }
  });
}
