import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:flutter_vibrate/flutter_vibrate.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";

import "../Functions/json_load.dart";
import "full_wall.dart";

class Col extends StatefulWidget {
  final List<dynamic> useFile;
  final String type;
  const Col({required this.type, required this.useFile, super.key});

  @override
  State<Col> createState() => _ColState();
}

class _ColState extends State<Col> {
  List<dynamic> likes = [];

  @override
  void initState() {
    getLikesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: const ValueKey("Catagory resulyts"),
        appBar: AppBar(
          title: Text(widget.type.toString()),
        ),
        body: widget.useFile.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount:
                          MediaQuery.of(context).size.width < 600 ? 2 : 3),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      key: ValueKey('$index+ColumnCatagoryResults'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => FullScreen(
                                      desc: widget.useFile[index]["desc"],
                                      imageLink: widget.useFile[index]["link"],
                                      name: widget.useFile[index]["name"],
                                      tags: widget.useFile[index]["catagories"],
                                      variants: widget.useFile[index]
                                          ["variants"],
                                      id: widget.useFile[index]["id"],
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
                                cacheManager: CacheManager(Config("Featured",
                                    maxNrOfCacheObjects: 15,
                                    stalePeriod: const Duration(days: 1))),
                                filterQuality: FilterQuality.medium,
                                imageUrl: widget.useFile[index]["link"],
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
                                    child:
                                        LoadingAnimationWidget.discreteCircle(
                                      size: 20,
                                      color: Colors.white,
                                    )),
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
                                    widget.useFile[index]["name"],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        Vibrate.feedback(FeedbackType.success);
                                        await FileManager()
                                            .addToLike(widget.useFile[index]);
                                        setState(() {
                                          getLikesList();
                                        });
                                        // await FileManager().readLikes();
                                      },
                                      icon: checkPres(widget.useFile[index]
                                                  ["id"]) ==
                                              false
                                          ? PhosphorIcon(
                                              PhosphorIcons.regular.heart,
                                              color: Colors.white)
                                          : PhosphorIcon(
                                              PhosphorIcons.fill.heart,
                                              color: const Color.fromARGB(
                                                  255, 217, 130, 228)))
                                ],
                              ),
                            ))
                      ]),
                    );
                  },
                  itemCount: widget.useFile.length,
                ),
              )
            : const Center(
                child: Text("Error, Try again"),
              ));
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
