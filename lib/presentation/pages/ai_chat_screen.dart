import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: AppBar(
          backgroundColor: AppColor.primary,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "مساعدك القانوني الذكي",
                  style: AppText.headingMedium.copyWith(color: AppColor.light),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
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
                    style: AppText.bodySmall.copyWith(color: AppColor.primary),
                  ),
                  SizedBox(width: width * 0.02),
                  Icon(
                    Icons.delete,
                    size: width * 0.05,
                    color: AppColor.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
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
                    padding: EdgeInsets.all(width * 0.03),
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
                          margin: EdgeInsets.symmetric(vertical: height * 0.01),
                          padding: EdgeInsets.all(width * 0.03),
                          constraints: BoxConstraints(maxWidth: width * 0.75),
                          decoration: BoxDecoration(
                            borderRadius: isUser
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(width * 0.02),
                                    topRight: Radius.circular(width * 0.02),
                                    bottomLeft: Radius.circular(width * 0.02),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(width * 0.02),
                                    topRight: Radius.circular(width * 0.02),
                                    bottomRight: Radius.circular(width * 0.02),
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
            SizedBox(height: height * 0.02),
            Row(
              children: [
                BlocBuilder<GeminiCubit, GeminiState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: state is GeminiLoading
                          ? SizedBox(
                              width: width * 0.06,
                              height: width * 0.06,
                              child: CircularProgressIndicator(
                                color: AppColor.dark,
                              ),
                            )
                          : Icon(
                              Icons.keyboard_arrow_right_sharp,
                              size: width * 0.08,
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
                                context.read<GeminiCubit>().sendPrompt(prompt);
                              }
                            },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                    cursorColor: AppColor.dark,
                    decoration: InputDecoration(
                      hintText: "اكتب سؤالك...",
                      hintStyle: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.dark),
                        borderRadius: BorderRadius.circular(width * 0.07),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.dark),
                        borderRadius: BorderRadius.circular(width * 0.07),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.dark),
                        borderRadius: BorderRadius.circular(width * 0.07),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
