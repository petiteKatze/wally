import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Functions/json_load.dart";
import "package:wally/Screens/full_wall.dart";

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
    return MediaQuery.of(context).size.width < 900
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                elevation: 0,
                pinned: false,
                centerTitle: true,
                expandedHeight:
                    MediaQuery.of(context).size.width > 700 ? 600 : 300,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.asset(
                      "lib/assets/backgrounds/liked.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    )),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    // color: Colors.red,
                    height: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.height * 0.05
                        : MediaQuery.of(context).size.height * 0.07,
                    child: const Column(
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
                                      ).createShader(Rect.fromLTRB(0, -140,
                                          rect.width, rect.height - 20));
                                    },
                                    blendMode: BlendMode.darken,
                                    child: CachedNetworkImage(
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
                                        child:
                                            const CupertinoActivityIndicator(),
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
                                          walls[idx]["name"],
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
                        ),
                        itemCount: walls.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const Opacity(
                          opacity: 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel),
                                Text("No wallpapers here"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          )
        : Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    "lib/assets/backgrounds/liked.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  )),
              Expanded(
                  child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        // color: Colors.red,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: const Column(
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
                                            child:
                                                const CupertinoActivityIndicator(),
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
                                              walls[idx]["name"],
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
