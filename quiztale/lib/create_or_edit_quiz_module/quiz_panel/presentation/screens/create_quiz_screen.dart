import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/widgets/create.dart';

import '../../../create_or_edit_quiz/presentation/widgets/button_back.dart';
import '../../cubit/quiz_panel_cubit.dart';
import '../widgets/create_question_widget.dart';
import '../widgets/show_panel_questions.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizPanelCubit(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Tworzenie quizu'),
            centerTitle: true,
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: ButtonBack()),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocBuilder<QuizPanelCubit, QuizPanelState>(
            builder: (context, state) {
              switch (state.currentIndex) {
                case 0:
                  return const Create();
                case 1:
                  return CreateQuestionWidget(userId: userId,);
                default:
                  return const ShowPanelQuestions();
              }
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<QuizPanelCubit, QuizPanelState>(
          builder: (context, state) {
            return BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  label: 'Stwórz quiz',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_rounded),
                  label: 'Stwórz pytania',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Lista pytań',
                ),
              ],
              currentIndex: state.currentIndex,
              onTap: (value) => context.read<QuizPanelCubit>().updateIndex(value),
              backgroundColor: Colors.grey.shade300,
              selectedItemColor: Colors.blue.shade800,
              unselectedItemColor:Colors.grey.shade600, 
              type: BottomNavigationBarType.fixed,
            );
          },
        ),
      ),
    );
  }
}