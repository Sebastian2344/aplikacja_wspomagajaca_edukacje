import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_config_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/data_source/menage_quiz_while_play_data.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/repository/menage_quiz_while_play_repo.dart';

class MockMenageQuizWhilePlayData extends Mock
    implements MenageQuizWhilePlayData {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  late MockMenageQuizWhilePlayData data;
  late MenageQuizWhilePlayRepo repo;

  setUp(() {
    data = MockMenageQuizWhilePlayData();
    repo = MenageQuizWhilePlayRepo(data);
  });

  group("MenageQuizWhilePlayRepo Tests", () {
    test("downloadQuizConfig returns Right(QuizConfigModel) on success",
        () async {
      final fakeFirestore = FakeFirebaseFirestore();

      await fakeFirestore.collection('ConfigQuizies').doc('ABC123').set({
        'userId': 'U1',
        'nextQuestion': true,
        'pause': false,
        'start': false,
        'end': false,
        'gameCode': 777,
      });

      final data = MenageQuizWhilePlayData(fakeFirestore);
      final repo = MenageQuizWhilePlayRepo(data);

      final result = await repo.downloadQuizConfig(777);

      result.fold(
        (_) => fail("Should return Right"),
        (model) {
          expect(model.docId, "ABC123");
          expect(model.userId, "U1");
          expect(model.nextQuestion, true);
          expect(model.pause, false);
          expect(model.start, false);
          expect(model.end, false);
          expect(model.gameCode, 777);
        },
      );
    });

    test("downloadQuizConfig returns Left(Exception) on error", () async {
      when(() => data.downloadQuizConfig(111))
          .thenThrow(NetworkException(error: "No internet"));

      final result = await repo.downloadQuizConfig(111);

      expect(result.isLeft(), true);
      result.fold(
        (e) => expect(e, isA<NetworkException>()),
        (_) => fail("Should return Left"),
      );
    });

    test("setSettings returns Right(void)", () async {
      final model = QuizConfigModel(
        docId: "123",
        start: false,
        pause: false,
        end: false,
        nextQuestion: false,
        gameCode: 999,
        userId: "user999",
      );

      when(() => data.setSettings(any(), "123"))
          .thenAnswer((_) async => Future.value());

      final result = await repo.setSettings("123", model);

      expect(result.isRight(), true);
    });

    test("setSettings returns Left(Exception) on error", () async {
      final model = QuizConfigModel(
        docId: "123",
        start: false,
        pause: false,
        end: false,
        nextQuestion: false,
        gameCode: 999,
        userId: "user999",
      );

      when(() => data.setSettings(any(), "123"))
          .thenThrow(OtherFirebaseException(error: "Firestore error"));

      final result = await repo.setSettings("123", model);

      expect(result.isLeft(), true);
      result.fold(
        (e) => expect(e, isA<OtherFirebaseException>()),
        (_) => fail("Should not return Right"),
      );
    });

    test("deleteStats returns Right(void) on success", () async {
      when(() => data.deleteStats("quiz123"))
          .thenAnswer((_) async => Future.value());

      final result = await repo.deleteStats("quiz123");

      expect(result.isRight(), true);
    });

    test("deleteStats returns Left(Exception) on error", () async {
      when(() => data.deleteStats("quiz123"))
          .thenThrow(NetworkException(error: "Network error"));

      final result = await repo.deleteStats("quiz123");

      expect(result.isLeft(), true);
      result.fold(
        (e) => expect(e, isA<NetworkException>()),
        (_) => fail("Should not return Right"),
      );
    });
  });
}
