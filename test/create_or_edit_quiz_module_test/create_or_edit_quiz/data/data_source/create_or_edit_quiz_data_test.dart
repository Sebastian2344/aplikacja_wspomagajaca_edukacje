import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/data/data_source/create_or_edit_quiz_data.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late CreateOrEditQuizData dataLayer;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = MockFirebaseAuth(mockUser: MockUser(uid: "user123",),signedIn: true);
    dataLayer = CreateOrEditQuizData(firestore, auth);
  });

  test('createQuiz zapisuje quiz, pytania i config w bazie', () async {
    final quiz = {"userId": "user123", "gameCode": 123456, "quizTitle": "Test"};
    final questions = [
      {"id": "q1", "question": "2+2?", "correctAnswer": "4", "answers": []},
      {"id": "q2", "question": "3+3?", "correctAnswer": "6", "answers": []},
    ];
    final settings = {"userId": "user123", "gameCode": 123456};

    final newId = await dataLayer.createQuiz(quiz, questions, settings);

    final quizDoc = await firestore.collection("Quizies").doc(newId).get();
    expect(quizDoc.exists, true);

    final qSnap = await firestore
        .collection("Quizies")
        .doc(newId)
        .collection("Questions")
        .get();

    expect(qSnap.docs.length, 2);

    final configSnap = await firestore.collection("ConfigQuizies").get();
    expect(configSnap.docs.length, 1);
  });

  test('editQuiz poprawnie aktualizuje/usuwa/dodaje pytania', () async {
    final quizId = "quiz123";

    await firestore.collection("Quizies").doc(quizId).set({"quizTitle": "Old"});
    await firestore
        .collection("Quizies")
        .doc(quizId)
        .collection("Questions")
        .doc("q1")
        .set({"id": "q1", "question": "A?"});
    await firestore
        .collection("Quizies")
        .doc(quizId)
        .collection("Questions")
        .doc("q2")
        .set({"id": "q2", "question": "B?"});

    final downloaded = [
      {"id": "q1"},
      {"id": "q2"},
    ];

    final toDB = [
      {"id": "q1", "question": "Updated"},
      {"id": "newQ", "question": "NewQuestion"},
    ];

    await dataLayer.editQuiz(
      {"quizTitle": "NewTitle"},
      toDB,
      quizId,
      downloaded,
    );

    final finalQuestions = await firestore
        .collection("Quizies")
        .doc(quizId)
        .collection("Questions")
        .get();

    expect(finalQuestions.docs.length, 2);
    expect(finalQuestions.docs.any((doc) => doc.id == "q1"), true);
    expect(
        finalQuestions.docs.any((doc) => doc.data()["question"] == "Updated"),
        true);
    expect(
        finalQuestions.docs
            .any((doc) => doc.data()["question"] == "NewQuestion"),
        true);
  });

  test('downloadListQuizToSelect zwraca tylko quizy użytkownika', () async {

    await firestore.collection("Quizies").doc("doc_for_user123").set({
      "userId": "user123",
      "quizTitle": "A",
    });

    await firestore.collection("Quizies").doc("doc_for_other").set({
      "userId": "otherUser",
      "quizTitle": "B",
    });

    final result = await dataLayer.downloadListQuizToSelect();

    expect(result, isNotNull);
    expect(result.docs, isNotEmpty);

    final docsForUser = result.docs.where((d) {
      final data = d.data();
      return data['userId'] == 'user123';
    }).toList();

    expect(docsForUser.length, 1);
    expect(docsForUser.first.data()['quizTitle'], 'A');

    expect(result.docs.length, 1);
  });

  test('downloadQuestions zwraca listę pytań z podkolekcji', () async {
    final quizId = "qz";

    await firestore.collection("Quizies").doc(quizId).set({});
    await firestore
        .collection("Quizies")
        .doc(quizId)
        .collection("Questions")
        .add({"id": "Q1"});
    await firestore
        .collection("Quizies")
        .doc(quizId)
        .collection("Questions")
        .add({"id": "Q2"});

    final result = await dataLayer.downloadQuestions(quizId);

    expect(result.docs.length, 2);
  });

  test('gameCodeCheck zwraca true jeśli brak quizu z tym kodem', () async {
    final result = await dataLayer.gameCodeCheck(555666);
    expect(result, true);
  });

  test('gameCodeCheck zwraca false jeśli quiz o kodzie istnieje', () async {
    await firestore.collection("Quizies").add({"gameCode": 555666});

    final result = await dataLayer.gameCodeCheck(555666);
    expect(result, false);
  });
}
