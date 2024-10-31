import 'package:chat_gpt/ui/pages/chatbot/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt/ui/global_widgets/global_widgets.dart';
import '../pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt/ui/providers/navigation_provider.dart'; // Asegúrate de importar el provider

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider); // Obtenemos el estado de navegación

    return Scaffold(
      appBar: AppBar(
   
      ),
      body: _pages[navState.selectedIndex], // Muestra la página seleccionada
      bottomNavigationBar: BottomNavBar(
        selectedIndex: navState.selectedIndex, // Pasa el índice seleccionado
        onTabSelected: (index) {
          ref.read(navigationProvider.notifier).selectTab(index); // Actualiza el índice
        },
      ),
    );
  }
}

final List<Widget> _pages = [
  ChatBot(),
  HomeView(), // Pantalla de inicio
  BookmarkView(), // Pantalla de marcadores
  ProfileView(), // Pantalla de perfil
];
