import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/models/chat_message_model.dart';
import 'package:qanony/services/cubits/gemini/gemini_cubit.dart';

class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColor.primary,
          title: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              "مساعدك القانوني الذكي",
              style: AppText.title.copyWith(color: AppColor.light),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppPadding.paddingSmall,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.clear();
                messages.clear();
                context.read<GeminiCubit>().reset();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "مسح المحادثة",
                    style: AppText.bodySmall.copyWith(color: AppColor.error),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                  Icon(Icons.delete, size: 20, color: AppColor.error),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Expanded(
              child: BlocConsumer<GeminiCubit, GeminiState>(
                listener: (context, state) {
                  if (state is GeminiSuccess) {
                    messages.add(
                      ChatMessage(
                        role: ChatRole.gemini,
                        content: state.response,
                      ),
                    );
                  } else if (state is GeminiFailure) {
                    messages.add(
                      ChatMessage(
                        role: ChatRole.gemini,
                        content: "حدث خطأ: ${state.error}",
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    padding: AppPadding.paddingMedium,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isUser = message.role == ChatRole.user;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: AppPadding.verticalMedium,
                          padding: AppPadding.paddingMedium,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: isUser
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                            color: isUser ? AppColor.primary : AppColor.grey,
                          ),
                          child: Text(
                            message.content,
                            style: isUser
                                ? AppText.bodyLarge.copyWith(
                                    color: AppColor.light,
                                  )
                                : AppText.bodyLarge.copyWith(
                                    color: AppColor.dark,
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Padding(
              padding: AppPadding.verticalMedium,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<GeminiCubit, GeminiState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 60.h,
                        width: 60.w,
                        child: Center(
                          child: state is GeminiLoading
                              ? SizedBox(
                                  height: 24.r,
                                  width: 24.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: AppColor.dark,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right_sharp,
                                    size: 40.sp,
                                    color: AppColor.dark,
                                  ),
                                  onPressed: state is GeminiLoading
                                      ? null
                                      : () {
                                          final prompt = controller.text.trim();
                                          if (prompt.isNotEmpty) {
                                            messages.add(
                                              ChatMessage(
                                                role: ChatRole.user,
                                                content: prompt,
                                              ),
                                            );
                                            controller.clear();
                                            context
                                                .read<GeminiCubit>()
                                                .sendPrompt(prompt);
                                          }
                                        },
                                ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      maxLength: 1000,
                      controller: controller,
                      style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                      cursorColor: AppColor.dark,
                      decoration: InputDecoration(
                        hintText: "اكتب سؤالك...",
                        hintStyle: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.dark),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.dark,
                            width: 1.5.w,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.dark),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        counterText: "",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
