import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Functions/json_load.dart";
import "package:wally/Screens/full_wall.dart";

import "../../utils/themes.dart";

class Favs extends StatefulWidget {
  const Favs({super.key});

  @override
  State<Favs> createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  List<dynamic> walls = [];
  @override
  void initState() {
    getLikes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String brightness = Theme.of(context).brightness.toString();
    return MediaQuery.of(context).size.width < 900
        ? CustomScrollView(
            physics: const BouncingScrollPhysics(),
            key: const ValueKey("Favorites"),
            slivers: [
              SliverAppBar(
                leading: const SizedBox(),
                stretch: true,
                elevation: 0,
                pinned: false,
                centerTitle: true,
                expandedHeight:
                    MediaQuery.of(context).size.width > 700 ? 600 : 300,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: SvgPicture.asset(
                    "lib/assets/backgrounds/liked.svg",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Liked Album",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                        ),
                        Text(
                          "All those you liked :)",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: brightness == "Brightness.light"
                                ? AppColors.textLight.withOpacity(0.7)
                                : AppColors.textDark.withOpacity(0.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              walls.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.only(
                          bottom: 80, left: 15, right: 15),
                      sliver: SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing:
                                MediaQuery.of(context).size.width > 600
                                    ? 15
                                    : 8,
                            mainAxisSpacing:
                                MediaQuery.of(context).size.width > 600
                                    ? 15
                                    : 8,
                            childAspectRatio: 9 / 16,
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600
                                    ? 3
                                    : 2),
                        itemBuilder: (ctx, idx) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => FullScreen(
                                          key: ValueKey('$idx+Favoriite1'),
                                          desc: walls[idx]["desc"],
                                          imageLink: walls[idx]["link"],
                                          name: walls[idx]["name"],
                                          tags: walls[idx]["catagories"],
                                          variants: walls[idx]["variants"],
                                          id: walls[idx]["id"],
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
                                        0, -140, rect.width, rect.height - 20));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: CachedNetworkImage(
                                    cacheManager: CacheManager(Config(
                                        "Featured",
                                        maxNrOfCacheObjects: 10,
                                        stalePeriod: const Duration(days: 10))),
                                    filterQuality: FilterQuality.medium,
                                    imageUrl: walls[idx]["link"],
                                    imageBuilder: (ctx, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (ctx, url) => Container(
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                              size: 20, color: Colors.white),
                                    ),
                                  )),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 5,
                                right: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        walls[idx]["name"].toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            Vibrate.feedback(
                                                FeedbackType.success);
                                            await FileManager()
                                                .addToLike(walls[idx]);
                                            setState(() {
                                              getLikes();
                                            });
                                          },
                                          icon: PhosphorIcon(
                                              PhosphorIcons.regular.xCircle,
                                              color: Colors.white))
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                        itemCount: walls.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Opacity(
                          opacity: 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cancel),
                                Text(
                                  "No wallpapers here",
                                  style: TextStyle(
                                    color: brightness == "Brightness.light"
                                        ? AppColors.textLight
                                        : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    children: [
                      Text(
                        "Made with ❤️ by Diptanshu Mahish",
                        style: TextStyle(
                          fontSize: 25,
                          color: brightness == "Brightness.light"
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                      ),
                      Text(
                        "Hey there hope you loved Wally ^^ . Keep exploring the app and sharing among your friends and peers. Peace :)",
                        style: TextStyle(
                          color: brightness == "Brightness.light"
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                ),
              )
            ],
          )
        : Row(
            children: [
              SizedBox(
                  key: const ValueKey("Favorites Tablet View"),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height,
                  child: SvgPicture.asset(
                    "lib/assets/backgrounds/liked.svg",
                    colorFilter: brightness == "Brightness.dark"
                        ? const ColorFilter.mode(
                            Color.fromARGB(68, 0, 0, 0), BlendMode.luminosity)
                        : const ColorFilter.mode(
                            Color.fromARGB(0, 0, 0, 0), BlendMode.darken),
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  child: CustomScrollView(
                key: const ValueKey("favorites tablet side panel 721937"),
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        // color: Colors.red,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Liked Album",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "All those you liked :)",
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
                  walls.isNotEmpty
                      ? SliverPadding(
                          key: const ValueKey("djsfkhsdkfhkahfkSHFK"),
                          padding: const EdgeInsets.only(bottom: 80),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3 / 4, crossAxisCount: 3),
                            itemBuilder: (ctx, idx) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 30),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => FullScreen(
                                                desc: walls[idx]["desc"],
                                                imageLink: walls[idx]["link"],
                                                name: walls[idx]["name"],
                                                tags: walls[idx]["catagories"],
                                                variants: walls[idx]
                                                    ["variants"],
                                                id: walls[idx]["id"],
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
                                          ).createShader(Rect.fromLTRB(0, -140,
                                              rect.width, rect.height - 20));
                                        },
                                        blendMode: BlendMode.darken,
                                        child: CachedNetworkImage(
                                          cacheManager: CacheManager(Config(
                                              "Featured",
                                              maxNrOfCacheObjects: 10,
                                              stalePeriod:
                                                  const Duration(days: 10))),
                                          filterQuality: FilterQuality.medium,
                                          imageUrl: walls[idx]["link"],
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
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: LoadingAnimationWidget
                                                  .discreteCircle(
                                                      size: 20,
                                                      color: Colors.white)),
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
                                              walls[idx]["name"].toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  Vibrate.feedback(
                                                      FeedbackType.success);
                                                  await FileManager()
                                                      .addToLike(walls[idx]);
                                                  setState(() {
                                                    getLikes();
                                                  });
                                                  // await FileManager().readLikes();
                                                },
                                                icon: PhosphorIcon(
                                                    PhosphorIcons
                                                        .regular.xCircle,
                                                    color: Colors.white))
                                          ],
                                        ),
                                      ))
                                ]),
                              ),
                            ),
                            itemCount: walls.length,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: const Center(
                              child: Text(
                                  "You haven't added any wallpapers to your favorites"),
                            ),
                          ),
                        )
                ],
              ))
            ],
          );
  }

  getLikes() async {
    List<dynamic> data = await FileManager().readLikes();
    setState(() {
      walls = data;
    });
  }

  bool checkPres(int id) {
    for (var i = 0; i < walls.length; i++) {
      if (id == walls[i]["id"]) {
        return true;
      }
    }

    return false;
  }
}
