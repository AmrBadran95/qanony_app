import 'package:flutter/material.dart';
import 'package:qanony/presentation/pages/user-base-screen.dart';

import '../../Core/styles/color.dart';
import '../../Core/styles/padding.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserBaseScreen(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
            decoration: BoxDecoration(
              color: AppColor.light,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: "بحث ...",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
