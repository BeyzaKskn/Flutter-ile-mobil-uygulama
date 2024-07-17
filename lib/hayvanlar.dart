import 'dart:typed_data';
import 'package:flutterr_app/anasayfa.dart';
import 'package:flutterr_app/model/nesne.dart';
import 'package:flutterr_app/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Hayvanlar extends StatelessWidget {
  const Hayvanlar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 206, 80, 245)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Anasayfa()),
              );
            },
          ),
        ),
        body: buildFuture());
  }

  Widget buildNesne(
      BuildContext context, HayvanNesne hayvanNesne, Uint8List? imageData) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: InkWell(
        onTap: () async {
          FlutterTts flutterTts = FlutterTts();
          await flutterTts.setLanguage('tr-TR');
          await flutterTts.speak(hayvanNesne.tr);
          await Future.delayed(const Duration(milliseconds: 1050));
          await flutterTts.setLanguage('en-US');
          await flutterTts.speak(hayvanNesne.en);
        },
        child: Card(
          color: const Color.fromARGB(255, 206, 80, 245),
          child: ListTile(
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(hayvanNesne.tr),
                      Text(hayvanNesne.en),
                    ],
                  ),
                ),
                if (imageData != null)
                  Image.memory(
                    imageData,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
            titleTextStyle: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Poppins"),
            //leading:
          ),
        ),
      ),
    );
  }

  Widget buildFuture() {
    return FutureBuilder(
      future: Future.wait([AnimalServices.getObjects3(), fetchImages()]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<HayvanNesne> object3 = snapshot.data![0] as List<HayvanNesne>;
          List<Uint8List?> images = snapshot.data![1] as List<Uint8List?>;
          return ListView.builder(
            itemCount: object3.length,
            itemBuilder: (_, index) {
              return buildNesne(_, object3[index], images[index]);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Uint8List?>> fetchImages() async {
    List<HayvanNesne> object = await AnimalServices.getObjects3();
    List<Uint8List?> images = [];

    for (var hayvanNesne in object) {
      final String photoId = hayvanNesne.id + ".png";
      final ref = FirebaseStorage.instance.ref().child('Hayvanlar/$photoId');
      try {
        final data = await ref.getData(1024 * 1024);
        if (data != null) {
          images.add(Uint8List.fromList(data));
        } else {
          images.add(null);
        }
      } catch (e) {
        print("Error fetching photo for $photoId: $e");
        images.add(null);
      }
    }

    return images;
  }
}
