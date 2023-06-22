import 'package:async_wallpaper/async_wallpaper.dart';
import "package:flutter/services.dart";
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Screens/Home/home.dart";

import "../Functions/json_load.dart";

class FullScreen extends StatefulWidget {
  final String imageLink;
  final String name;
  final String desc;
  final List<dynamic> variants;
  final List<dynamic> tags;
  final int id;
  const FullScreen(
      {required this.imageLink,
      required this.desc,
      required this.name,
      required this.tags,
      required this.variants,
      required this.id,
      super.key});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  List<dynamic> likes = [];
  var disImage="";
  double aniHeight = 50;

  bool hide = true;
  @override
  void initState() {
    getLikesList();
    setState(() {
      disImage = widget.imageLink;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => const Home()));
            },
            icon: PhosphorIcon(
              PhosphorIcons.regular.caretLeft,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            imageUrl: disImage,
            placeholder: (context, url) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
          Positioned(
              bottom: 0,
              child: AnimatedContainer(
                  curve: Curves.bounceOut,
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.2),
                          blurRadius: 100.0, // soften the shadow
                          spreadRadius: 30.0, //extend the shadow
                          offset: const Offset(
                            0.0,
                            -2.0,
                          ),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  width: MediaQuery.of(context).size.width,
                  height: aniHeight,
                  child: !hide
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Vibrate.feedback(FeedbackType.success);
                                    setState(() {
                                      aniHeight = 50;
                                      hide = true;
                                    });
                                  },
                                  icon: PhosphorIcon(
                                      PhosphorIcons.regular.caretDown)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.desc,
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        Vibrate.feedback(FeedbackType.success);
                                        await FileManager().addToLike({
                                          "id": widget.id,
                                          "name": widget.name,
                                          "catagories": widget.tags,
                                          "desc": widget.desc,
                                          "link": widget.imageLink,
                                          "varaints": widget.variants
                                        });
                                        setState(() {
                                          getLikesList();
                                        });

                                        // await FileManager().readLikes();
                                      },
                                      icon: checkPres(widget.id) == false
                                          ? PhosphorIcon(
                                              PhosphorIcons.regular.heart,
                                              color: Colors.red)
                                          : PhosphorIcon(
                                              PhosphorIcons.fill.heart,
                                              color: Colors.red))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.variants.isNotEmpty
                                      ? Row(
                                          children: [
                                            for (var i in widget.variants)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      disImage = i.values.first;
                                                      Vibrate.feedback(
                                                          FeedbackType.success);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.black54),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Color(int.parse(
                                                          'FF${i.keys.first}',
                                                          radix: 16)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        )
                                      : const Text("No variants available"),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        for (var j in widget.tags)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Text('#$j'),
                                          )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              CupertinoAlertDialog(
                                                title: const Text("Set Wallpaper"),
                                                content: const Text(
                                                    "You can chose where to set the wallpaper,The wallpaper is automatically downloaded as well"),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: const Text("Home Screen"),
                                                    onPressed: () async {
                                                      var file =
                                                          await DefaultCacheManager()
                                                              .getSingleFile(
                                                                  disImage);
                                                    
                                                      try {
                                                        await AsyncWallpaper
                                                                .setWallpaperFromFileNative(
                                                          goToHome: true,
                                                        
                                                          filePath: file.path,
                                                          toastDetails:
                                                              ToastDetails
                                                                  .success(),
                                                          errorToastDetails:
                                                              ToastDetails
                                                                  .error(),
                                                        )
                                                            ? 'Wallpaper set'
                                                            : 'Failed to get wallpaper.';
                                                      } on PlatformException {
                                                       
                                                      }
                                                    },
                                                  ),
                                                  const CupertinoDialogAction(
                                                      child:
                                                          Text("Lock SCreen")),
                                                  const CupertinoDialogAction(
                                                      child: Text("Both")),
                                                ],
                                              ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "Set Wallpaper",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: IconButton(
                              onPressed: () {
                                Vibrate.feedback(FeedbackType.success);
                                setState(() {
                                  aniHeight = 300;
                                  hide = false;
                                });
                              },
                              icon:
                                  PhosphorIcon(PhosphorIcons.regular.caretUp)),
                        )))
        ],
      ),
    );
  }

  getLikesList() async {
    List<dynamic> dat = await FileManager().readLikes();
    setState(() {
      likes = dat;
    });
  }

  bool checkPres(int id) {
    for (var i = 0; i < likes.length; i++) {
      if (id == likes[i]["id"]) {
        return true;
      }
    }

    return false;
  }
}
