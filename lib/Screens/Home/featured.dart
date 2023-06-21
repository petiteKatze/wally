import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
import "package:wally/Functions/json_load.dart";

class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<dynamic> walls = [];
  @override
  void initState() {
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
                  bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(-10), child: SizedBox()),
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.white54,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color.fromARGB(255, 213, 216, 218))),
                      child: const TextField(
                        autocorrect: true,
                        autofillHints: ["Pastel", "Gradients", "Quotes"],
                        decoration: InputDecoration(
                            hintText: "Search for wallpapers",
                            hintStyle: TextStyle(fontWeight: FontWeight.w200),
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none),
                      ),
                    ),
                  )),
              const SliverAppBar(
                pinned: true,
                toolbarHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text("Wally picks",
                            style: TextStyle(
                                fontSize: 25,
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
                                    Text(
                                      walls[index]["name"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        icon: PhosphorIcon(
                                          PhosphorIcons.regular.heart,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ))
                        ]),
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
                    // leading: Padding(
                    //   padding: const EdgeInsets.only(left: 5, bottom: 15),
                    //   child: Container(
                    //     color: const Color(0xFFA040B0),
                    //     height: 40,
                    //   ),
                    // ),
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
                                            onPressed: () {},
                                            icon: PhosphorIcon(
                                              PhosphorIcons.regular.heart,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ))
                            ]),
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
}
