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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          stretch: true,
          elevation: 0,
          pinned: false,
          centerTitle: true,
          expandedHeight: 300,
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
          toolbarHeight: 30,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
            title: Text("Featured",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
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
                              child: CupertinoActivityIndicator(),
                            ),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 5,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                walls[index]["name"],
                                style: const TextStyle(color: Colors.white),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 9 / 16,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4)),
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        )
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
