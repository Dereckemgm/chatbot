import 'package:chat_gpt/ui/pages/chatbot/utils/dialogs.dart';
import 'package:chat_gpt/ui/providers/providers.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view.dart'; // Importa la vista de Home
import 'profile_view.dart'; // Importa la vista de Perfil
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

  int _selectedIndex = 0;  // Variable para almacenar el índice de la vista seleccionada
  final FlutterTts _flutterTts = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;

  ChatUser myself = ChatUser(id: "1", firstName: "User");
  ChatUser bot = ChatUser(id: "2", firstName: "Hannah");
  List<ChatMessage> allMassages = [];
  List<ChatUser> typing = [];
  late final ChatbotController controller; //late, lo que se dice es que espere a que se le asignen datos

  // Lista de las vistas a mostrar en el cuerpo del Scaffold
  static List<Widget> _pages = <Widget>[
    ChatBot(),  // Aquí va tu vista de ChatBot
    HomeView(),     // Vista de Home
    ProfileView(),  // Vista de Perfil
  ];

// Función para manejar el cambio de pestañas en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  void initState() {
    super.initState();
    initTTS();
    controller = ref.read(chatBotStateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //Este metodo se usa para llamar datos despues que se haya construido la pantalla
      controller.getFirstMessage();
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
    const url = "http://127.0.0.1/chatbot_turismo/guardar_mensajes.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user': user,
          'bot': bot,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          print('Mensaje guardado exitosamente');
        } else {
          print('Error al guardar el mensaje: ${data['error']}');
        }
      } else {
        print('Error en la solicitud al servidor');
      }
    } catch (e) {
      print('Error: $e');
    }
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
  final botMessage = stateController.mensajeEnv.first.text;
  await saveMessage(m.text, botMessage);

  // Reproducir automáticamente el mensaje del chatbot
  _flutterTts.speak(botMessage);
  }

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final stateController = ref.watch(chatBotStateProvider);
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 244, 203, 91),
      title: const Text(
        "Chat Bot - turismo",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: size.height * 0.9, // Ocupa el 90% de la altura
              width: size.width,
              child: _selectedIndex == 0 
                ? DashChat(
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
                  )
                : _pages[_selectedIndex], // Muestra la vista correspondiente si no es el chat
            ),
          ),
          Container(
            height: size.height * 0.1, // Ocupa el 10% de la altura
            width: size.width,
            color: Colors.grey, // Cambia el color según lo que necesites
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye los botones de manera uniforme
              children: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  color: Colors.white,
                  onPressed: () {
                    _onItemTapped(0); // Cambia a la vista de chat
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    _onItemTapped(1); // Cambia a la vista de home
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    _onItemTapped(2); // Cambia a la vista de perfil
                  },
                ),
              ],
            ),
          ),
        ],
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