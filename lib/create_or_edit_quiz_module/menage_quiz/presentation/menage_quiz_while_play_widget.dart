import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/data_source/menage_quiz_while_play_data.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/repository/menage_quiz_while_play_repo.dart';

import '../cubit/menage_quiz_while_play_cubit.dart';
import '../../commons/models/quiz_model.dart';

class MenageQuizWhilePlayWidget extends StatelessWidget {
  const MenageQuizWhilePlayWidget(
      {super.key, required this.downloadedQuizModel});
  final QuizModel downloadedQuizModel;

  Future<MenageQuizWhilePlayCubit> _initializeCubit(int gameCode) async {
  final cubit = MenageQuizWhilePlayCubit(
    MenageQuizWhilePlayRepo(
      MenageQuizWhilePlayData(FirebaseFirestore.instance),
    ),
  );
  await cubit.setInitialColors(gameCode);
  return cubit;
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _initializeCubit(downloadedQuizModel.gameCode),
      builder:(context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Błąd inicjalizacji: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        return BlocProvider.value(
          value: snapshot.data!,
          child: Scaffold(
          appBar: AppBar(
            title: const Text('Zarządzanie Quizem'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade800,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<MenageQuizWhilePlayCubit, MenageQuizState>(
              builder: (fcontext, state) {
                if (state is MenageQuizButtonsColors) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [  
                      IconButton(
                        onPressed: () async {
                          await fcontext
                              .read<MenageQuizWhilePlayCubit>()
                              .setStart(downloadedQuizModel.gameCode,
                                  downloadedQuizModel.docID);
                        },
                        icon: const Icon(Icons.play_arrow,size: 75,),
                        color: state.setStart,
                      ),
                      Text('Rozpocznij quiz',style: TextStyle(fontSize: width * 0.05)),
                      IconButton(
                        onPressed: () async {
                          await fcontext
                              .read<MenageQuizWhilePlayCubit>()
                              .setPause(downloadedQuizModel.gameCode);
                        },
                        icon: const Icon(Icons.pause,size: 75),
                        color: state.setPause,
                      ), 
                      Text('Zapauzuj quiz',style: TextStyle(fontSize: width * 0.05)),
                      IconButton(
                        onPressed: () async {
                          await fcontext
                              .read<MenageQuizWhilePlayCubit>()
                              .setNextQuestion(downloadedQuizModel.gameCode);
                        },
                        icon: const Icon(Icons.arrow_circle_right,size: 75),
                        color: state.nextQuestion,
                      ),
                      Text('Następne pytanie',style: TextStyle(fontSize: width * 0.05),),
                      IconButton(
                        onPressed: () async {
                          await fcontext
                              .read<MenageQuizWhilePlayCubit>()
                              .setEnd(downloadedQuizModel.gameCode);
                        },
                        icon: const Icon(Icons.stop,size: 75),
                        color: state.setEnd,
                      ),
                      Text('Zakończ quiz',style: TextStyle(fontSize: width * 0.05))
                    ],
                  );
                } else if (state is MenageQuizError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.error.error),
                        ElevatedButton(
                            onPressed: () {
                              fcontext
                                  .read<MenageQuizWhilePlayCubit>()
                                  .setInitialColors(downloadedQuizModel.gameCode);
                            },
                            child: Text('Spróbuj ponownie.',style: TextStyle(fontSize: width * 0.05)))
                      ],
                    ),
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
      } else {
        return Center(child: Text('Nieoczekiwany błąd.'));
      }
        
  });
  }
}
