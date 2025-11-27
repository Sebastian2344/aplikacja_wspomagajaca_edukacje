import 'package:flutter/material.dart';

import '../features/commons/main_component/my_platformer_game.dart';

class Level1Story extends StatelessWidget {
  const Level1Story({super.key, required this.game});
  final PlatformerGame game;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Poziom 1'),
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
              Text(
                'Jako młody chłopak postanowiłeś podjąć wyzwanie rzucone przez swojego nauczyciela. Twoją motywacją jest dołączenie do kolegów z innej klasy po to żeby wyjechać na całodniową wycieczkę w góry. Jednak aby to zrobić musisz przebyć przez cztery krainy i odpowiedzieć w nich na wszystkie pytania. A co to? List nauczyciela. Ciekawe co w nim jest.',
                style: TextStyle(fontSize: height * 0.05, color: Colors.white),
              ),
              const Divider(),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 3),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Text('Drogi uczniu!',
                          style: TextStyle(
                              fontSize: height * 0.05,
                              color: Colors.blue[800])),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Witaj w krainie języka polskiego. Tutaj twoim zadaniem jest zbieranie pudełek z pytajnikami. Każde z nich ma w sobie pytanie z języka polskiego, na które trzeba odpowiedzieć. Jeżeli zbierzesz wszystkie pudełka to twoja postać przeniesie się do krainy matematyki.',
                          style: TextStyle(
                              fontSize: height * 0.05, color: Colors.blue[800]),
                        ),
                      ),
                      Text('Twój nauczyciel.',
                          style: TextStyle(
                              fontSize: height * 0.05,
                              color: Colors.blue[800])),
                    ],
                  )),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('level1Story');
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
