import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/main_component/my_platformer_game.dart';
import '../../cubit/quiz_part_game_cubit.dart';

class Question extends StatelessWidget {
  final PlatformerGame game;

  const Question({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final Size sizeWidget = MediaQuery.of(context).size;
    return ColoredBox(
      color: Colors.black54,
      child: BlocBuilder<QuizPartGameCubit, QuizPartGameState>(
        builder: (context, state) {
          if (state is AnsweringIsReadyToUse) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: sizeWidget.width / 2,
                    height: sizeWidget.height / 6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      state.questionModelGame.question,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonAns(state.questionModelGame.answers.elementAt(0),
                          sizeWidget, context, 0),
                      buttonAns(state.questionModelGame.answers.elementAt(1),
                          sizeWidget, context, 1)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonAns(state.questionModelGame.answers.elementAt(2),
                          sizeWidget, context, 2),
                      buttonAns(state.questionModelGame.answers.elementAt(3),
                          sizeWidget, context, 3)
                    ],
                  ),
                ],
              ),
            );
          } else if (state is CheckedAnswer) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: sizeWidget.width / 2,
                    height: sizeWidget.height / 6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      state.questionModelGame.question,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonsAnsColored(state.questionModelGame.answers[0],
                          sizeWidget, state.color),
                      buttonsAnsColored(state.questionModelGame.answers[1],
                          sizeWidget, state.color2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonsAnsColored(state.questionModelGame.answers[2],
                          sizeWidget, state.color3),
                      buttonsAnsColored(state.questionModelGame.answers[3],
                          sizeWidget, state.color4),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('quizQuestion');
                      game.resumeEngine();
                      context.read<QuizPartGameCubit>().prepareNextquestion();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 17),
                        minimumSize:
                            Size(sizeWidget.width / 3, sizeWidget.height / 6)),
                    child: const Text('Zamknij'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buttonAns(
      String answer, Size sizeWidget, BuildContext context, int optionIndex) {
    return ElevatedButton(
      onPressed: () {
        context.read<QuizPartGameCubit>().chechAnswer(answer, optionIndex);
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: optionIndex == 0
              ? Colors.pink
              : optionIndex == 1
                  ? Colors.purple
                  : optionIndex == 2
                      ? Colors.teal
                      : Colors.indigo,
          textStyle: const TextStyle(fontSize: 17),
          minimumSize: Size(sizeWidget.width / 3, sizeWidget.height / 6)),
      child: Text(answer),
    );
  }

  Widget buttonsAnsColored(String answer, Size sizeWidget, Color color) {
    return Container(
      width: sizeWidget.width / 3,
      height: sizeWidget.height / 6,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Text(
        answer,
        style: const TextStyle(
            fontSize: 17, color: Colors.white, decoration: TextDecoration.none),
      ),
    );
  }
}
