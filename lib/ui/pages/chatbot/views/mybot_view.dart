import 'package:chat_gpt/ui/pages/chatbot/utils/dialogs.dart';
import 'package:chat_gpt/ui/providers/providers.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../chatbot_controller.dart';

//el consumer se usa para poder trabajar el gestor de estados rivepood
class ChatBot extends ConsumerStatefulWidget {
  const ChatBot({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {

  final FlutterTts _flutterTts = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;

  ChatUser myself = ChatUser(id: "1", firstName: "User");
  ChatUser bot = ChatUser(id: "2", firstName: "Hannah");
  List<ChatMessage> allMassages = [];
  List<ChatUser> typing = [];
  late final ChatbotController controller; //late, lo que se dice es que espere a que se le asignen datos


  
  @override
  void initState() {
    super.initState();
    initTTS();
    controller = ref.read(chatBotStateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //Este metodo se usa para llamar datos despues que se haya construido la pantalla
       ref.read(chatBotStateProvider.notifier).init();
    });
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices = voices.where((voice) => voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

 Future<void> saveMessage(String user, String bot) async {
  const url = "http://localhost:3000/chats/mensajes"; // Cambia localhost por esta IP si usas un emulador
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'mensaje_usuario': user,      // Cambiado a 'mensaje_usuario'
        'respuesta_chatbot': bot,     // Cambiado a 'respuesta_chatbot'
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print('Mensaje guardado exitosamente');
      } else {
        print('Error al guardar el mensaje: ${data['message']}');
      }
    } else {
      print('Error en la solicitud al servidor: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}'); // Manten esta línea para ver la respuesta
    }
  } catch (e) {
    print('Error: $e');
  }
}

 // Función para limpiar la respuesta del chatbot
  String cleanResponse(String response) {
    // Elimina caracteres no deseados
    return response.replaceAll(RegExp(r'<ctrl\d+>|[\u3130-\u318F\uAC00-\uD7A3]+'), '');
  }



  getDataMessage(ChatMessage m) async {
    typing.add(bot);
    setState(() {});

    final response = await controller.getData(m);
    typing.remove(bot);
    setState(() {});

    if (!response && mounted) {
      showdialogError(context);
      return;
    }

    final stateController = ref.watch(chatBotStateProvider);
// Obtener y guardar el mensaje del bot y del user
  final botMessage = cleanResponse(stateController.mensajeEnv.first.text); // Limpiar el mensaje
  await saveMessage(m.text, botMessage);

  // Reproducir automáticamente el mensaje del chatbot
  _flutterTts.speak(botMessage);
  }


 @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final stateController = ref.watch(chatBotStateProvider);

  return SafeArea(
    child: Scaffold( // Asegúrate de envolverlo en un Scaffold para usar el floatingActionButton
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: DashChat(
          inputOptions: const InputOptions(
            sendOnEnter: true,
            cursorStyle: CursorStyle(color: Colors.black),
          ),
          messageOptions: MessageOptions(
            showTime: true,
            textColor: Colors.black,
            containerColor: const Color.fromARGB(204, 227, 207, 118),
            currentUserContainerColor: const Color.fromARGB(255, 181, 115, 40),
            avatarBuilder: yourAvatarBuilder,
          ),
          typingUsers: typing,
          currentUser: controller.usuario,
          onSend: getDataMessage,
          messages: stateController.mensajeEnv,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Obtener el último mensaje del chatbot
              final lastBotMessage = stateController.mensajeEnv.first.text;
              // Hablar el último mensaje del chatbot
              _flutterTts.speak(lastBotMessage);
            },
            child: const Icon(
              Icons.speaker_phone,
            ),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // Detener la reproducción del mensaje del chatbot
              _flutterTts.stop();
            },
            child: const Icon(
              Icons.stop,
            ),
          ),
        ],
      ),
    ),
  );
}




  Widget yourAvatarBuilder(ChatUser user, Function? onAvatarTap, Function? onAvatarLongPress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: SizedBox.fromSize(
          size: const Size.fromRadius(15),
          child: Image.asset(
            'assets/Hannah.png',
            height: 30,
            width: 30,
          ),
        ),
      ),
    );
  }
}