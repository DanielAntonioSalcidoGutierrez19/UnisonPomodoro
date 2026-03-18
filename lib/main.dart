import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/principal.dart';
import 'screens/configuracion_pomodoro.dart';
import 'screens/theme_colors.dart';
import 'package:flutter_design_trivia/screens/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Pomodoro UNISON',

      theme: ThemeData(

        scaffoldBackgroundColor: AppColors.paper,

        textTheme: GoogleFonts.patrickHandTextTheme(),

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.workColor,
        ),

      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const Principal(),
        '/config': (context) => const ConfiguracionPomodoro(),
      },
    );
  }
}