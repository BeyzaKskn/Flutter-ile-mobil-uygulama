import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterr_app/authpage.dart';
import 'package:flutterr_app/hayvanlar.dart';
import 'package:flutterr_app/memory_game.dart';
import 'package:flutterr_app/model/nesne.dart';
import 'package:flutterr_app/sayilar.dart';
import 'package:flutterr_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class Anasayfa extends StatelessWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 206, 80, 245),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 98, 231, 255),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: buildFuture(),
      ),
    );
  }

  Future<void> readText(AnasayfaNesne anasayfaNesne) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('tr-TR');
    await flutterTts.speak(anasayfaNesne.tr);
    await Future.delayed(const Duration(milliseconds: 850));
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(anasayfaNesne.en);
  }

  Widget buildNesne(
      BuildContext context, AnasayfaNesne anasayfaNesne, Uint8List? imageData) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () async {
        if (anasayfaNesne.page_route == 'animals') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Hayvanlar()),
          );
        } else if (anasayfaNesne.page_route == 'numbers') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Sayilar()),
          );
        } else if (['fruits', 'vegetables', 'shapes', 'colors']
            .contains(anasayfaNesne.page_route)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Anasayfa()),
          );
        }
        readText(anasayfaNesne);
      },
      child: Card(
        color: const Color.fromARGB(255, 206, 80, 245),
        child: ListTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anasayfaNesne.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anasayfaNesne.en,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              if (imageData != null)
                Image.memory(
                  imageData,
                  width: w * 0.2,
                  height: h * 0.13,
                  alignment: Alignment.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMemoryGame(
      BuildContext context, AnasayfaNesne anasayfaNesne, Uint8List? imageData) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MemoryGame()),
        );
        readText(anasayfaNesne);
      },
      child: Card(
        color: const Color.fromARGB(255, 206, 80, 245),
        child: ListTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anasayfaNesne.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anasayfaNesne.en,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
              if (imageData != null)
                Image.memory(
                  imageData,
                  width: w * 0.2,
                  height: h * 0.13,
                  alignment: Alignment.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFuture() {
    return FutureBuilder(
      future: Future.wait([HomeServices.getObjects2(), fetchImages()]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<AnasayfaNesne> object2 =
                snapshot.data![0] as List<AnasayfaNesne>;
            List<Uint8List?> images = snapshot.data![1] as List<Uint8List?>;

            if (object2.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            List<AnasayfaNesne> items = object2;
            List<AnasayfaNesne> nonMemoryGameItems = items
                .where((item) => item.page_route != 'memory_game')
                .toList();
            List<AnasayfaNesne> memoryGameItems = items
                .where((item) => item.page_route == 'memory_game')
                .toList();

            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'ÖĞRENİYORUM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 98, 231, 255),
                        fontFamily: "Poppins"),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: nonMemoryGameItems.length,
                  itemBuilder: (_, index) {
                    return buildNesne(_, nonMemoryGameItems[index],
                        images[items.indexOf(nonMemoryGameItems[index])]);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'OYNUYORUM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 98, 231, 255),
                        fontFamily: "Poppins"),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: memoryGameItems.length,
                  itemBuilder: (_, index) {
                    return buildMemoryGame(_, memoryGameItems[index],
                        images[items.indexOf(memoryGameItems[index])]);
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('No data available'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Uint8List?>> fetchImages() async {
    List<AnasayfaNesne> objects = await HomeServices.getObjects2();
    List<Uint8List?> images = [];

    for (var anasayfaNesne in objects) {
      final String photoId = "${anasayfaNesne.id}.png";
      final ref = FirebaseStorage.instance.ref().child('Anasayfa/$photoId');
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
