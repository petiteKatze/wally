import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          floating: true,
          snap: true,
          elevation: 0,
          pinned: true,
          centerTitle: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Wally"),
            centerTitle: true,
            background: Container(
              color: const Color.fromARGB(255, 158, 47, 47),
              child: const Center(
                child: Text("hello from the App"),
              ),
            ),
          ),
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
                    border: Border.all(color: Colors.blueGrey)),
                child: const TextField(
                  autocorrect: true,
                  autofillHints: ["Pastel", "Gradients", "Quotes"],
                  decoration: InputDecoration(
                      hintText: "Search for wallpapers",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none),
                ),
              ),
            )),
        const SliverAppBar(
          pinned: true,
          toolbarHeight: 20,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(
              "Featured",
              style: TextStyle(fontSize: 20),
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
        )
      ],
    );
  }
}
