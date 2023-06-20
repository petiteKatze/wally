import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";

class Featured extends StatelessWidget {
  const Featured({super.key});

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
                    border:
                        Border.all(color: Color.fromARGB(255, 213, 216, 218))),
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
                (context, index) => Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4)),
                ),
                childCount: 44,
              ),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: const [
                  QuiltedGridTile(2, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                ],
              )),
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        )
      ],
    );
  }
}
