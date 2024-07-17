import 'package:flutterr_app/anasayfa.dart';
import 'package:flutterr_app/model/nesne.dart';
import 'package:flutterr_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class Sayilar extends StatelessWidget {
  const Sayilar({Key? key});

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

  Widget buildNesne(BuildContext context, Nesne nesne, Uint8List? imageData) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: InkWell(
        onTap: () async {
          FlutterTts flutterTts = FlutterTts();
          await flutterTts.setLanguage('tr-TR');
          await flutterTts.speak(nesne.tr);
          await Future.delayed(const Duration(milliseconds: 850));
          await flutterTts.setLanguage('en-US');
          await flutterTts.speak(nesne.en);
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
                      Text(nesne.tr),
                      Text(nesne.en),
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
              fontSize: 35,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
            //leading:
          ),
        ),
      ),
    );
  }

  Widget buildFuture() {
    return FutureBuilder(
      future: Future.wait([Services.getObjects(), fetchImages()]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Nesne> object = snapshot.data![0] as List<Nesne>;
          List<Uint8List?> images = snapshot.data![1] as List<Uint8List?>;
          return ListView.builder(
            itemCount: object.length,
            itemBuilder: (_, index) {
              return buildNesne(_, object[index], images[index]);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Uint8List?>> fetchImages() async {
    List<Nesne> objects = await Services.getObjects();
    List<Uint8List?> images = [];

    for (var nesne in objects) {
      final String photoId = nesne.id + ".png";
      final ref = FirebaseStorage.instance.ref().child('Sayilar/$photoId');
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
