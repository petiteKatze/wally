import 'package:async_wallpaper/async_wallpaper.dart';

import "package:flutter/services.dart";
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:material_dialogs/dialogs.dart";
import "package:material_dialogs/widgets/buttons/icon_outline_button.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Screens/Home/home.dart";
import "package:wally/utils/themes.dart";

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
  var disImage = "";
  double aniHeight = 50;
  double aniWidth = 50;
  int selectedVariant = 0;

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
    String brightness = Theme.of(context).brightness.toString();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.name.toString(),
          style: const TextStyle(color: Colors.white),
        ),
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
            cacheManager: CacheManager(
                Config("Featured", stalePeriod: const Duration(minutes: 2))),
            key: ValueKey(
                '${widget.id}+${widget.name}+${widget.tags}Full Screen'),
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
          MediaQuery.of(context).size.width < 900
              ? Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width > 600 ? 100 : 0,
                  right: MediaQuery.of(context).size.width > 600 ? 100 : 0,
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
                          color: brightness == "Brightness.light"
                              ? AppColors.scaffoldLight
                              : AppColors.scaffoldDark,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      width: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width,
                      height: aniHeight,
                      child: !hide
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Vibrate.feedback(FeedbackType.success);
                                        setState(() {
                                          hide = true;
                                          aniHeight = 50;
                                        });
                                      },
                                      icon: PhosphorIcon(
                                          PhosphorIcons.regular.caretDown)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.name.toString(),
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: brightness ==
                                                        "Brightness.light"
                                                    ? AppColors.textLight
                                                    : AppColors.textDark,
                                              ),
                                            ),
                                            Text(
                                              widget.desc.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: brightness ==
                                                          "Brightness.light"
                                                      ? AppColors.textLight
                                                      : AppColors.textDark,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            Vibrate.feedback(
                                                FeedbackType.success);
                                            await FileManager().addToLike({
                                              "id": widget.id,
                                              "name": widget.name,
                                              "catagories": widget.tags,
                                              "desc": widget.desc,
                                              "link": widget.imageLink,
                                              "variants": widget.variants
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          "Variants",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color:
                                                brightness == "Brightness.light"
                                                    ? AppColors.textLight
                                                    : AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      widget.variants.isNotEmpty
                                          ? Row(
                                              children: [
                                                for (var i in widget.variants)
                                                  Opacity(
                                                    key: ValueKey(
                                                        '$i+${widget.id}+${widget.name}'),
                                                    opacity: selectedVariant ==
                                                            widget.variants
                                                                .indexOf(i)
                                                        ? 1
                                                        : 0.5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedVariant =
                                                                widget.variants
                                                                    .indexOf(i);
                                                          });
                                                          setState(() {
                                                            disImage =
                                                                i.values.first;
                                                            Vibrate.feedback(
                                                                FeedbackType
                                                                    .success);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              width: selectedVariant ==
                                                                      widget
                                                                          .variants
                                                                          .indexOf(
                                                                              i)
                                                                  ? 2
                                                                  : 0.5,
                                                              color: brightness ==
                                                                      "Brightness.light"
                                                                  ? AppColors
                                                                      .textLight
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : AppColors
                                                                      .textDark
                                                                      .withOpacity(
                                                                          0.5),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Color(int.parse(
                                                                'FF${i.keys.first}',
                                                                radix: 16)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            )
                                          : Text(
                                              "No variants available",
                                              style: TextStyle(
                                                color: brightness ==
                                                        "Brightness.light"
                                                    ? AppColors.textLight
                                                    : AppColors.textDark,
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          children: [
                                            for (var j in widget.tags)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: Text(
                                                  '#${j.toString()}',
                                                  style: TextStyle(
                                                    color: brightness ==
                                                            "Brightness.light"
                                                        ? AppColors.textLight
                                                        : AppColors.textDark,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? 20
                                                : 0,
                                      ),
                                      InkWell(
                                        splashColor: Colors.grey,
                                        enableFeedback: true,
                                        onTap: () {
                                          Dialogs.materialDialog(
                                              msg:
                                                  "Go ahead and apply the wallpaper for your device, you can set it for the home screen and lockscreen as per as your device on the next screen. ",
                                              title: "Set Wallpaper",
                                              actions: [
                                                IconsOutlineButton(
                                                  iconData: Icons.check,
                                                  text: "Go ahead",
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
                                                      );
                                                    } on PlatformException {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Sorry, Try again",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .SNACKBAR,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  },
                                                ),
                                              ],
                                              context: context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                brightness == "Brightness.light"
                                                    ? AppColors.textLight
                                                    : AppColors.textDark,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Text(
                                                "Set Wallpaper",
                                                style: TextStyle(
                                                  color: brightness ==
                                                          "Brightness.dark"
                                                      ? AppColors.textLight
                                                      : AppColors.textDark,
                                                ),
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
                                  icon: PhosphorIcon(
                                      PhosphorIcons.regular.caretUp)),
                            )))
              : Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.bounceOut,
                    width: aniWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    ),
                    child: hide
                        ? Center(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = false;
                                    aniWidth = 400;
                                  });
                                },
                                icon: PhosphorIcon(
                                    PhosphorIcons.regular.caretLeft)),
                          )
                        : Expanded(
                            child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          hide = true;
                                          aniWidth = 50;
                                        });
                                      },
                                      icon: PhosphorIcon(
                                          PhosphorIcons.regular.caretRight)),
                                ),
                              ),
                              SizedBox(
                                width: 340,
                                height: MediaQuery.of(context).size.height,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name.toString(),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(widget.desc.toString()),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text("Variants"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        widget.variants.isNotEmpty
                                            ? Column(
                                                children: [
                                                  for (var i in widget.variants)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            disImage =
                                                                i.values.first;
                                                            Vibrate.feedback(
                                                                FeedbackType
                                                                    .success);
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black54),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Color(
                                                                    int.parse(
                                                                        'FF${i.keys.first}',
                                                                        radix:
                                                                            16)),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                ' #${i.keys.first.toString()}')
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              )
                                            : const Text(
                                                "No variants available for this wallpaper"),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            children: [
                                              for (var j in widget.tags)
                                                Padding(
                                                  key: ValueKey(
                                                      '$j+${widget.id}+${widget.name}'),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(
                                                              30, 155, 39, 176),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                            child: Text(
                                                                '#${j.toString()}')),
                                                      )),
                                                )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    CupertinoAlertDialog(
                                                      title: const Text(
                                                          "Set Wallpaper"),
                                                      content: const Text(
                                                          "You can chose where to set the wallpaper,The wallpaper is automatically downloaded as well"),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          child: const Text(
                                                              "Set Wallpaper"),
                                                          onPressed: () async {
                                                            var file =
                                                                await DefaultCacheManager()
                                                                    .getSingleFile(
                                                                        disImage);

                                                            try {
                                                              await AsyncWallpaper
                                                                      .setWallpaperFromFileNative(
                                                                goToHome: true,
                                                                filePath:
                                                                    file.path,
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
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Sorry, Try again",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .SNACKBAR,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          },
                                                        ),
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
                                                  "Set Wallpaper / Download",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          )),
                  ))
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
