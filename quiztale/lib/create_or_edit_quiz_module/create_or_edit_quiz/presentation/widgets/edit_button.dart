import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';
import '../../../commons/models/quiz_model.dart';

class EditButton extends StatelessWidget {
  const EditButton(
      {super.key,
      required this.downloadedQuizModel,
      required this.downloadedListQuestionModel,
      required this.gameCode,
      required this.quizTitle,
      required this.questions,
      required this.isValid});
  final int gameCode;
  final String quizTitle;
  final List<QuestionModel> questions;
  final QuizModel downloadedQuizModel;
  final List<QuestionModel> downloadedListQuestionModel;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          fixedSize: Size(size.width * 0.5, size.height * 0.1)),
      onPressed: () {
        if (isValid && questions.isNotEmpty) {
          context.read<CreateOrEditQuizCubit>().saveInDatabaseEditedQuiz(
              downloadedQuizModel.docID,
              QuizModel(
                  docID: downloadedQuizModel.docID,
                  userId: downloadedQuizModel.userId,
                  gameCode: gameCode,
                  quizTitle: quizTitle),
              questions,
              downloadedListQuestionModel);
        } else if (questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quiz wymaga minimum 1 pytania.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wypełnij wszystkie pola!')),
          );
        }
      },
      child: const Text('Zapisz quiz'),
    );
  }
}
