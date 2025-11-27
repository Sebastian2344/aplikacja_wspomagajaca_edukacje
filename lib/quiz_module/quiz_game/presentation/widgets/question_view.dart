import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/timer_cubit.dart';
import '../../cubit/user_answer_cubit.dart';
import '../../../commons/model/question_model.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.question,
  });

  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.lightBlue.shade200],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuestionContainer(width,context),
            _buildImageContainer(context, width,question),
            _buildTimerContainer(context, width),
            _buildAnswerButtons(context, width),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContainer(double width,BuildContext context) {
     return Container(
      height: MediaQuery.of(context).size.height / 4,
       alignment: Alignment.center,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: Colors.blueGrey.shade700,
         borderRadius: BorderRadius.circular(8),
       ),
       child: Text(
         question.question,
         style: TextStyle(
           fontSize: width * 0.05,
           fontWeight: FontWeight.bold,
           color: Colors.white,
         ),
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
         textAlign: TextAlign.center,
       ),
     );
  }

  Widget _buildTimerContainer(BuildContext context, double width) {
    return Container(
      width: width * 0.5,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade600,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        "Czas odpowiedzi: ${context.watch<TimerCubit>().reamingTime}s",
        style: TextStyle(
          fontSize: width * 0.04,
          color: Colors.amberAccent,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerButtons(BuildContext context, double width) {
  return BlocBuilder<UserAnswerCubit, UserAnswerState>(
    builder: (context, state) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              question.answers.length,
              (index) => _buildAnswerButton(context, state, question.answers, index, width),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildAnswerButton(
  BuildContext context,
  UserAnswerState state,
  List<String> answers,
  int index,
  double width,
) {
  final colors = [
    Colors.green.shade600,
    Colors.cyan.shade500,
    Colors.orange.shade500,
    Colors.redAccent.shade400,
  ];

  return GestureDetector(
    onTap: () {
      context.read<UserAnswerCubit>().initStateUserAnswer();
      context.read<UserAnswerCubit>().setCheckIconAnswer(answers[index], answers);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      width: width,
      height: MediaQuery.of(context).size.height / 8,
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(2, 4),
          ),
        ],
      ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                  answers[index],
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
            if (state is UserAnswerIcon && state.icon[index] != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: state.icon[index]!,
              ),
          ],
        ),
      ),
    );
}
  
  Widget _buildImageContainer(BuildContext context, double width,QuestionModel question) {
    return question.urlImage != ''? Padding(padding: EdgeInsets.all(12),child: Image.network(question.urlImage,  height: MediaQuery.of(context).size.height / 5,),): SizedBox();
  }
}