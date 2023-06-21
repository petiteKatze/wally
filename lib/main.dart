import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wally/Screens/Splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const AppBegin());
}

class AppBegin extends StatelessWidget {
  const AppBegin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
