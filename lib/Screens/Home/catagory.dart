import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "../../Functions/json_load.dart";

class Catagory extends StatefulWidget {
  const Catagory({super.key});

  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  List<dynamic> cats = [];
  @override
  void initState() {
    getCats();
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
                      "lib/assets/backgrounds/catagory.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    )),
              ),
              SliverAppBar(
                pinned: true,
                toolbarHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const Text("Wally Collections",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        Text("Check out our super aesthetic collections :)",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 600
                                        ? 15
                                        : 20,
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
                          CachedNetworkImage(
                            filterQuality: FilterQuality.medium,
                            imageUrl: cats[index]["image"],
                            imageBuilder: (ctx, imageProvider) => Container(
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
                          ),
                          Positioned(
                              bottom: 0,
                              left: 5,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cats[index]["type"],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "${cats[index]["total"]} Wallpapers",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ))
                        ]),
                      ),
                      childCount: cats.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width < 700 ? 2 : 3,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
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
                    "lib/assets/backgrounds/catagory.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  )),
              Expanded(
                  child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverAppBar(
                    pinned: true,
                    toolbarHeight: 100,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      title: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Collections",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text("The collections are all here",
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
                              CachedNetworkImage(
                                filterQuality: FilterQuality.medium,
                                imageUrl: cats[index]["image"],
                                imageBuilder: (ctx, imageProvider) => Container(
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
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 5,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cats[index]["type"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "${cats[index]["total"]} Wallpapers",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ))
                            ]),
                          ),
                          childCount: cats.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 4 / 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        )),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 100),
                  )
                ],
              ))
            ],
          );
  }

  getCats() async {
    List<dynamic> data = await FileManager().getCatagories();
    setState(() {
      cats = data;
    });
  }
}
