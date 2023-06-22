import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Functions/json_load.dart";
import "package:wally/Screens/full_wall.dart";

class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<dynamic> walls = [];
  List<dynamic> likes = [];
  @override
  void initState() {
    getLikesList();
    getInfo();

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
                      "lib/assets/backgrounds/home.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    )),
              ),
              SliverAppBar(
                  elevation: 0,
                  pinned: false,
                  toolbarHeight: 80,
                  floating: true,
                  flexibleSpace: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.menu)),
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                // color: Colors.white54,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 213, 216, 218))),
                            child: const TextField(
                              autocorrect: true,
                              autofillHints: ["Pastel", "Gradients", "Quotes"],
                              decoration: InputDecoration(
                                  hintText: "Search for wallpapers",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w200),
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    // color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: const Column(
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
                          onTap: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => FullScreen(
                                          desc: walls[index]["desc"],
                                          imageLink: walls[index]["link"],
                                          name: walls[index]["name"],
                                          tags: walls[index]["catagories"],
                                          variants: walls[index]["variants"],
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
                                        Color.fromARGB(91, 0, 0, 0)
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, -140, rect.width, rect.height - 20));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: CachedNetworkImage(
                                    filterQuality: FilterQuality.medium,
                                    imageUrl: walls[index]["link"],
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
                                      child: const CupertinoActivityIndicator(),
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
                                      Flexible(
                                        child: Text(
                                          walls[index]["name"],
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            Vibrate.feedback(
                                                FeedbackType.success);
                                            await FileManager()
                                                .addToLike(walls[index]);
                                            setState(() {
                                              getLikesList();
                                            });
                                          },
                                          icon: checkPres(index) == false
                                              ? PhosphorIcon(
                                                  PhosphorIcons.regular.heart,
                                                  color: Colors.white)
                                              : PhosphorIcon(
                                                  PhosphorIcons.fill.heart,
                                                  color:
                                                      const Color(0xFFDCB3E9)))
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
                          MediaQuery.of(context).size.width < 700 ? 2 : 3,
                      childAspectRatio: MediaQuery.of(context).size.width < 700
                          ? 9 / 16
                          : 3 / 4,
                      mainAxisSpacing:
                          MediaQuery.of(context).size.width < 700 ? 4 : 15,
                      crossAxisSpacing:
                          MediaQuery.of(context).size.width < 700 ? 4 : 15,
                    )),
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
                  child: Image.asset(
                    "lib/assets/backgrounds/home.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  )),
              Expanded(
                  child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverAppBar(
                    floating: true,
                    toolbarHeight: 82,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      title: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Wally picks",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text("Here is our entire collection ✨",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black))
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
                              onTap: () {
                                Navigator.pushReplacement(
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
                                            walls[index]["name"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                Vibrate.feedback(
                                                    FeedbackType.success);
                                                await FileManager()
                                                    .addToLike(walls[index]);
                                                setState(() {
                                                  getLikesList();
                                                });
                                                // await FileManager().readLikes();
                                              },
                                              icon: checkPres(index) == false
                                                  ? PhosphorIcon(
                                                      PhosphorIcons
                                                          .regular.heart,
                                                      color: Colors.white)
                                                  : PhosphorIcon(
                                                      PhosphorIcons.fill.heart,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              217,
                                                              130,
                                                              228)))
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
                              MediaQuery.of(context).size.width < 700 ? 2 : 3,
                          childAspectRatio:
                              MediaQuery.of(context).size.width < 700
                                  ? 9 / 16
                                  : 3 / 4,
                          mainAxisSpacing:
                              MediaQuery.of(context).size.width < 700 ? 4 : 15,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width < 700 ? 4 : 15,
                        )),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 100),
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
}
