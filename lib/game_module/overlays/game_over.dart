import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/commons/main_component/my_platformer_game.dart';
import '../features/quiz_menage/cubit/quiz_part_game_cubit.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key, required this.game});
  final PlatformerGame game;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Koniec Gry'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.amber)),
                child: Column(
                  children: [
                    Text(
                      'Drogi uczniu!',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Chciałbym ci złożyć gratulacje z okazji ukończenia wyzwania. Tak jak obiecałem otrzymasz nagrodę. W poniedziałek za tydzień dołączasz do kolegów z równoległej klasy. Cieszysz się? Wszyscy razem pojedziemy na wycieczkę.',
                        style: TextStyle(
                            fontSize: height * 0.05, color: Colors.blue[800]),
                      ),
                    ),
                    Text(
                      'Pozdrawiam',
                      style: TextStyle(
                          fontSize: height * 0.05, color: Colors.blue[800]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gratulacje ukończyłeś grę! Twoje punkty ${context.read<QuizPartGameCubit>().points}',
                  style:
                      TextStyle(fontSize: height * 0.05, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('gameOver');
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: height * 0.05)),
                child: const Text('Wracam do menu'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
