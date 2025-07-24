import 'package:qanony/services/gemini/gemini_service.dart';

class GeminiRepository {
  Future<String> getResponse(String prompt) async {
    return await GeminiService.generateContent(prompt);
  }
}
