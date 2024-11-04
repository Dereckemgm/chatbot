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

Future<void> init() async {
    // Verifica si el primer mensaje ya se envió
    if (!state.isFirstMessageSent) {
      await getFirstMessage(); // Llama a la función solo si no se ha enviado el primer mensaje
      // Actualiza el estado para indicar que el primer mensaje ha sido enviado
      state = state.copyWith(isFirstMessageSent: true);
    }
  }

  
Future<List<Map<String, dynamic>>> fetchHistorial() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:3000/chats/mensajes'));

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Asegúrate de que responseData contiene un objeto con la clave `data`
      if (responseData.containsKey('data')) {
        List<dynamic> historialData = responseData['data'];

        // Combina la conversión de mensajes en una sola lista
        List<Map<String, dynamic>> historialPrompt = [];

        for (var mensaje in historialData) {
          historialPrompt.add({
            "role": "user",
            "parts": [
              {"text": mensaje["mensaje_usuario"]}
            ]
          });
          historialPrompt.add({
            "role": "model",
            "parts": [
              {"text": mensaje["respuesta_chatbot"]}
            ]
          });
        }

        return historialPrompt;
      } else {
        print('Formato de respuesta inesperado');
        return [];
      }
    } else {
      print('Error al obtener el historial: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}






 Future<bool> getData(ChatMessage m) async {
  try {
      List<ChatMessage> mensajeEnvNew = [];
      List<ChatUser> typingNew = [];

      mensajeEnvNew.addAll(state.mensajeEnv);
      typingNew.addAll(state.typing);
      typingNew.add(bot);
      mensajeEnvNew.insert(0, m);


    // Obtener el historial de la base de datos
    List<Map<String, dynamic>> historial = await fetchHistorial();

    // Agregar el mensaje actual del usuario al historial
    historial.add({
      "role": "user",
      "parts": [
        {"text": m.text}  // Mensaje actual del usuario
      ]
    });

    // Construir la estructura del JSON para la solicitud
    final requestData = {
      "contents": historial,  // Incluir todo el historial en contents
      "generationConfig": {
        "temperature": 1,
        "topK": 64,
        "topP": 0.95,
        "maxOutputTokens": 8192,
        "responseMimeType": "text/plain"
      },
      "safetySettings": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
      ]
    };

    // Hacer la solicitud HTTP
    final response = await http.post(Uri.parse(ourUrl), headers: header, body: jsonEncode(requestData));
    
    if (response.statusCode == 200) {
      var result = responseChattFromJson(response.body);

      final m1 = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text: result.candidates.first.content.parts.first.text,
      );
      mensajeEnvNew.insert(0, m1);
      mensajeEnv = mensajeEnvNew; // Actualizar el estado con la nueva respuesta del chatbot
      return true; 
    }

    typingNew.remove(bot);
    return false;
  } catch (e) {
    print("Error occurred $e");
    return false;
  }
}



 
List<Map<String, dynamic>> formatMessagesForPrompt(List<Map<String, dynamic>> messages) {
  List<Map<String, dynamic>> formattedMessages = [];

  for (var message in messages) {
    formattedMessages.add({
      "role": message['role'], // Asegúrate de que 'role' esté presente en tus datos
      "parts": [
        {"text": message['text']} // Asegúrate de que 'text' esté presente en tus datos
      ]
    });
  }

  return formattedMessages;
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
  final List<ChatMessage> mensajeEnv; // Mensajes enviados
  final List<ChatUser> typing; // Usuarios escribiendo
  final bool isFirstMessageSent; // Nueva propiedad para verificar el estado del primer mensaje

  ChatbotState({
    this.mensajeEnv = const [],
    this.typing = const [],
    this.isFirstMessageSent = false, // Inicializa como false
  });

  ChatbotState copyWith({
    List<ChatMessage>? mensajeEnv,
    List<ChatUser>? typing,
    bool? isFirstMessageSent, // Agrega este parámetro
  }) {
    return ChatbotState(
      mensajeEnv: mensajeEnv ?? this.mensajeEnv,
      typing: typing ?? this.typing,
      isFirstMessageSent: isFirstMessageSent ?? this.isFirstMessageSent, // Actualiza el estado del primer mensaje
    );
  }
}

