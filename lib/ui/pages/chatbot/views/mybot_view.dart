import 'package:chat_gpt/ui/pages/chatbot/utils/dialogs.dart';
import 'package:chat_gpt/ui/providers/providers.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chatbot_controller.dart';

//el consumer se usa para poder trabajar el gestor de estados rivepood
class ChatBot extends ConsumerStatefulWidget {
  const ChatBot({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {
  late final ChatbotController controller; //late, lo que se dice es que espere a que se le asignen datos
  @override
  void initState() {
    super.initState();

    controller = ref.read(chatBotStateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //Este metodo se usa para llamar datos despues que se haya construido la pantalla
      controller.getFirstMessage();
    });
  }

  getDataMessage(ChatMessage m) async {
    final response = await controller.getData(m);
    if (!response && mounted) {
      showdialogError(context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stateController = ref.watch(chatBotStateProvider); //Es para escuychar los cambios de las variables que estan en tu estado.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Chat Bot - turismo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
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
            typingUsers: stateController.typing,
            currentUser: controller.usuario,
            onSend: getDataMessage,
            messages: stateController.mensajeEnv,
          ),
        ),
      ),
    );
  }

  Widget yourAvatarBuilder(ChatUser user, Function? onAvatarTap, Function? onAvatarLongPress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Image border
        child: SizedBox.fromSize(
          size: const Size.fromRadius(15), // Image radius
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
