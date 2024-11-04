import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/chatbot/chatbot_controller.dart';

//Esto se usa para hacer una instancia del provider o de la clase controller y state del chatbot u otro pantalla
final chatBotStateProvider = StateNotifierProvider<ChatbotController, ChatbotState>((ref) {
  return ChatbotController();
});
