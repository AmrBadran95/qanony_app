enum ChatRole { user, gemini }

class ChatMessage {
  final ChatRole role;
  final String content;

  ChatMessage({required this.role, required this.content});
}
