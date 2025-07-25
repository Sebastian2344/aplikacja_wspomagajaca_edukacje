import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../create_or_edit_quiz/presentation/widgets/create_button.dart';
import '../../../create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import '../../cubit/quiz_panel_cubit.dart';

class CreateQuizWidget extends StatelessWidget {
  const CreateQuizWidget({super.key});

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
                fixedSize: Size(size.width * 0.5, size.height * 0.1),
              ),
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
            IgnorePointer(
                ignoring: context.read<QuizPanelCubit>().codeIsNotInitVal(),
                child: CreateButton(
                    quizTitle: state.quizTitle,
                    questions: state.questions,
                    gameCode: state.gameCode,
                    isFormValidQuiz:
                        context.read<QuizPanelCubit>().isFormValidQuiz())),
            const SizedBox(height: 20),
            context.read<QuizPanelCubit>().codeIsNotInitVal()
                ? const Text('Wygeneruj kod gry.')
                : Text('Tutaj jest wygenerowany kod gry: ${state.gameCode}.')
          ],
        );
      },
    );
  }
}