import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/commons/providers/features_providers.dart';

class QuizChoice extends StatelessWidget {
  const QuizChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 235, 255),
      appBar: AppBar(
        title: const Text('Wybór Quizu'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonClassCategory('Klasa 1', 'klasa_1', Colors.green[600],
                context, width / 2, height / 6),
            _buttonClassCategory('Klasa 2', 'klasa_2', Colors.green[700],
                context, width / 2, height / 6),
            _buttonClassCategory('Klasa 3', 'klasa_3', Colors.green[800],
                context, width / 2, height / 6),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              },
              child: Container(
                height: height / 6,
                width: width / 2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text(
                  'Wyjście',
                  style: TextStyle(fontSize: 0.05 * height,color: Colors.white),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _buttonClassCategory(String buttonText, String classCategory,
      Color? color, BuildContext context, double width, double height) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FeaturesProviders(classCategory: classCategory)));
      },
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white,fontSize: 0.05 * height * 6),
        ),
      ),
    );
  }
}
