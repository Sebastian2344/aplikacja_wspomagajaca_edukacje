import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/cubit/quiz_panel_cubit.dart';

import '../../../commons/models/quiz_model.dart';
import '../../../quiz_panel/presentation/widgets/edit_quiz_widget.dart';
import '../../cubit/create_or_edit_quiz_cubit.dart';

class Edit extends StatelessWidget {
  const Edit({super.key,required this.panelState,required this.downloadedQuizModel,required this.downloadedListQuestionModel});
  final QuizPanelState panelState;
  final QuizModel downloadedQuizModel;
  final List<QuestionModel> downloadedListQuestionModel;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrEditQuizCubit, CreateOrEditQuizState>(
      listener: (context, state) {
        if (state is SuccessEdit) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.text)));
          context.read<CreateOrEditQuizCubit>().backToSelectedState(
              panelState.questions,
              QuizModel(
                  docID: downloadedQuizModel.docID,
                  userId: downloadedQuizModel.userId,
                  gameCode: panelState.gameCode,
                  quizTitle: panelState.quizTitle));
        }
      },
      child: EditQuizWidget(
        downloadedQuizModel: downloadedQuizModel,
        downloadedListQuestionModel: downloadedListQuestionModel,
      ),
    );
  }
}
