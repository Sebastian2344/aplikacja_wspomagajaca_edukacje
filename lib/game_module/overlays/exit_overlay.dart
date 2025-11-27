import 'package:flutter/material.dart';

import '../features/commons/main_component/my_platformer_game.dart';

class ExitOverlay extends StatelessWidget {
  final PlatformerGame game;

  const ExitOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Czy na pewno chcesz wyjść do menu?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('exitOverlay');
                  },
                  child: const Text('Nie'),
                ),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('exitOverlay');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tak'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
