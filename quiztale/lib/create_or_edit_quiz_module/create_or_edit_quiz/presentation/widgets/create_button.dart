import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';
import '../../../commons/models/question_model.dart';

class CreateButton extends StatelessWidget {
  const CreateButton(
      {super.key,
      required this.quizTitle,
      required this.questions,
      required this.gameCode,
      required this.isFormValidQuiz});
  final String quizTitle;
  final List<QuestionModel> questions;
  final int gameCode;
  final bool isFormValidQuiz;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
        onPressed: () async {
          if (isFormValidQuiz && questions.isNotEmpty) {
            await context
                .read<CreateOrEditQuizCubit>()
                .saveInDatabaseCreatedQuiz(gameCode, quizTitle, questions);
          } else if(questions.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quiz wymaga minimum 1 pytania.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wypełnij wszystkie pola!')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            fixedSize: Size(size.width * 0.5, size.height * 0.1)),
        child: const Text('Zapisz quiz do bazy'));
  }
}
