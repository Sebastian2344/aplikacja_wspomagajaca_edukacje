import 'package:flutter/material.dart';

import '../features/commons/main_component/my_platformer_game.dart';

class Level2Story extends StatelessWidget {
  const Level2Story({super.key, required this.game});
  final PlatformerGame game;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Poziom 2'),
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
                    border: Border.all(color: Colors.amber, width: 3),
                    color: Colors.white),
                child: Column(
                  children: [
                    Text(
                      'Drogi Uczniu.',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Dobra robota! Poradziłeś sobie z pytaniami. Jednak to dopiero był pierwszy z czterych etapów. Teraz będziesz musiał się zmierzyć z matematyką. Jestem ciekaw jak sobie poradzisz.',
                        style: TextStyle(
                            fontSize: height * 0.05, color: Colors.blue[800]),
                      ),
                    ),
                    Text(
                      'Twój nauczyciel.',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'Po przeczytaniu listu postanowiłes przejść do krainy matematyki.',
                style: TextStyle(fontSize: height * 0.05, color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('level2Story');
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
