import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:wally/Screens/col_walls.dart";

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
                leading: const SizedBox(),
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
              const SliverPadding(
                key: ValueKey("Wally heading homepage"),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Catagories",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Check out our latest collections ",
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
                          key: ValueKey('$index' "catagory"),
                          onTap: () async {
                            List<dynamic> passFiles = await FileManager()
                                .getCatagory(cats[index]["type"]);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Col(
                                          type: cats[index]["type"],
                                          useFile: passFiles,
                                        ))));
                          },
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
                                child: LoadingAnimationWidget.discreteCircle(
                                    size: 20, color: Colors.white),
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
                                        cats[index]["type"].toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "${cats[index]["total"].toString()} Wallpapers",
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                      ),
                      childCount: cats.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width < 700 ? 2 : 3,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 15,
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
                  const SliverPadding(
                    key: ValueKey("Wally heading homepage"),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              onTap: () async {
                                List<dynamic> passFiles = await FileManager()
                                    .getCatagory(cats[index]["type"]);

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Col(
                                              type: cats[index]["type"],
                                              useFile: passFiles,
                                            )));
                              },
                              child: Stack(children: <Widget>[
                                CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  imageUrl: cats[index]["image"],
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
                                              size: 20, color: Colors.white)),
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
                                            cats[index]["type"].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${cats[index]["total"].toString()} Wallpapers",
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
