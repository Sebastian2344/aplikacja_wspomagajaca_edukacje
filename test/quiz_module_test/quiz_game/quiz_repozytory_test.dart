import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/quiz_game/data/data_source/quiz_source.dart';
import 'package:quiztale/quiz_module/quiz_game/data/repository/quiz_repository.dart';

/// --------- MOCK ---------
class MockQuizSource extends Mock implements QuizSource {}

/// -------- FAKE SNAPSHOTS ----------
class FakeQueryDocumentSnapshot extends Fake
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> map;
  final String fakeId;

  FakeQueryDocumentSnapshot(this.map, this.fakeId);

  @override
  Map<String, dynamic> data() => map;

  @override
  String get id => fakeId;
}

class FakeQuerySnapshot extends Fake
    implements QuerySnapshot<Map<String, dynamic>> {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> fakeDocs;

  FakeQuerySnapshot(this.fakeDocs);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => fakeDocs;
}

class FakeDocumentSnapshot extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> map;
  final String fakeId;

  FakeDocumentSnapshot(this.map, {this.fakeId = "settings_id"});

  @override
  Map<String, dynamic>? data() => map;

  @override
  String get id => fakeId;
}

void main() {
  late MockQuizSource mockQuizSource;
  late QuizRepository repository;

  setUp(() {
    mockQuizSource = MockQuizSource();
    repository = QuizRepository(mockQuizSource);
  });

  group('getQuestions', () {
    test('zwraca Right(List<QuestionModel>) i mapuje poprawnie dane', () async {
      final fakeSnapshot = FakeQuerySnapshot([
        FakeQueryDocumentSnapshot(
          {
            "question": "Pytanie 1",
            "answers": ["A", "B", "C"],
            "correctAnswer": "A",
            "points": 5,
            "timeLimit": 20,
            "urlImage": "http://img.com/1.png",
          },
          "q1",
        ),
      ]);

      when(() => mockQuizSource.getQuestions("quiz123"))
          .thenAnswer((_) async => fakeSnapshot);

      final result = await repository.getQuestions("quiz123");

      expect(result.isRight(), true);
      result.fold(
        (_) => fail("Expected Right"),
        (questions) {
          expect(questions.length, 1);
          expect(questions.first.docId, "q1");
          expect(questions.first.question, "Pytanie 1");
          expect(questions.first.answers.length, 3);
          expect(questions.first.correctAnswer, "A");
          expect(questions.first.points, 5);
        },
      );
    });
  });

  group('getSettings', () {
    test('mapuje poprawnie SettingsModel', () async {
      final stream = Stream.value(
        FakeDocumentSnapshot({
          "userId": "user123",
          "nextQuestion": true,
          "pause": false,
          "start": true,
          "end": false,
          "gameCode": 999,
        }),
      );

      when(() => mockQuizSource.getSettings(999))
          .thenAnswer((_) async => stream);

      final result = await repository.getSettings(999);

      expect(result.isRight(), true);

      final settingsStream = result.getOrElse(() => throw Exception());

      final settings = await settingsStream.first;

      expect(settings.userId, "user123");
      expect(settings.nextQuestion, true);
      expect(settings.pause, false);
      expect(settings.start, true);
      expect(settings.end, false);
      expect(settings.gameCode, 999);
    });
  });

  group('putSolvedQuiz', () {
    test('zwraca Right(docId)', () async {
      when(() => mockQuizSource.putSolvedQuiz(any(), "z1"))
          .thenAnswer((_) async => "doc55");

      final result =
          await repository.putSolvedQuiz(33, "Nick", "z1", "userA");

      expect(result.isRight(), true);
      expect(result.getOrElse(() => ""), "doc55");
    });
  });

  group('getSolvedQuizies', () {
    test('mapuje poprawnie SolvedQuizModel', () async {
      final fakeSnapshot = FakeQuerySnapshot([
        FakeQueryDocumentSnapshot(
          {
            "quizOwnerUserId": "owner123",
            "nickname": "Player1",
            "result": 50,
          },
          "solved1",
        ),
      ]);

      when(() => mockQuizSource.getSolvedQuizies("quizXYZ"))
          .thenAnswer((_) async => fakeSnapshot);

      final result = await repository.getSolvedQuizies("quizXYZ");

      expect(result.isRight(), true);

      final list = result.getOrElse(() => []);

      expect(list.length, 1);
      expect(list.first.quizOwnerUserId, "owner123");
      expect(list.first.nickname, "Player1");
      expect(list.first.points, 50);
    });
  });
}