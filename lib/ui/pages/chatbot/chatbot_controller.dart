import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/chatt_model_response.dart';
import 'utils/helper.dart';
import 'utils/utils_app.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotController extends StateNotifier<ChatbotState> {
  ChatbotController() : super(ChatbotState());
 
  final usuario = ChatUser(id: "1", firstName: "User");
  final bot = ChatUser(id: "2", firstName: "Hannah");
 

  set typing(List<ChatUser> data) => state = state.copyWith(typing: data);
  set mensajeEnv(List<ChatMessage> dataM) => state = state.copyWith(mensajeEnv: dataM);

  final FlutterTts _flutterTts = FlutterTts(); // Define _flutterTts aquí


  

  Future<bool> getData(ChatMessage m) async {
    try {
      //se asigan los datos que esten actualmente en el estado.
      List<ChatMessage> mensajeEnvNew = [];
      List<ChatUser> typingNew = [];

      mensajeEnvNew.addAll(state.mensajeEnv);
      typingNew.addAll(state.typing);
      typingNew.add(bot);
      mensajeEnvNew.insert(0, m);

      final response = await http.post(Uri.parse(ourUrl), headers: header, body: jsonEncode(getPropmt(m.text)));
      if (response.statusCode == 200) {
        var result = responseChattFromJson(response.body);

        final m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result.candidates.first.content.parts.first.text,
        );
        mensajeEnvNew.insert(0, m1);
        mensajeEnv = mensajeEnvNew; //Se asigna al estado los valores obtenidos, para mostar en pantalla
        return true; 
      }
      typingNew.remove(bot);
      return false;
    } catch (e) {
      print("Error occurred $e");
      return false;
    }
  }

  getFirstMessage() async {
    List<ChatMessage> mensajeEnvNew = [];

    String mensaje = "No funcionó";

    final response = await http.post(Uri.parse(ourUrl), headers: header, body: jsonEncode(firstMessage));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      mensaje = result["candidates"][0]["content"]["parts"][0]["text"];
      print(mensaje);

      mensajeEnvNew.insert(
        0,
        ChatMessage(
          text: mensaje,
          user: bot,
          createdAt: DateTime.now(),
        ),
      );

      mensajeEnv = mensajeEnvNew;
      print (mensajeEnvNew);
    // Hablar el primer mensaje del chatbot
    _flutterTts.speak(mensajeEnvNew.first.text);
    }
  }
}

class ChatbotState {
  final List<ChatMessage> mensajeEnv;
  final List<ChatUser> typing;

  ChatbotState({
    this.mensajeEnv = const [],
    this.typing = const [],
  });

  ChatbotState copyWith({
    List<ChatMessage>? mensajeEnv,
    List<ChatUser>? typing,
  }) {
    return ChatbotState(
      mensajeEnv: mensajeEnv ?? this.mensajeEnv,
      typing: typing ?? this.typing,
    );
  }
}
