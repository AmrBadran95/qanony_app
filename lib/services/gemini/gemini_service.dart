import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['GEMINI_API_KEY']}',
      },
    ),
  );

  static Future<String> generateContent(String prompt) async {
    final resp = await dio.post(
      'chat/completions?model=gemini-2.5-flash&reasoning_effort=low',
      data: {
        'messages': [
          {
            'role': 'system',
            'content':
                'أنت مساعد قانوني ذكي خاص بالمحاماة و القانون و الدستور المصري فقط ...',
          },
          {'role': 'user', 'content': prompt},
        ],
      },
    );
    return resp.data['choices'][0]['message']['content'];
  }
}
