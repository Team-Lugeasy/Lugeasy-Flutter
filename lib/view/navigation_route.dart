import 'package:flutter/material.dart';
import 'package:lugeasy/view/alarm/alarm_view.dart';
import 'package:lugeasy/view/login/login_view.dart';
import 'package:lugeasy/view/main/main_container_view.dart';
import 'package:lugeasy/view/search/search_view.dart';

class NavigationRoute {
  static const String login = '/login';
  static const String mainContainer = '/mainContainer';
  static const String search = '/search';
  static const String alarm = '/alarm';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginView(),
    mainContainer: (context) => const MainContainerView(),
    search: (context) => const SearchView(),
    alarm: (context) => const AlarmView(),
  };
}
