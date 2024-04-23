import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'utils/helper.dart';

class ChatbotController extends StateNotifier<ChatbotState>{

  ChatbotController(): super(ChatbotState());

  set typing(List<ChatUser> data) => state = state.copyWith(typing: data);
  set mensajeEnv(List<ChatMessage> dataM) => state = state.copyWith(mensajeEnv: dataM);
  set showInitialMessage(bool dataIM) => state = state.copyWith(showInitialMessage: dataIM);
  
getData(ChatMessage m) async {
  ChatUser bot = ChatUser(id: "2", firstName: "Hannah");
  List<ChatMessage> mensajeEnv = [];
  List<ChatUser> typing=[];



    typing.add(bot);
    mensajeEnv.insert(0, m);
    //setState(() {

    //});
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
    //setState(() {

    //});
  }

}

class ChatbotState {
  final List<ChatMessage> mensajeEnv;
  final List<ChatUser> typing;
  final bool showInitialMessage;

  ChatbotState({ this.mensajeEnv= const [],  this.typing= const [],  this.showInitialMessage= true});

  ChatbotState copyWith ({List<ChatMessage> ?mensajeEnv, List<ChatUser> ?typing,  bool ?showInitialMessage}){
    return ChatbotState(
      mensajeEnv : mensajeEnv ?? this.mensajeEnv,
      typing: typing ?? this.typing,
      showInitialMessage: showInitialMessage ?? this.showInitialMessage,
    );
  }
}