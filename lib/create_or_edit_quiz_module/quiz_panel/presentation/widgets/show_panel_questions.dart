import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/quiz_panel_cubit.dart';

class ShowPanelQuestions extends StatelessWidget {
  const ShowPanelQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizPanelCubit, QuizPanelState>(
        builder: (context, state) {
      return ListView.builder(itemCount: state.questions.length,itemBuilder: (context, listIndex) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: GestureDetector(
              onTap: () =>
                  context.read<QuizPanelCubit>().prepareToEdit(listIndex, true),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.teal, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Pytanie: ${state.questions[listIndex].question}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Odpowiedzi: ${state.questions[listIndex].answers}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Poprawna odpowiedź: ${state.questions[listIndex].correctAnswer}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Url zdjęcia: ${state.questions[listIndex].urlImage}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Limit czasu: ${state.questions[listIndex].timeLimit}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Punkty: ${state.questions[listIndex].points}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          context.read<QuizPanelCubit>().removeQuestion(listIndex);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
