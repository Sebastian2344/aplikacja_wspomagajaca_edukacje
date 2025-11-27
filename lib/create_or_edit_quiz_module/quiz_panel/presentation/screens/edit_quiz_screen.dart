import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/widgets/back_to_list.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/widgets/edit.dart';

import '../../cubit/quiz_panel_cubit.dart';
import '../../../commons/models/question_model.dart';
import '../../../commons/models/quiz_model.dart';
import '../widgets/edit_question_widget.dart';
import '../widgets/show_panel_questions.dart';

class EditQuizScreen extends StatelessWidget {
  const EditQuizScreen(
      {super.key,
      required this.downloadedQuizModel,
      required this.downloadedListQuestionModel});
  final QuizModel downloadedQuizModel;
  final List<QuestionModel> downloadedListQuestionModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizPanelCubit()..loadDataToState(downloadedListQuestionModel, downloadedQuizModel),
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Edycja quizu'),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              leading: BackToList()),
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
                  return Edit(
                      panelState: state,
                      downloadedQuizModel: downloadedQuizModel,
                      downloadedListQuestionModel: downloadedListQuestionModel);
                case 1:
                  return EditQuestionWidget(userId:downloadedQuizModel.userId);
                default:
                  return const ShowPanelQuestions();
              }
            }),
          ),
          bottomNavigationBar: BlocBuilder<QuizPanelCubit, QuizPanelState>(
            builder: (context, state) {
              return BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_box_outlined), label: 'Edytuj quiz'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_box_rounded),
                      label: 'Edytuj pytania'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: 'Lista pytań'),
                ],
                currentIndex: state.currentIndex,
                onTap: (value) =>
                    context.read<QuizPanelCubit>().updateIndex(value),
                backgroundColor: Colors.grey.shade300,
                selectedItemColor: Colors.blue.shade800,
                unselectedItemColor: Colors.grey.shade600,
                type: BottomNavigationBarType.fixed,
              );
            },
          )),
    );
  }
}