import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/screens/menu_edit_or_menage.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';

class QuizToChoice extends StatelessWidget {
  const QuizToChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz quiz do edycji'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CreateOrEditQuizCubit>().backToInitial();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<CreateOrEditQuizCubit, CreateOrEditQuizState>(
          listener: (mycontext, state) {
            if (state is DownloadedSelectedQuiz) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                        value:
                            BlocProvider.of<CreateOrEditQuizCubit>(mycontext),
                        child: MenuEditOrMenage(
                            quizModel: state.quizModel,
                            list: state.listQuestionModel))),
              );
            }
          },
          builder: (mycontext, state) {
            if (state is CreateQuizInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DownloadedListQuizies) {
              return ListView.builder(
                itemCount: state.listQuizModel.length,
                itemBuilder: (context, index) {
                  final quiz = state.listQuizModel[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      textColor: Colors.white,
                      title: Text('Nazwa quizu: ${quiz.quizTitle}'),
                      subtitle: Text('Kod gry: ${quiz.gameCode}'),
                      onTap: () async {
                        await mycontext
                            .read<CreateOrEditQuizCubit>()
                            .selectQuizToEdit(quiz);
                      },
                    ),
                  );
                },
              );
            } else if (state is CreateQuizError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Błąd: ${state.error}'),
                  ElevatedButton(
                      onPressed: () async {
                        await context
                            .read<CreateOrEditQuizCubit>()
                            .downloadListQuiz();
                      },
                      child: const Text('Spróbuj ponownie.'))
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
