part of 'quiz_panel_cubit.dart';

class QuizPanelState extends Equatable {
  final String questionText;
  final List<String> answerTexts;
  final String correctAnswer;
  final List<QuestionModel> questions;
  final int numberOfAnswers;
  final int points;
  final int timeLimit;
  final String imageUrl;
  final String quizTitle;
  final int gameCode;
  final int currentIndex;

  const QuizPanelState({
    this.currentIndex = 0,
    this.gameCode = 0,
    this.quizTitle = '',
    this.questionText = '',
    this.answerTexts = const [
      '',
      '',
    ],
    this.correctAnswer = '',
    this.questions = const [],
    this.numberOfAnswers = 2,
    this.points = 1,
    this.timeLimit = 30,
    this.imageUrl = '',
  });

  QuizPanelState copyWith({
    String? questionText,
    List<String>? answerTexts,
    String? correctAnswer,
    List<QuestionModel>? questions,
    int? numberOfAnswers,
    int? points,
    int? timeLimit,
    String? imageUrl,
    String? quizTitle,
    int? gameCode,
    int? currentIndex,
  }) {
    return QuizPanelState(
      questionText: questionText ?? this.questionText,
      answerTexts: answerTexts ?? this.answerTexts,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      questions: questions ?? this.questions,
      numberOfAnswers: numberOfAnswers ?? this.numberOfAnswers,
      points: points ?? this.points,
      timeLimit: timeLimit ?? this.timeLimit,
      imageUrl: imageUrl ?? this.imageUrl,
      quizTitle: quizTitle ?? this.quizTitle,
      gameCode: gameCode ?? this.gameCode,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
        questionText,
        answerTexts,
        correctAnswer,
        questions,
        numberOfAnswers,
        points,
        timeLimit,
        imageUrl,
        quizTitle,
        gameCode,
        currentIndex,
      ];
}
