import 'package:flutter/material.dart';

class NavigationState extends InheritedWidget {
  final int selectedIndex;
  final Function(int) updateIndex;

  const NavigationState({
    super.key,
    required this.selectedIndex,
    required this.updateIndex,
    required super.child,
  });

  static NavigationState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationState>();
  }

  @override
  bool updateShouldNotify(NavigationState oldWidget) {
    return selectedIndex != oldWidget.selectedIndex;
  }
}

class NavigationStateProvider extends StatefulWidget {
  final Widget child;

  const NavigationStateProvider({super.key, required this.child});

  @override
  State<NavigationStateProvider> createState() =>
      _NavigationStateProviderState();
}

class _NavigationStateProviderState extends State<NavigationStateProvider> {
  int _selectedIndex = 0;

  void updateIndex(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationState(
      selectedIndex: _selectedIndex,
      updateIndex: updateIndex,
      child: widget.child,
    );
  }
}
