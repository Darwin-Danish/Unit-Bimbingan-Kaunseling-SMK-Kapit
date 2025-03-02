class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;
  final String? fileSize;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    this.fileSize,
  });
}