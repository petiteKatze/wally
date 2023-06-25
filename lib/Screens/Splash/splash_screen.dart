import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:wally/Functions/json_load.dart";

import "package:wally/Screens/Home/home.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SvgPicture.asset(
            MediaQuery.of(context).size.width < 600
                ? "lib/assets/backgrounds/splash_screen.svg"
                : "lib/assets/backgrounds/wideSplas.svg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Opacity(
            opacity: 0.4,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("lib/assets/backgrounds/noise.png")),
                )),
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "lib/assets/logos/transLog.svg",
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              const SizedBox(
                height: 20,
              ),
              LoadingAnimationWidget.inkDrop(
                size: 20,
                color: Colors.white,
              ),
            ],
          )),
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 40,
              child: Text(
                "version 1.0.0",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  getStarted() async {
    await FileManager().appInitCheck();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const Home()));
  }
}
