import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int selectedIndex;

  NavigationState({this.selectedIndex = 0});
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState());

  void selectTab(int index) {
    state = NavigationState(selectedIndex: index);
  }
}

// Crea un provider para NavigationNotifier
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
