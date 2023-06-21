
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
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
            "lib/assets/backgrounds/splash_screen.svg",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "lib/assets/logos/transLog.svg",
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              const SizedBox(
                height: 20,
              ),
              const CupertinoActivityIndicator(
                color: Colors.white,
              )
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const Home()));
  }
}
