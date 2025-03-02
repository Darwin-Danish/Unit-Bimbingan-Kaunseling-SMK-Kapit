import 'dart:async';
import 'dart:math';

class BotService {
  // This is a simple mock service that returns predefined responses
  // In a real app, this would connect to an API or use a local ML model
  
  final List<String> _greetings = [
    'Hello! How can I help you today?',
    'Hi there! What can I do for you?',
    'Greetings! How may I assist you?',
    'Hello! I\'m here to help with any questions about UBK services.',
  ];
  
  final Map<String, List<String>> _responses = {
    'appointment': [
      'You can book an appointment through the booking screen. Would you like me to guide you there?',
      'Appointments can be scheduled via the booking feature. Do you need help with that?',
      'To book an appointment, use the + button at the bottom of the screen.',
    ],
    'counseling': [
      'Our counseling services cover academic, personal, and career guidance. What specific area are you interested in?',
      'We offer various counseling services including individual and group sessions. Would you like more details?',
      'Counseling sessions are available Monday through Friday. Would you like to know the specific hours?',
    ],
    'resources': [
      'We have many resources available in the Docs section. Have you checked there?',
      'Educational materials and resources can be found in our documentation area.',
      'Check out our resource library in the Docs tab for helpful materials.',
    ],
    'help': [
      'I\'m here to help! What specific information are you looking for?',
      'How can I assist you today? Feel free to ask about our services.',
      'I can help with appointments, counseling information, and resources. What do you need?',
    ],
  };
  
  final List<String> _fallbacks = [
    'I\'m not sure I understand. Could you rephrase that?',
    'I don\'t have information on that topic yet. Would you like to ask about something else?',
    'I\'m still learning! Could you try asking about our services, appointments, or resources?',
    'I don\'t have an answer for that. Would you like to speak with a counselor instead?',
  ];

  Future<String> getBotResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    
    final lowerCaseMessage = userMessage.toLowerCase();
    
    // Check for greetings
    if (_isGreeting(lowerCaseMessage)) {
      return _greetings[Random().nextInt(_greetings.length)];
    }
    
    // Check for keywords and return appropriate responses
    for (final entry in _responses.entries) {
      if (lowerCaseMessage.contains(entry.key)) {
        final responses = entry.value;
        return responses[Random().nextInt(responses.length)];
      }
    }
    
    // If no keywords match, return a fallback response
    return _fallbacks[Random().nextInt(_fallbacks.length)];
  }
  
  bool _isGreeting(String message) {
    final greetingWords = ['hi', 'hello', 'hey', 'greetings', 'good morning', 'good afternoon', 'good evening'];
    return greetingWords.any((word) => message.contains(word));
  }
}