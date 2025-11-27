import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';
import '../../../quiz_panel/cubit/quiz_panel_cubit.dart';
import '../../data/data_source/create_or_edit_quiz_data.dart';
import '../../data/repository/create_or_edit_quiz_repo.dart';
import '../../../quiz_panel/presentation/screens/create_quiz_screen.dart';
import 'quiz_to_choice.dart';

class CreateOrEdit extends StatelessWidget {
  const CreateOrEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => CreateOrEditQuizCubit(CreateOrEditQuizRepo(
          CreateOrEditQuizData(
              FirebaseFirestore.instance, FirebaseAuth.instance))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Moduł tworzenia quizu'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final String userId = mycontext.read<CreateOrEditQuizCubit>().getUserId();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<CreateOrEditQuizCubit>(
                                    mycontext),
                              ),
                              BlocProvider(
                                create: (_) => QuizPanelCubit(),
                              ),
                            ],
                            child: CreateQuizScreen(userId: userId,),
                          ),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        fixedSize: Size(size.width / 2, size.height / 5),
                        textStyle: TextStyle(fontSize: size.width * 0.05),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Stwórz quiz'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<CreateOrEditQuizCubit>(
                                  mycontext),
                              child: const QuizToChoice(),
                            ),
                          ),
                        );
                        if (mycontext
                            .read<CreateOrEditQuizCubit>()
                            .quizModelList
                            .isEmpty) {
                          await mycontext
                              .read<CreateOrEditQuizCubit>()
                              .downloadListQuiz();
                        } else {
                          mycontext
                              .read<CreateOrEditQuizCubit>()
                              .returnToQuizList();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: size.width * 0.05),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        fixedSize: Size(size.width / 2, size.height / 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Edytuj lub zarządzaj quizem',textAlign: TextAlign.center,),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          fixedSize: Size(size.width / 2, size.height / 5),
                          textStyle: TextStyle(fontSize: size.width * 0.05),
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
      ),
    );
  }
}
