import 'package:driver/home-screen/bloc/home_bloc.dart';
import 'package:driver/practice-screen/bloc/practice_bloc.dart';
import 'package:driver/question-screen/bloc/question_bloc.dart';
import 'package:driver/services/api_handling/api_manager.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/shared_preference_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<SharedPrefsServices>(SharedPrefsServices());
  locator.registerSingleton<ApiManager>(ApiManager());
  locator.registerLazySingleton<HomeBloc>(() => HomeBloc());
  locator.registerLazySingleton<QuestionBloc>(() => QuestionBloc());
  locator.registerLazySingleton<PracticeBloc>(() => PracticeBloc());
}
