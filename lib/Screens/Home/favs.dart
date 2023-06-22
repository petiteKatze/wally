import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";
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
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width > 600
                          ? 5 / 3
                          : 4 / 3,
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1),
                  itemBuilder: (ctx, idx) => Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20.0, // soften the shadow
                                spreadRadius: 2.0, //extend the shadow
                                offset: const Offset(
                                  2.0,
                                  2.0,
                                ),
                              )
                            ],
                            color: const Color.fromARGB(255, 237, 236, 230),
                            borderRadius: BorderRadius.circular(8)),
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width:
                                          MediaQuery.of(context).size.width <
                                                  600
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                      imageUrl: walls[idx]["link"])),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      walls[idx]["name"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              600
                                          ? MediaQuery.of(context).size.width *
                                              0.5
                                          : MediaQuery.of(context).size.width *
                                              0.2,
                                      child: Text(
                                        walls[idx]["desc"].toString(),
                                        maxLines:
                                            MediaQuery.of(context).size.width <
                                                    600
                                                ? 3
                                                : 6,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            height: 1,
                                            fontWeight: FontWeight.w300,
                                            overflow: TextOverflow.ellipsis),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    //variants
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    walls[idx]["variants"].length > 0
                                        ? const Text("Variants")
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    walls[idx]["variants"].length > 0
                                        ? Row(
                                            children: [
                                              for (var i in walls[idx]
                                                  ["variants"])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.black54),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Color(int.parse(
                                                          'FF${i.keys.first}',
                                                          radix: 16)),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          )
                                        : const SizedBox(),
                                    const Spacer(),

                                    const Text(
                                      "Actions",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black45)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PhosphorIcon(
                                            PhosphorIcons
                                                .duotone.downloadSimple,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black45)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PhosphorIcon(
                                            PhosphorIcons.duotone.shareNetwork,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black45)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PhosphorIcon(
                                            PhosphorIcons
                                                .duotone.caretCircleRight,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  itemCount: walls.length,
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
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 80),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 20 / 9, crossAxisCount: 1),
                      itemBuilder: (ctx, idx) => Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 30),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 20.0, // soften the shadow
                                    spreadRadius: 2.0, //extend the shadow
                                    offset: const Offset(
                                      2.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                color: const Color.fromARGB(255, 237, 236, 230),
                                borderRadius: BorderRadius.circular(8)),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          imageUrl: walls[idx]["link"])),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          walls[idx]["name"],
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            walls[idx]["desc"].toString(),
                                            maxLines: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
                                                ? 3
                                                : 6,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                height: 1,
                                                fontWeight: FontWeight.w300,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        //variants
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        walls[idx]["variants"].length > 0
                                            ? const Text("Variants")
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        walls[idx]["variants"].length > 0
                                            ? Row(
                                                children: [
                                                  for (var i in walls[idx]
                                                      ["variants"])
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black54),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Color(int.parse(
                                                              'FF${i.keys.first}',
                                                              radix: 16)),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              )
                                            : const SizedBox(),
                                        const Spacer(),

                                        const Text(
                                          "Actions",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black45)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: PhosphorIcon(
                                                PhosphorIcons
                                                    .duotone.downloadSimple,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black45)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: PhosphorIcon(
                                                PhosphorIcons
                                                    .duotone.shareNetwork,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black45)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: PhosphorIcon(
                                                PhosphorIcons
                                                    .duotone.caretCircleRight,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      itemCount: walls.length,
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
