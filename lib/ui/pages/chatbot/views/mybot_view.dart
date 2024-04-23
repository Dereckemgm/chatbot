import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/helper.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser usuario = ChatUser(id: "1", firstName: "User");
  ChatUser bot = ChatUser(id: "2", firstName: "Hannah");
  List<ChatMessage> mensajeEnv = [];
  List<ChatUser> typing=[];
  bool showInitialMessage = true;
  

  getData(ChatMessage m) async {
    typing.add(bot);
    mensajeEnv.insert(0, m);
    setState(() {

    });
    await http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(getPropmt(m.text))).
    then((value){
      if(value.statusCode==200){
        var result=jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1=ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        mensajeEnv.insert(0, m1);

      }else{
        print("Error occurred");
      }
    }).
    catchError((e){});
    typing.remove(bot);
    setState(() {

    });
  }

obtenerPrimerMensaje() {
    
   var data;
   String mensaje = "No funcionó";
    data={"contents":[{"parts":[{"text":"Eres Hanna, un asistente amable que trabaja para TouriC. TouriC es una aplicación movil que ayuda a los turistas que visitan cartagena a recomendarles sitios turisticos, restaurantes, horarios de sitios historicos, etc. Después de primero ofrecerles unas palabras de saludo, esperaras a que ellos te comenten lo que necesitan ayuda con respecto a la ciudad Cartagena de indias, o sugerencias para planes de turismo en la ciudad. Les vas a dar un saludo amable. Utiliza un solo parrafo y menos de 40 palabras."}],
        }]};
    http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(data)).
    then((value){
        var result=jsonDecode(value.body);
        mensaje = result["candidates"][0]["content"]["parts"][0]["text"];
        print(mensaje); 

        setState(() {
        mensajeEnv.insert(0, ChatMessage(
          text: mensaje,
          user: bot,
          createdAt: DateTime.now(),
        ));
        showInitialMessage = false;
      });
    });
}
 @override
  void initState() {
    super.initState();
    if (showInitialMessage) {
    obtenerPrimerMensaje();
    }
  }

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      // Your app bar configuration (optional)
    ),
    body: SafeArea(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: DashChat (
          // Your existing DashChat configuration
          
          inputOptions: InputOptions(
            sendOnEnter: true,
            cursorStyle: CursorStyle(color: Colors.black),
          ),
          messageOptions: MessageOptions(
            showTime: true,
            textColor: Colors.black,
            containerColor: Color.fromARGB(204, 227, 207, 118),
            currentUserContainerColor: Color.fromARGB(255, 181, 115, 40),
            avatarBuilder: yourAvatarBuilder,
          ),
          typingUsers: typing,
          currentUser: usuario,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: mensajeEnv,
        ),
      ),
    ),
  );
}
  Widget yourAvatarBuilder(ChatUser user,Function? onAvatarTap, Function? onAvatarLongPress){
    return Center(child: ClipRRect(
  borderRadius: BorderRadius.circular(20), // Image border
  child: SizedBox.fromSize(
    size: Size.fromRadius(25), // Image radius
    child: Image.asset('Hannah.png',height: 40,width: 40,),
  ),
));
  }
}
