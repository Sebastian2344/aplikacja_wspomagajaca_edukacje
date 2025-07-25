import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/user_answer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/data/data_source/quiz_source.dart';
import 'package:quiztale/quiz_module/quiz_game/data/repository/quiz_repository.dart';

import '../../cubit/quiz_cubit.dart';
import '../../cubit/timer_cubit.dart';
import '../widgets/end_view.dart';
import '../widgets/error_finish_view.dart';
import '../widgets/error_view.dart';
import '../widgets/question_view.dart';
import '../widgets/result_view.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.gameCode, required this.quizId, required this.nickname,required this.quizOwnerId});
  final int gameCode;
  final String quizId;
  final String nickname;
  final String quizOwnerId;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerCubit(),
        ),
        BlocProvider(
          create: (context) => UserAnswerCubit(),
        ),
        BlocProvider(
          create: (context) => QuizCubit(
              QuizRepository(QuizSource(FirebaseFirestore.instance)),
              context.read<TimerCubit>(),
              context.read<UserAnswerCubit>())..turnOnTheQuizMechanism(quizId, gameCode, nickname,quizOwnerId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Quiztale', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width * 0.05)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Czy chcesz opuścic quiz i pójść do menu?'),
                          content: const Text(
                              'Jeżeli opuścisz quiz to stracisz punkty.'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();                                  
                                },
                                child: const Text('Tak')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Nie')),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.menu))
          ],
        ),
        body: BlocBuilder<QuizCubit, QuizState>(          
          builder: (context, state) {
            if (state is ShowQuestion) {
              return QuestionView(question: state.question);
            } else if (state is ShowCorrectAnswer) {
              return ResultView(showCorrectAnswer: state);
            } else if (state is ShowPauseQuiz) {
              return const Center(
                  child: Icon(Icons.pause, size: 50, color: Colors.orange));
            } else if (state is ShowEndScreen) {
              return EndView(data: state.data);
            } else if (state is QuizError) {
              return ErrorView(
                quizError: state,
              );
            } else if (state is QuizFinishError) {
              return ErrorFinishView(
                quizFinishError: state,
              );
            }
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
    );
  }
}
