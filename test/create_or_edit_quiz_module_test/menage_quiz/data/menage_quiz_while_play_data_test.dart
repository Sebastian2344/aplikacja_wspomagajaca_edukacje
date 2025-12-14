import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/data_source/menage_quiz_while_play_data.dart';

void main() {
  test("downloadQuizConfig returns snapshot with correct document", () async {
    final fakeFirestore = FakeFirebaseFirestore();

    await fakeFirestore.collection('ConfigQuizies').add({
      'userId': 'U1',
      'nextQuestion': true,
      'pause': false,
      'start': true,
      'end': false,
      'gameCode': 999,
    });

    final data = MenageQuizWhilePlayData(fakeFirestore);

    final snapshot = await data.downloadQuizConfig(999);

    expect(snapshot.docs.length, 1);
    final doc = snapshot.docs.first.data();
    expect(doc['userId'], 'U1');
    expect(doc['nextQuestion'], true);
    expect(doc['start'], true);
  });

  test("setSettings updates document in Firestore", () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final docRef = await fakeFirestore.collection('ConfigQuizies').add({
      'userId': 'U1',
      'nextQuestion': false,
      'pause': false,
      'start': false,
      'end': false,
      'gameCode': 10,
    });

    final data = MenageQuizWhilePlayData(fakeFirestore);

    await data.setSettings({
      'nextQuestion': true,
      'pause': true,
    }, docRef.id);

    final updated = await docRef.get();

    expect(updated.data()!['nextQuestion'], true);
    expect(updated.data()!['pause'], true);
  });

  test("deleteStats deletes all players stats in batch", () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final quizDoc = fakeFirestore.collection('Quizies').doc("QUIZ1");
    await quizDoc.collection('PlayersStats').add({'points': 10});
    await quizDoc.collection('PlayersStats').add({'points': 20});
    await quizDoc.collection('PlayersStats').add({'points': 30});

    final data = MenageQuizWhilePlayData(fakeFirestore);

    await data.deleteStats("QUIZ1");

    final stats = await quizDoc.collection('PlayersStats').get();
    expect(stats.docs.length, 0);
  });
}
