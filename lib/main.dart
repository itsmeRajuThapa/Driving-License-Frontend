import 'package:driver/auth/Internet_cubit/cubit/internet_cubit.dart';
import 'package:driver/entry_screen.dart';
import 'package:driver/home-screen/bloc/home_bloc.dart';
import 'package:driver/practice-screen/bloc/practice_bloc.dart';
import 'package:driver/question-screen/bloc/question_bloc.dart';
import 'package:driver/routes/route_generator.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/services/shared_preference_service.dart';
import 'package:driver/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await locator<SharedPrefsServices>().init();
  final themeProvider = await ThemeProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InternetCubit()),
        BlocProvider<QuestionBloc>(create: (_) => QuestionBloc()),
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<PracticeBloc>(create: (_) => PracticeBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Nepal Driving License App',
                debugShowCheckedModeBanner: false,
                navigatorKey: NavigationService.navigatorKey,
                onGenerateRoute: RouteGenerator.generateRouter,
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                themeMode:
                    themeProvider.themeMode, // Use ThemeProvider's themeMode
                home: const EntryScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
