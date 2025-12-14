import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_config_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/data/repository/create_or_edit_quiz_repo.dart';

class MockCreateQuizRepo extends Mock implements CreateOrEditQuizRepo {}
class FakeQuizModel extends Fake implements QuizModel {}
class FakeQuestionModel extends Fake implements QuestionModel {}
class FakeQuizConfigModel extends Fake implements QuizConfigModel {}

void main() {
  late MockCreateQuizRepo repo;
  late CreateOrEditQuizCubit cubit;

  setUp(() {
    repo = MockCreateQuizRepo();
    cubit = CreateOrEditQuizCubit(repo);
  });

  setUpAll(() {
    registerFallbackValue(FakeQuizModel());
    registerFallbackValue(FakeQuestionModel());
    registerFallbackValue(FakeQuizConfigModel());
  });

  group('saveInDatabaseCreatedQuiz', () {
    test('powinien emitować SuccessCreate i dodać quiz do listy', () async {

      when(() => repo.getUserId()).thenReturn("user1");

      when(() => repo.createQuiz(any(), any(), any()))
          .thenAnswer((_) async => const Right("quiz123"));

      await cubit.saveInDatabaseCreatedQuiz(
        111222,
        "Test Quiz",
        [FakeQuestionModel()],
      );

      expect(cubit.state, isA<SuccessCreate>());
      expect(cubit.quizModelList.length, 1);
      expect(cubit.quizModelList.first.quizTitle, "Test Quiz");
    });

    test('powinien emitować CreateQuizError gdy repo zwróci błąd', () async {
      when(() => repo.getUserId()).thenReturn("user1");

      when(() => repo.createQuiz(any(), any(), any()))
          .thenAnswer((_) async => const Left(UnknownException(error: "err")));

      await cubit.saveInDatabaseCreatedQuiz(123456, "ABC", []);

      expect(cubit.state, isA<CreateQuizError>());
    });
  });

  group('saveInDatabaseEditedQuiz', () {
    test('powinien emitować SuccessEdit i zaktualizować quiz w liście', () async {
      final quiz = QuizModel(
        docID: "id1",
        userId: "user",
        gameCode: 111000,
        quizTitle: "Old title",
      );

      cubit.quizModelList.add(quiz);

      when(() => repo.editQuiz(any(), any(), any(), any()))
          .thenAnswer((_) async => const Right(null));

      final editedQuiz = QuizModel(
        docID: "id1",
        userId: "user",
        gameCode: 111000,
        quizTitle: "New title",
      );

      await cubit.saveInDatabaseEditedQuiz(
          "id1",
          editedQuiz,
          [],
          [],
      );

      expect(cubit.state, isA<SuccessEdit>());
      expect(cubit.quizModelList.first.quizTitle, "New title");
    });

    test('powinien emitować CreateQuizError jeśli repo zwróci błąd', () async {
      when(() => repo.editQuiz(any(), any(), any(), any()))
          .thenAnswer((_) async => const Left(UnknownException(error: "err")));

      await cubit.saveInDatabaseEditedQuiz("1", QuizModel(docID: "1", userId: "u", gameCode: 0, quizTitle: ""), [], []);

      expect(cubit.state, isA<CreateQuizError>());
    });
  });

  group('downloadListQuiz', () {
    test('powinien pobierać listę quizów i emitować DownloadedListQuizies', () async {
      final list = [
        QuizModel(docID: "1", userId: "u", gameCode: 222333, quizTitle: "Quiz")
      ];

      when(() => repo.downloadListQuizToSelect())
          .thenAnswer((_) async => Right(list));

      await cubit.downloadListQuiz();

      expect(cubit.state, isA<DownloadedListQuizies>());
      expect(cubit.quizModelList.length, 1);
    });

    test('powinien emitować CreateQuizError gdy pobieranie nie powiedzie się', () async {
      when(() => repo.downloadListQuizToSelect())
          .thenAnswer((_) async => const Left(UnknownException(error: "err")));

      await cubit.downloadListQuiz();

      expect(cubit.state, isA<CreateQuizError>());
    });
  });

  group('selectQuizToEdit', () {
    test('powinien pobrać pytania i emitować DownloadedSelectedQuiz', () async {
      final quiz = QuizModel(docID: "55", userId: "uuu", gameCode: 123123, quizTitle: "Demo");
      final questions = [
        QuestionModel(userId: "q1", question: "?", correctAnswer: "", answers: [],points: 0, timeLimit: 50,urlImage: ''),
      ];

      when(() => repo.downloadQuestions("55"))
          .thenAnswer((_) async => Right(questions));

      await cubit.selectQuizToEdit(quiz);

      expect(cubit.state, isA<DownloadedSelectedQuiz>());
    });

    test('powinien emitować CreateQuizError kiedy repo zwróci błąd', () async {
      final quiz = QuizModel(docID: "x", userId: "u", gameCode: 0, quizTitle: "T");

      when(() => repo.downloadQuestions("x"))
          .thenAnswer((_) async => const Left(UnknownException(error: "err")));

      await cubit.selectQuizToEdit(quiz);

      expect(cubit.state, isA<CreateQuizError>());
    });
  });

  group('generateGameCode', () {
    test('powinien wygenerować poprawny kod (6 cyfr)', () async {
      when(() => repo.gameCodeCheck(any()))
          .thenAnswer((_) async => const Right(true));

      final code = await cubit.generateGameCode();

      expect(code, greaterThanOrEqualTo(100000));
      expect(code, lessThanOrEqualTo(999999));
    });
  });

  test('getUserId powinien wywołać repo.getUserId', () {
    when(() => repo.getUserId()).thenReturn("user123");

    final user = cubit.getUserId();

    expect(user, "user123");
  });

  test('backToInitial powinno emitować CreateQuizInitial', () {
    cubit.backToInitial();
    expect(cubit.state, isA<CreateQuizInitial>());
  });
}