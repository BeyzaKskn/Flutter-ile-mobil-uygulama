import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutterr_app/anasayfa.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<String> cards;
  List<Uint8List?>? cardImages;
  late List<bool> isFlipped;
  int? firstCardIndex;
  int? secondCardIndex;
  int score = 0;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    startGame();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> startGame() async {
    cards = fillSourceArray()..shuffle();
    cardImages = await fetchImages();
    setState(() {
      isFlipped = List.generate(
        cards.length,
        (index) => true,
      );

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          for (int i = 0; i < isFlipped.length; i++) {
            isFlipped[i] = false;
          }
          _stopwatch.start();
        });
      });
    });
  }

  List<String> fillSourceArray() {
    List<String> sources = [];
    for (int i = 0; i < 10; i++) {
      sources.add('$i');
      sources.add('$i');
    }
    return sources;
  }

  Future<List<Uint8List?>> fetchImages() async {
    List<Uint8List?> images = [];
    for (var card in cards) {
      final ref = FirebaseStorage.instance.ref().child('Game/$card.png');
      try {
        final data = await ref.getData(1024 * 1024);
        images.add(data);
      } catch (e) {
        print("Error fetching image for $card: $e");
        images.add(null);
      }
    }
    return images;
  }

  void _onFlip(int index) {
    if (isFlipped[index] ||
        (firstCardIndex != null && secondCardIndex != null)) {
      return;
    }
    setState(() {
      isFlipped[index] = true;
    });
    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      secondCardIndex = index;
      _checkMatch();
    }
  }

  void _checkMatch() {
    if (firstCardIndex == null || secondCardIndex == null) return;

    String firstCard = cards[firstCardIndex!];
    String secondCard = cards[secondCardIndex!];

    if (firstCard == secondCard) {
      setState(() {
        score++;
        firstCardIndex = null;
        secondCardIndex = null;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isFlipped[firstCardIndex!] = false;
          isFlipped[secondCardIndex!] = false;
          firstCardIndex = null;
          secondCardIndex = null;
        });
      });
    }

    if (score == 10) {
      _stopwatch.stop();
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oyun Bitti'),
          content: Text(
            'Tebrikler! Skorunuz: $score\nBitirme Süresi: ${_stopwatch.elapsed.inMinutes}:${_stopwatch.elapsed.inSeconds.remainder(60)}',
            style: const TextStyle(fontFamily: "Poppins"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  startGame();
                  score = 0;
                  _stopwatch.reset();
                  _stopwatch.start();
                });
              },
              child: const Text(
                'Yeniden Başla',
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          ],
        );
      },
    );
  }

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
        title: const Center(
            child: Text(
          'HAFIZA OYUNU',
          style: TextStyle(
              color: Color.fromARGB(255, 206, 80, 245),
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins"),
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time: ${_stopwatch.elapsed.inMinutes}:${_stopwatch.elapsed.inSeconds.remainder(60)}',
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 206, 80, 245),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins"),
            ),
          ),
          Expanded(
            child: cardImages == null
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _onFlip(index);
                        },
                        child: Card(
                          child: isFlipped[index]
                              ? (cardImages![index] != null
                                  ? Image.memory(
                                      cardImages![index]!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(child: Text('No Image')))
                              : Image.asset(
                                  'assets/back.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 206, 80, 245),
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Score: $score',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  fontFamily: "Poppins"),
            ),
          ),
        ),
      ),
    );
  }
}
