class QuestionModelGame {
  final String question;
  final List<String> answers;
  final String correctAnswer;
  final String category;
  QuestionModelGame({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.category,
  });

  factory QuestionModelGame.fromJson(Map<String, dynamic> map) {
    return QuestionModelGame(
        question:  map['pytanie'],
        answers:  List<String>.from(map['odpowiedzi']),
        correctAnswer:  map['poprawna_odpowiedź'],
        category:  map['kategoria']);
  }
}
