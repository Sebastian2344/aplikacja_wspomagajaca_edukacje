import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/cubit/quiz_panel_cubit.dart';

void main() {
  group('QuizPanelCubit', () {
    late QuizPanelCubit cubit;

    setUp(() {
      cubit = QuizPanelCubit();
    });

    tearDown(() {
      cubit.close();
    });

    //---------------------------------------------------------------------------
    // UPDATE METHODS
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updateIndex updates currentIndex',
      build: () => cubit,
      act: (cubit) => cubit.updateIndex(2),
      expect: () => [isA<QuizPanelState>().having((s) => s.currentIndex, 'currentIndex', 2)],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updateQuestionText updates questionText',
      build: () => cubit,
      act: (cubit) => cubit.updateQuestionText("Test question"),
      expect: () => [
        isA<QuizPanelState>().having((s) => s.questionText, 'questionText', "Test question"),
      ],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updateAnswerText updates selected answer',
      build: () => cubit,
      act: (cubit) => cubit.updateAnswerText(0, "abc"),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.answerTexts[0], 'answer[0]', "abc"),
      ],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updateCorrectAnswer sets correctAnswer',
      build: () => cubit,
      seed: () => const QuizPanelState(answerTexts: ["A", "B", "C"]),
      act: (cubit) => cubit.updateCorrectAnswer(1),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.correctAnswer, 'correctAnswer', "B"),
      ],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updatePoints parses number correctly',
      build: () => cubit,
      act: (cubit) => cubit.updatePoints("5"),
      expect: () => [
        isA<QuizPanelState>().having((s) => s.points, 'points', 5),
      ],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'updateTimeLimit parses number correctly',
      build: () => cubit,
      act: (cubit) => cubit.updateTimeLimit("50"),
      expect: () => [
        isA<QuizPanelState>().having((s) => s.timeLimit, 'timeLimit', 50),
      ],
    );

    //---------------------------------------------------------------------------
    // FORM VALIDATION
    //---------------------------------------------------------------------------

    test('isFormValidQuiz returns true for valid title', () {
      cubit.updateQuizTitle("Valid title");
      expect(cubit.isFormValidQuiz(), true);
    });

    test('isFormValidQuiz returns false when empty', () {
      cubit.updateQuizTitle("");
      expect(cubit.isFormValidQuiz(), false);
    });

    test('isFormValidQuestion returns true for valid fields', () {
      cubit
        ..updateQuestionText("Valid question?")
        ..changeNumberOfAnswers(3)
        ..updateAnswerText(0, "Yes")
        ..updateAnswerText(1, "No")
        ..updateAnswerText(2, "Maybe")
        ..updateCorrectAnswer(0)
        ..updatePoints("5")
        ..updateTimeLimit("30");

      expect(cubit.isFormValidQuestion(), true);
    });

    test('isFormValidQuestion returns false for invalid question text', () {
      cubit.updateQuestionText("aaa"); // too short
      expect(cubit.isFormValidQuestion(), false);
    });

    //---------------------------------------------------------------------------
    // ADD QUESTION
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'addQuestion adds a new question and resets fields',
      build: () => cubit,
      seed: () => const QuizPanelState(
        questionText: "Q1",
        answerTexts: ["A", "B", "C", "D"],
        correctAnswer: "A",
        points: 5,
        timeLimit: 30,
        imageUrl: "url.com/image.jpg",
      ),
      act: (cubit) => cubit.addQuestion("user123"),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.questions.length, 'questions length', 1)
            .having((s) => s.questionText, 'cleared question', '')
            .having((s) => s.points, 'default points', 1)
            .having((s) => s.timeLimit, 'default time', 30),
      ],
    );

    //---------------------------------------------------------------------------
    // EDIT MODE
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'prepareToEdit loads question into state',
      build: () => cubit,
      seed: () => QuizPanelState(
        questions: [
          QuestionModel(
            userId: "user",
            question: "Q1",
            answers: ["A", "B", "C"],
            correctAnswer: "A",
            timeLimit: 45,
            points: 3,
            urlImage: "img.jpg",
          ),
        ],
      ),
      act: (cubit) => cubit.prepareToEdit(0, true),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.questionText, 'questionText', "Q1")
            .having((s) => s.answerTexts, 'answers', ["A", "B", "C"])
            .having((s) => s.correctAnswer, 'correctAnswer', "A"),
      ],
    );

    //---------------------------------------------------------------------------
    // EDIT QUESTION
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'editQuestion replaces a question at index',
      build: () => cubit,
      seed: () => QuizPanelState(
        questions: [
          QuestionModel(
            userId: "user",
            question: "Old",
            answers: ["A"],
            correctAnswer: "A",
            points: 1,
            timeLimit: 30,
            urlImage: "",
          )
        ],
      ),
      act: (cubit) {
        cubit.prepareToEdit(0, true);
        final updated = QuestionModel(
          userId: "user",
          question: "New",
          answers: ["B"],
          correctAnswer: "B",
          points: 3,
          timeLimit: 60,
          urlImage: "new.png",
        );
        cubit.editQuestion(updated);
      },
      expect: () => [
        // prepareToEdit
        isA<QuizPanelState>(),
        // editQuestion result
        isA<QuizPanelState>()
            .having((s) => s.questions.first.question, 'updated question', "New")
            .having((s) => s.questionText, 'cleared question', ''),
      ],
    );

    //---------------------------------------------------------------------------
    // REMOVE QUESTION
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'removeQuestion removes question at index',
      build: () => cubit,
      seed: () => QuizPanelState(
        questions: [
          QuestionModel(
              userId: "", question: "Q1", answers: ["A"], correctAnswer: "A", points: 1, timeLimit: 13, urlImage: ''),
          QuestionModel(
              userId: "", question: "Q2", answers: ["B"], correctAnswer: "B", points: 2, timeLimit: 13, urlImage: ''),
        ],
      ),
      act: (cubit) => cubit.removeQuestion(0),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.questions.length, 'questions count', 1)
            .having((s) => s.questions.first.question, 'remaining', "Q2"),
      ],
    );

    //---------------------------------------------------------------------------
    // CHANGE NUMBER OF ANSWERS
    //---------------------------------------------------------------------------

    blocTest<QuizPanelCubit, QuizPanelState>(
      'changeNumberOfAnswers increases number of answers',
      build: () => cubit,
      seed: () => const QuizPanelState(answerTexts: ["A", "B"]),
      act: (cubit) => cubit.changeNumberOfAnswers(4),
      expect: () => [
        isA<QuizPanelState>().having(
          (s) => s.answerTexts.length,
          'new answers length',
          4,
        ),
      ],
    );

    blocTest<QuizPanelCubit, QuizPanelState>(
      'changeNumberOfAnswers decreases number of answers',
      build: () => cubit,
      seed: () => const QuizPanelState(answerTexts: ["A", "B", "C"]),
      act: (cubit) => cubit.changeNumberOfAnswers(2),
      expect: () => [
        isA<QuizPanelState>()
            .having((s) => s.answerTexts.length, 'len', 2)
            .having((s) => s.answerTexts, 'answers', ["A", "B"]),
      ],
    );
  });
}
