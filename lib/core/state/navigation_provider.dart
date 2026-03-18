import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;
  final List<int> history;

  NavigationState({
    required this.currentIndex,
    required this.history,
  });

  NavigationState copyWith({
    int? currentIndex,
    List<int>? history,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      history: history ?? this.history,
    );
  }

  bool get canGoBack => history.length > 1;
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier()
      : super(NavigationState(currentIndex: 0, history: [0]));

  void navigateToIndex(int index) {
    final newHistory = List<int>.from(state.history)..add(index);
    state = state.copyWith(
      currentIndex: index,
      history: newHistory,
    );
  }

  void goBack() {
    if (state.history.length > 1) {
      final newHistory = List<int>.from(state.history)..removeLast();
      state = state.copyWith(
        currentIndex: newHistory.last,
        history: newHistory,
      );
    }
  }

  void resetToHome() {
    state = NavigationState(currentIndex: 0, history: [0]);
  }
}

final navigationProvider =
StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
);
