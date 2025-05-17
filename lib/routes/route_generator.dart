import 'package:driver/home-screen/screen/home_screen.dart';
import 'package:driver/home-screen/screen/vision_screen.dart';
import 'package:driver/practice-screen/screen/practice_screen.dart';
import 'package:driver/question-screen/screen/question_screen.dart';
import 'package:driver/routes/route_name.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  RouteGenerator._();
  static Route<dynamic>? generateRouter(RouteSettings settings) {
    Object? arguments = settings.arguments;
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case Routes.practiceScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PracticeScreen(),
        );

      case Routes.questionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuestionScreen(title: arguments.toString()),
        );
      case Routes.colorVisionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ColorVisionScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
