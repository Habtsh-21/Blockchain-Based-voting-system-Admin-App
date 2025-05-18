import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  String? title;
  NavigationState({this.title});
}

class HomePageState implements NavigationState {
  @override
  String? title;

  HomePageState({this.title});
}

class ElectionState implements NavigationState {
  @override
  String? title;
  ElectionState({this.title});
}

class VoterState implements NavigationState {
  @override
  String? title;
  VoterState({this.title});
}

class ResultState implements NavigationState {
  @override
  String? title;
  ResultState({this.title});
}

class SettingState implements NavigationState {
  @override
  String? title;
  SettingState({this.title});
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(HomePageState(title: 'Admin Dashboard'));

  void changeState(int index) {
    if (index == 0) {
      state = HomePageState(title: 'Admin Dashboard');
    } else if (index == 1) {
      state = ElectionState(title: "Election");
    } else if (index == 2) {
      state = VoterState(title: "Voters Info");
    } else if (index == 3) {
      state = ResultState(title: "Result");
    } else if (index == 4) {
      state = SettingState(title: "Setting");
    } else {
      state = HomePageState(title: "Admin Dashboard");
    }
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
