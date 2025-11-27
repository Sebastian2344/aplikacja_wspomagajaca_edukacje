import 'package:flutter/material.dart';

import '../../cubit/quiz_cubit.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.showCorrectAnswer,
  });

  final ShowCorrectAnswer showCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            showCorrectAnswer.isCorrect
                ? Colors.green.shade300
                : Colors.green.shade100,
            showCorrectAnswer.isCorrect == false
                ? Colors.red.shade300
                : Colors.red.shade100,
          ],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildResultMessage(),
              const SizedBox(height: 24),
              _buildQuestionDisplay(),
              const SizedBox(height: 16),
              _buildCorrectAnswerDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultMessage() {
    return Text(
      showCorrectAnswer.isCorrect
          ? "Twoja odpowiedź była poprawna!"
          : "Twoja odpowiedź była błędna!",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: showCorrectAnswer.isCorrect ? Colors.green.shade900 : Colors.red.shade900,
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black45,
            offset: Offset(2, 2),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQuestionDisplay() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          "Pytanie: ${showCorrectAnswer.quizModel.question}",
          style: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCorrectAnswerDisplay() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          "Prawidłowa odpowiedź: ${showCorrectAnswer.quizModel.correctAnswer}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}