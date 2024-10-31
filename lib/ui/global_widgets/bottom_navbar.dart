import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; // Índice de la pestaña seleccionada
  final Function(int) onTabSelected; // Callback para la selección de tab

  const BottomNavBar({Key? key, required this.selectedIndex, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 53),
      height: 82,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onTabSelected(0),
            child: SvgPicture.asset(
              selectedIndex == 0 ? 'icons/messages_selected_icon.svg' : 'icons/messages_unselected_icon.svg',
            ),
          ),
          GestureDetector(
            onTap: () => onTabSelected(1),
            child: SvgPicture.asset(
              selectedIndex == 1 ? 'icons/home_selected_icon.svg' : 'icons/home_unselected_icon.svg',
            ),
          ),
          GestureDetector(
            onTap: () => onTabSelected(2),
            child: SvgPicture.asset(
              selectedIndex == 2 ? 'icons/bookmark_selected_icon.svg' : 'icons/bookmark_unselected_icon.svg',
            ),
          ),
          GestureDetector(
            onTap: () => onTabSelected(3),
            child: SvgPicture.asset(
              selectedIndex == 3 ? 'icons/profile_selected_icon.svg' : 'icons/profile_unselected_icon.svg',
            ),
          ),
        ],
      ),
    );
  }
}
