import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';

class RatingDialog extends StatefulWidget {
  final String userId;
  final String lawyerId;

  const RatingDialog({super.key, required this.userId, required this.lawyerId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 3;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  void _loadUserRating() async {
    final rating = await RatingFirestoreService().getUserRating(
      userId: widget.userId,
      lawyerId: widget.lawyerId,
    );

    if (rating != null) {
      setState(() {
        _rating = rating['rating']?.toDouble() ?? 3;
        _commentController.text = rating['comment'] ?? '';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _submitRating() async {
    await RatingFirestoreService().addOrUpdateRating(
      userId: widget.userId,
      lawyerId: widget.lawyerId,
      rating: _rating,
      comment: _commentController.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "قيم المحامي",
        style: AppText.bodyMedium.copyWith(color: AppColor.dark),
      ),
      content: _isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  itemCount: 5,
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: AppColor.secondary),
                  onRatingUpdate: (value) {
                    _rating = value;
                  },
                ),
                SizedBox(height: 10.sp),
                TextField(
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "اكتب تعليقك...",
                    hintStyle: AppText.bodyMedium.copyWith(
                      color: AppColor.dark,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          child: Text(
            "إلغاء",
            style: AppText.bodySmall.copyWith(color: AppColor.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _submitRating,
          child: Text(
            "حفظ",
            style: AppText.bodySmall.copyWith(color: AppColor.green),
          ),
        ),
      ],
    );
  }
}
