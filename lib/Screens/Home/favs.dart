import "package:flutter/material.dart";
import "package:wally/Functions/json_load.dart";

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
              SliverAppBar(
                pinned: true,
                toolbarHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text("Wally Collections",
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
              SliverToBoxAdapter(
                child: Text(
                  walls.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              )
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
}
