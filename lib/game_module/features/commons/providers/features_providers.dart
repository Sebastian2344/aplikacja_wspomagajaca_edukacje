import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../level_menage/cubit/level_cubit.dart';
import '../../quiz_menage/cubit/quiz_part_game_cubit.dart';
import '../../quiz_menage/data/data_source/question_game_source.dart';
import '../../quiz_menage/data/repository/question_game_repo.dart';
import '../game_widget/my_game_widget.dart';

class FeaturesProviders extends StatelessWidget {
  FeaturesProviders({super.key, required this.classCategory});
  final String classCategory;
  final quizPartGame =
      QuizPartGameCubit(QuestionGameRepo(QuestionGameSource()));
  final levelsMenagmentCubit = LevelsMenagmentCubit();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => quizPartGame..loadQuestions(classCategory),
          ),
          BlocProvider(
            create: (context) => levelsMenagmentCubit,
          ),
        ],
        child: MyGameWidget(
          quizPartGameCubit: quizPartGame,
          levelsMenagmentCubit: levelsMenagmentCubit,
        ));
  }
}
