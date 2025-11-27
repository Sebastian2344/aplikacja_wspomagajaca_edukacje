import 'package:flutter/material.dart';

import '../../../commons/main_component/my_platformer_game.dart';

class PauseMenu extends StatelessWidget {
  final PlatformerGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        color: Colors.black.withAlpha(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pauza',
              style: TextStyle(color: Colors.white, fontSize: 24,decoration: TextDecoration.none),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.levelsMenagmentCubit.pauseOff();
              },
              child: const Text('Kontynuuj'),
            ),
          ],
        ),
      ),
    );
  }
}