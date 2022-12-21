import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  void initState() {
    super.initState();
    _initImages();
  }

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
            key.contains('.png') && key.contains("/carouselImages/"))
        .toList();

    setState(() {
      someImages = imagePaths;
    });

    log("Updated someImages");
    manifestMap.keys.forEach((element) {
      log(element);
    });
  }

  List<String> someImages = [];
  final imagesPerPage = 2;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        width: double.infinity,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (currentPage != 0) currentPage -= 1;
                    });
                  },
                  child: const Text("Prev")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if ((currentPage + 1) * imagesPerPage <
                          someImages.length) {
                        currentPage += 1;
                      }
                    });
                  },
                  child: const Text("Next"))
            ],
          ),
          SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: someImages.length,
                itemBuilder: (context, index) {
                  log(someImages[index]);
                  return index >= currentPage * imagesPerPage &&
                          index < (currentPage + 1) * imagesPerPage
                      ? Container(
                          width: MediaQuery.of(context).size.width / 2.1,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01),
                          child: Image(
                              fit: BoxFit.scaleDown,
                              image: AssetImage(someImages[index])),
                        )
                      : const SizedBox();
                },
              ))
        ]));
  }
}
