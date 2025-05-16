import 'package:driver/home-screen/bloc/home_bloc.dart';
import 'package:driver/home-screen/screen/home_screen.dart';
import 'package:driver/practice-screen/bloc/practice_bloc.dart';
import 'package:driver/question-screen/bloc/question_bloc.dart';
import 'package:driver/routes/route_generator.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/services/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then((value) => locator<SharedPrefsServices>().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuestionBloc>(create: (_) => QuestionBloc()),
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<PracticeBloc>(create: (_) => PracticeBloc()),
      ],
      child: MaterialApp(
        title: 'Nepal Driving License App',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRouter,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 161, 135, 205),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
