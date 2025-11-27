import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/widgets/edit_button.dart';

import '../../../create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import '../../cubit/quiz_panel_cubit.dart';
import '../../../commons/models/question_model.dart';
import '../../../commons/models/quiz_model.dart';

class EditQuizWidget extends StatelessWidget {
  const EditQuizWidget(
      {super.key,
      required this.downloadedQuizModel,
      required this.downloadedListQuestionModel});
  final QuizModel downloadedQuizModel;
  final List<QuestionModel> downloadedListQuestionModel;
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<QuizPanelCubit, QuizPanelState>(
        builder: (context, state) {
      return Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: state.quizTitle,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              labelStyle: TextStyle(color: Colors.green.shade800),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade500),
              ),
              labelText: 'Tytuł Quizu',
            ),
            onChanged: (value) {
              context.read<QuizPanelCubit>().updateQuizTitle(value);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                fixedSize: Size(size.width * 0.5, size.height * 0.1)),
            onPressed: () async {
              int code = await context
                  .read<CreateOrEditQuizCubit>()
                  .generateGameCode();
              if (context.mounted) {
                context.read<QuizPanelCubit>().updateGameCode(code);
              }
            },
            child: const Text('Generuj kod'),
          ),
          EditButton(
              downloadedQuizModel: downloadedQuizModel,
              downloadedListQuestionModel: downloadedListQuestionModel,
              gameCode: state.gameCode,
              quizTitle: state.quizTitle,
              questions: state.questions,
              isValid: context.read<QuizPanelCubit>().isFormValidQuiz()),
          state.gameCode == 000000
              ? const Text('Wygeneruj kod gry.')
              : Text('Tutaj jest wygenerowany kod gry: ${state.gameCode}.')
        ],
      );
    });
  }
}