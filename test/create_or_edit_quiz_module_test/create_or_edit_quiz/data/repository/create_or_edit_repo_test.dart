import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_config_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/data/data_source/create_or_edit_quiz_data.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/data/repository/create_or_edit_quiz_repo.dart';

class MockCreateQuizData extends Mock implements CreateOrEditQuizData {}

class FakeQuizModel extends Fake implements QuizModel {}
class FakeQuestionModel extends Fake implements QuestionModel {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockCreateQuizData data;
  late CreateOrEditQuizRepo repo;

  setUp(() {
    data = MockCreateQuizData();
    repo = CreateOrEditQuizRepo(data);

    registerFallbackValue(FakeQuizModel());
    registerFallbackValue(FakeQuestionModel());
  });

  group('createQuiz', () {
    test('powinno zwrócić Right(id) przy sukcesie', () async {
      when(() => data.createQuiz(any(), any(), any()))
          .thenAnswer((_) async => "generatedId");

      final quiz = QuizModel(docID: "", userId: "u", gameCode: 111, quizTitle: "Test");
      final settings = QuizConfigModel(docId: "", userId: "u", nextQuestion: false, pause: false, start: false, end: false, gameCode: 111);

      final result = await repo.createQuiz(quiz, [], settings);

      expect(result, equals(const Right("generatedId")));
    });

    test('powinno zwrócić Left(exception) przy błędzie', () async {
      when(() => data.createQuiz(any(), any(), any()))
          .thenThrow(NetworkException(error:"network error"));

      final quiz = QuizModel(docID: "", userId: "u", gameCode: 111, quizTitle: "Test");
      final settings = QuizConfigModel(docId: "", userId: "u", nextQuestion: false, pause: false, start: false, end: false, gameCode: 111);

      final result = await repo.createQuiz(quiz, [], settings);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkException>()),
        (r) => fail("Should not return Right"),
      );
    });
  });

  group('editQuiz', () {
    test('powinno zwrócić Right(void) przy sukcesie', () async {
      when(() => data.editQuiz(any(), any(), any(), any()))
          .thenAnswer((_) async => Future.value());

      final quiz = QuizModel(docID: "1", userId: "u", gameCode: 123, quizTitle: "Title");

      final result = await repo.editQuiz("1", quiz, [], []);

      expect(result.isRight(), true);
    });

    test('powinno zwrócić Left(exception) gdy wystąpi błąd', () async {
      when(() => data.editQuiz(any(), any(), any(), any()))
          .thenThrow(OtherFirebaseException(error: "firebase error"));

      final quiz = QuizModel(docID: "1", userId: "u", gameCode: 123, quizTitle: "Title");

      final result = await repo.editQuiz("1", quiz, [], []);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<OtherFirebaseException>()),
        (r) => fail("Should be Left"),
      );
    });
  });

 group('downloadListQuizToSelect', () {
    test('powinno zwrócić Right(list<QuizModel>) przy sukcesie', () async {

      final snapshot = MockQuerySnapshot();
      final doc = MockQueryDocumentSnapshot();

      when(() => snapshot.docs).thenReturn([doc]);

      when(() => doc.data()).thenReturn({
        "userId": "u",
        "gameCode": 222333,
        "quizTitle": "Quiz testowy",
      });

      when(() => doc.id).thenReturn("doc123");

      when(() => data.downloadListQuizToSelect())
          .thenAnswer((_) async => snapshot);

      final result = await repo.downloadListQuizToSelect();
      
      expect(result.isRight(), true);

      result.fold(
        (_) => fail("Should return Right"),
        (list) {
          expect(list.length, 1);
          expect(list.first.quizTitle, "Quiz testowy");
        },
      );
    });

    test('powinno zwrócić Left(exception) przy błędzie', () async {
      when(() => data.downloadListQuizToSelect())
          .thenThrow(NetworkException(error:"err"));

      final result = await repo.downloadListQuizToSelect();

      expect(result.isLeft(), true);
    });
  });

  group('downloadQuestions', () {
    test('powinno zwrócić Right(List<QuestionModel>) przy sukcesie', () async {

      final snapshot = MockQuerySnapshot();
      final doc = MockQueryDocumentSnapshot();

      when(() => snapshot.docs).thenReturn([doc]);

      when(() => doc.data()).thenReturn({
        "question": "2+2?",
        "correctAnswer": "4",
        "answers": ["1", "2", "3", "4"],
        "userId": "u1",
        "points": 10,
        "timeLimit": 30,
        "urlImage": "",
      });

      when(() => data.downloadQuestions("123"))
          .thenAnswer((_) async => snapshot);

      final result = await repo.downloadQuestions("123");

      expect(result.isRight(), true);

      result.fold(
        (_) => fail("Should return Right"),
        (list) {
          expect(list.length, 1);
          expect(list.first.question, "2+2?");
        },
      );
    });

    test('powinno zwrócić Left(exception) przy błędzie', () async {
      when(() => data.downloadQuestions("123"))
          .thenThrow(NetworkException(error:"network"));

      final result = await repo.downloadQuestions("123");

      expect(result.isLeft(), true);
    });
  });

  group('gameCodeCheck', () {
    test('powinno zwrócić Right(bool)', () async {
      when(() => data.gameCodeCheck(123456))
          .thenAnswer((_) async => true);

      final result = await repo.gameCodeCheck(123456);

      expect(result, equals(const Right(true)));
    });

    test('powinno zwrócić Left(exception)', () async {
      when(() => data.gameCodeCheck(123456))
          .thenThrow(UnknownException(error: "err"));

      final result = await repo.gameCodeCheck(123456);

      expect(result.isLeft(), true);
    });
  });

  test('getUserId powinno zwrócić to samo co data.getUserId', () {
    when(() => data.getUserId()).thenReturn("user123");

    final result = repo.getUserId();

    expect(result, "user123");
  });
}