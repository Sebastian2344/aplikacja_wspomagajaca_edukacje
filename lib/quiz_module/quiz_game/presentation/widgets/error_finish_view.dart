import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/quiz_cubit.dart';

class ErrorFinishView extends StatelessWidget {
  const ErrorFinishView({super.key,required this.quizFinishError});
  final QuizFinishError quizFinishError;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(gradient:LinearGradient(colors:[Colors.red.shade100,Colors.red.shade200],begin: Alignment.topCenter,end: Alignment.bottomCenter)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quizFinishError.exceptions.error,  
              style: TextStyle(color: Colors.red, fontSize: size.width * 0.04),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    fixedSize: Size(size.width / 2, size.height / 7),
                    textStyle: TextStyle(fontSize: size.width * 0.04)),
                onPressed: () async {
                  await context.read<QuizCubit>().repeatFinishQuiz(quizFinishError.nickname,quizFinishError.quizId,quizFinishError.quizOwnerId);
                },
                child: const Text('Spróbuj jeszcze raz.'))
          ],
        ),
      ),
    );
  }
}