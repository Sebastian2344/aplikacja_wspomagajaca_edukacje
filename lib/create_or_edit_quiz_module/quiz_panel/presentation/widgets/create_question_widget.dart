import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/quiz_panel_cubit.dart';
import '../../../commons/models/question_model.dart';

class CreateQuestionWidget extends StatelessWidget {
  const CreateQuestionWidget({super.key,required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<QuizPanelCubit, QuizPanelState>(
          builder: (context, state) {
        return Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: state.questionText,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: 'Wpisz treść pytania...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                labelText: 'Treść pytania',
                labelStyle: TextStyle(color: Colors.green.shade800),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade500),
                ),
              ),
              onChanged: (value) {
                context.read<QuizPanelCubit>().updateQuestionText(value);
              },
            ),
            for (int i = 0; i < state.numberOfAnswers; i++)
              TextFormField(
                initialValue: state.answerTexts[i],
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  labelText: 'Odpowiedź ${i + 1}',
                  labelStyle: TextStyle(color: Colors.teal.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue.shade500),
                  ),
                ),
                onChanged: (value) {
                  context.read<QuizPanelCubit>().updateAnswerText(i, value);
                },
              ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'Poprawna odpowiedź',
                labelStyle: TextStyle(color: Colors.green.shade800),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade500),
                ),
              ),
              items: List.generate(state.numberOfAnswers, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text('Odpowiedź ${index + 1}'),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  context.read<QuizPanelCubit>().updateCorrectAnswer(value);
                }
              },
            ),
            TextFormField(
              initialValue: state.imageUrl,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'URL obrazka',
                labelStyle: TextStyle(color: Colors.green.shade800),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade500),
                ),
              ),
              onChanged: (value) {
                context.read<QuizPanelCubit>().updateImageUrl(value);
              },
            ),
            Row(
              children: [
                const Text('Ustaw liczbę odpowiedzi:'),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: state.numberOfAnswers,
                  items: [2, 3, 4].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    context.read<QuizPanelCubit>().changeNumberOfAnswers(
                        newValue ?? state.numberOfAnswers);
                  },
                ),
              ],
            ),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: state.points.toString(),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText: 'Punkty (od 1 do 9)',
                      labelStyle: TextStyle(color: Colors.green.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade500),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      context.read<QuizPanelCubit>().updatePoints(value);
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: state.timeLimit.toString(),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText: 'Czas (od 10 do 99 s)',
                      labelStyle: TextStyle(color: Colors.green.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade500),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      context.read<QuizPanelCubit>().updateTimeLimit(value);
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (context.read<QuizPanelCubit>().isFormValidQuestion()) {
                  context.read<QuizPanelCubit>().isEdit()
                      ? context.read<QuizPanelCubit>().editQuestion(
                          QuestionModel(
                              userId: userId,
                              question: state.questionText,
                              answers: state.answerTexts,
                              correctAnswer: state.correctAnswer,
                              points: state.points,
                              timeLimit: state.timeLimit,
                              urlImage: state.imageUrl))
                      : context.read<QuizPanelCubit>().addQuestion(userId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Wypełnij wszystkie pola i upewnij się, czy wpisałeś poprawne dane!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text(context.read<QuizPanelCubit>().isEdit()
                  ? 'Edytuj pytanie'
                  : 'Dodaj pytanie'),
            ),
          ],
        );
      }),
    );
  }
}
