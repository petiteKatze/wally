import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:wally/Functions/json_load.dart";
import "package:wally/Screens/full_wall.dart";
import 'package:fluttertoast/fluttertoast.dart';
import "package:wally/utils/themes.dart";

class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<dynamic> walls = [];
  List<dynamic> likes = [];
  int mobColumns = 2;
  @override
  void initState() {
    getColumnsNo();
    checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String brightness = Theme.of(context).brightness.toString();
    return MediaQuery.of(context).size.width < 900
        ? CustomScrollView(
            physics: const BouncingScrollPhysics(),
            key: const ValueKey(
              "home",
            ),
            slivers: [
              SliverAppBar(
                leading: const SizedBox(),
                key: const ValueKey("Sliver App Bar home"),
                stretch: true,
                elevation: 0,
                expandedHeight:
                    MediaQuery.of(context).size.width > 700 ? 600 : 300,
                flexibleSpace: FlexibleSpaceBar(
                  key: const ValueKey("Home top background"),
                  centerTitle: true,
                  background: SvgPicture.asset(
                    "lib/assets/backgrounds/hm.svg",
                    colorFilter: brightness == "Brightness.dark"
                        ? const ColorFilter.mode(
                            Color.fromARGB(68, 0, 0, 0), BlendMode.luminosity)
                        : const ColorFilter.mode(
                            Color.fromARGB(0, 0, 0, 0), BlendMode.darken),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverPadding(
                key: const ValueKey("Wally heading homepage"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wally",
                          style: TextStyle(
                            fontSize: 25,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight
                                : AppColors.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Explore the latest and exclusive wallpapers from Wally. All wallpapers are free for personal use ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight.withOpacity(0.7)
                                : AppColors.textDark.withOpacity(0.7),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                key: const ValueKey("Grid render for homepage"),
                sliver: walls.isNotEmpty
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => InkWell(
                            onTap: () => {},
                            child: InkWell(
                              onDoubleTap: () => {like(index)},
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => FullScreen(
                                              desc: walls[index]["desc"],
                                              imageLink: walls[index]["link"],
                                              name: walls[index]["name"],
                                              tags: walls[index]["catagories"],
                                              variants: walls[index]
                                                  ["variants"],
                                              id: walls[index]["id"],
                                            )))
                              },
                              child: Stack(children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ShaderMask(
                                      shaderCallback: (rect) {
                                        return const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Color.fromARGB(110, 0, 0, 0)
                                          ],
                                        ).createShader(Rect.fromLTRB(0, -140,
                                            rect.width, rect.height - 20));
                                      },
                                      blendMode: BlendMode.darken,
                                      child: CachedNetworkImage(
                                        alignment: Alignment.center,
                                        cacheManager: CacheManager(Config(
                                            maxNrOfCacheObjects: 20,
                                            "Featured",
                                            stalePeriod:
                                                const Duration(days: 4))),
                                        filterQuality: FilterQuality.low,
                                        imageUrl: walls[index]["link"],
                                        imageBuilder: (ctx, imageProvider) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (ctx, url) => Container(
                                          color:
                                              brightness == "Brightness.light"
                                                  ? AppColors.scaffoldLight
                                                  : AppColors.scaffoldDark,
                                          alignment: Alignment.center,
                                          child: LoadingAnimationWidget
                                              .discreteCircle(
                                            size: 20,
                                            color: const Color.fromARGB(
                                                255, 226, 79, 42),
                                          ),
                                        ),
                                      )),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 5,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  walls[index]["name"]
                                                      .toString(),
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Text(
                                                      walls[index]["desc"]
                                                          .toString(),
                                                      maxLines: mobColumns == 1
                                                          ? 2
                                                          : 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.7))),
                                                )
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                like(index);
                                              },
                                              icon: checkPres(
                                                          walls[index]["id"]) ==
                                                      false
                                                  ? PhosphorIcon(
                                                      PhosphorIcons
                                                          .regular.heart,
                                                      color: Colors.white)
                                                  : PhosphorIcon(
                                                      PhosphorIcons.fill.heart,
                                                      color: const Color(
                                                          0xFFDCB3E9)))
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          ),
                          childCount: walls.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width < 700
                                  ? mobColumns
                                  : 3,
                          childAspectRatio:
                              MediaQuery.of(context).size.width < 700
                                  ? 9 / 16
                                  : 3 / 4,
                          mainAxisSpacing:
                              MediaQuery.of(context).size.width < 700 ? 15 : 25,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width < 700 ? 8 : 15,
                        ))
                    : SliverToBoxAdapter(
                        key: const ValueKey("Null object"),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.discreteCircle(
                                  size: 40,
                                  color: Colors.pink,
                                  secondRingColor: Colors.purple,
                                  thirdRingColor: Colors.red),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Refreshing Wallpapers"),
                            ],
                          ),
                        ),
                      ),
                padding:
                    const EdgeInsets.only(left: 15, right: 15, bottom: 100),
              )
            ],
          )
        : Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset(
                  "lib/assets/backgrounds/hm.svg",
                  // colorFilter: ColorFilter.mode(
                  //     Color.fromARGB(68, 0, 0, 0), BlendMode.luminosity),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  key: const ValueKey("Tablet view right column home"),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      const SliverPadding(
                        key: ValueKey("Wally heading homepage"),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wally",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Explore the latest and exclusive wallpapers from Wally ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => InkWell(
                                onTap: () => {},
                                child: InkWell(
                                  key: ValueKey(
                                      '$index+HomePage Tablet view Object'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => FullScreen(
                                                  desc: walls[index]["desc"],
                                                  imageLink: walls[index]
                                                      ["link"],
                                                  name: walls[index]["name"],
                                                  tags: walls[index]
                                                      ["catagories"],
                                                  variants: walls[index]
                                                      ["variants"],
                                                  id: walls[index]["id"],
                                                )));
                                  },
                                  child: Stack(children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: ShaderMask(
                                          shaderCallback: (rect) {
                                            return const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                Color.fromARGB(91, 0, 0, 0)
                                              ],
                                            ).createShader(Rect.fromLTRB(
                                                0,
                                                -140,
                                                rect.width,
                                                rect.height - 20));
                                          },
                                          blendMode: BlendMode.darken,
                                          child: CachedNetworkImage(
                                            cacheManager: CacheManager(Config(
                                                "Featured",
                                                maxNrOfCacheObjects: 30,
                                                stalePeriod:
                                                    const Duration(days: 4))),
                                            filterQuality: FilterQuality.medium,
                                            imageUrl: walls[index]["link"],
                                            imageBuilder:
                                                (ctx, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (ctx, url) =>
                                                Container(
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: LoadingAnimationWidget
                                                  .discreteCircle(
                                                      size: 20,
                                                      color: Colors.white),
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left: 5,
                                        right: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                walls[index]["name"].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    Vibrate.feedback(
                                                        FeedbackType.success);
                                                    await FileManager()
                                                        .addToLike(
                                                            walls[index]);
                                                    setState(() {
                                                      getLikesList();
                                                    });
                                                    // await FileManager().readLikes();
                                                  },
                                                  icon: checkPres(walls[index]
                                                              ["id"]) ==
                                                          false
                                                      ? PhosphorIcon(
                                                          PhosphorIcons
                                                              .regular.heart,
                                                          color: Colors.white)
                                                      : PhosphorIcon(
                                                          PhosphorIcons
                                                              .fill.heart,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              217, 130, 228)))
                                            ],
                                          ),
                                        ))
                                  ]),
                                ),
                              ),
                              childCount: walls.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width < 700
                                      ? 2
                                      : 3,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width < 700
                                      ? 9 / 16
                                      : 3 / 4,
                              mainAxisSpacing:
                                  MediaQuery.of(context).size.width < 700
                                      ? 4
                                      : 15,
                              crossAxisSpacing:
                                  MediaQuery.of(context).size.width < 700
                                      ? 4
                                      : 15,
                            )),
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 100),
                      )
                    ],
                  ))
            ],
          );
  }

  getInfo() async {
    List<dynamic> data = await FileManager().getFaetured();
    setState(() {
      walls = data;
      walls.shuffle();
    });
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

  checkPermissions() async {
    getLikesList();
    getInfo();
  }

  getColumnsNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? columns = prefs.getInt("mobColumns");
    if (columns != null) {
      setState(() {
        mobColumns = columns;
      });
    }
  }

  like(int index) async {
    Vibrate.feedback(FeedbackType.success);
    await FileManager().addToLike(walls[index]);
    checkPres(index) == false
        ? Fluttertoast.showToast(
            msg: "Added to Liked",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM_LEFT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0)
        : Fluttertoast.showToast(
            msg: "Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    setState(() {
      getLikesList();
    });
  }
}
