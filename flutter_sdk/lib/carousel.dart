import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

final Directory _photoDir = Directory('./lib/images');
var imageList = _photoDir
    .listSync()
    .map((item) => item.path)
    .where((item) =>
        item.endsWith(".jpg") || item.endsWith(".png") || item.endsWith(".gif"))
    .toList(growable: false);
//File file = File(imageList[index]);

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
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths =
        manifestMap.keys.where((String key) => key.contains('.png')).toList();

    setState(() {
      someImages = imagePaths;
    });

    log("Updated someImages");
    manifestMap.keys.forEach((element) {
      log(element);
    });
  }

  List<String> someImages = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: someImages.length,
          itemBuilder: (context, index) {
            log(someImages[index]);
            return Image(image: AssetImage(someImages[index]));
          },
        ));
  }
}
