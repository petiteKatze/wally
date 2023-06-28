import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wally/Screens/Splash/splash_screen.dart';
import 'package:wally/utils/config.dart';
import 'package:wally/utils/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const AppBegin());
}

class AppBegin extends StatefulWidget {
  const AppBegin({super.key});

  @override
  State<AppBegin> createState() => _AppBeginState();
}

class _AppBeginState extends State<AppBegin> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      home: const SplashScreen(),
      themeMode: currentTheme.currentTheme(),
    );
  }
}
