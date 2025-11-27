import 'package:flutter/material.dart';

import '../features/commons/main_component/my_platformer_game.dart';

class Level4Story extends StatelessWidget {
  const Level4Story({super.key, required this.game});
  final PlatformerGame game;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Poziom 4'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.amber, width: 3)),
                child: Column(
                  children: [
                    Text(
                      'Drogi uczniu!',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                    Text(
                      'Doszedłeś bardzo daleko jestem pod wrażeniem. Przed tobą została kraina języka angielskiego.',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                    Text(
                      'Powodzenia!',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'To już ostatni etap przygody. Postaraj się odpowiedzieć na wszystkie pytania.  Nagroda jest w twoim zasięgu.',
                style: TextStyle(fontSize: height * 0.05, color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('level4Story');
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(fontSize: height * 0.05)),
                  child: const Text('Zaczynam poziom'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
