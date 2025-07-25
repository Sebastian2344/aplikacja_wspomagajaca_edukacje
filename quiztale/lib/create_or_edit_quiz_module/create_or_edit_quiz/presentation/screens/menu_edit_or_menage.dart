import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/models/question_model.dart';
import '../../../commons/models/quiz_model.dart';
import '../../../menage_quiz/presentation/menage_quiz_while_play_widget.dart';
import '../../../quiz_panel/presentation/screens/edit_quiz_screen.dart';
import '../../cubit/create_or_edit_quiz_cubit.dart';

class MenuEditOrMenage extends StatelessWidget {
  const MenuEditOrMenage(
      {super.key, required this.quizModel, required this.list});
  final QuizModel quizModel;
  final List<QuestionModel> list;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz co chczesz zrobić'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Builder(
          builder: (mycontext) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: BlocProvider.of<CreateOrEditQuizCubit>(
                                mycontext),
                            child: EditQuizScreen(
                              downloadedListQuestionModel: list,
                              downloadedQuizModel: quizModel,
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      fixedSize: Size(size.width / 2, size.height / 5),
                      textStyle: TextStyle(fontSize: size.width * 0.04),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Edytuj quiz'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MenageQuizWhilePlayWidget(
                            downloadedQuizModel: quizModel,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize:size.width * 0.04),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      fixedSize: Size(size.width / 2, size.height / 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Zarządzaj quizem'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        mycontext.read<CreateOrEditQuizCubit>().returnToQuizList();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        fixedSize: Size(size.width / 2, size.height / 5),
                        textStyle: TextStyle(fontSize: size.width * 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Wyjście'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
