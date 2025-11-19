import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_source.dart/gamecode_source.dart';
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionRef extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
void main() {
  late MockFirebaseFirestore db;
  late MockCollectionRef collection;
  late MockQuery query;
  late MockQuerySnapshot snapshot;
  late MockQueryDocumentSnapshot doc;

  late GameCodeSource source;

  setUp(() {
    db = MockFirebaseFirestore();
    collection = MockCollectionRef();
    query = MockQuery();
    snapshot = MockQuerySnapshot();
    doc = MockQueryDocumentSnapshot();

    source = GameCodeSource(db);

    when(() => db.collection('Quizies')).thenReturn(collection);
    when(() => collection.where('gameCode', isEqualTo: any(named: 'isEqualTo')))
        .thenReturn(query);
    when(() => query.limit(1)).thenReturn(query);
  });

  group('GameCodeSource.isQuizExist', () {

    test('returns (id, true, snapshot) when quiz exists', () async {
      when(() => snapshot.docs).thenReturn([doc]);
      when(() => doc.id).thenReturn("quiz123");
      when(() => query.get()).thenAnswer((_) async => snapshot);

      final result = await source.isQuizExist(1234);

      expect(result.$1, "quiz123");
      expect(result.$2, true);
      expect(result.$3, snapshot);
    });

    test('throws QuizDoesntExist when no results', () async {
      when(() => snapshot.docs).thenReturn([]);
      when(() => query.get()).thenAnswer((_) async => snapshot);

      expect(
        () => source.isQuizExist(1111),
        throwsA(isA<QuizDoesntExist>()),
      );
    });

    test('throws NetworkException on Firebase unavailable', () async {
      when(() => query.get()).thenThrow(
        FirebaseException(code: 'unavailable', plugin: ''),
      );

      expect(
        () => source.isQuizExist(2222),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws OtherFirebaseException on permission denied', () async {
      when(() => query.get()).thenThrow(
        FirebaseException(code: 'permission-denied', plugin: ''),
      );

      expect(
        () => source.isQuizExist(3333),
        throwsA(isA<OtherFirebaseException>()),
      );
    });

    test('throws UnknownException on unexpected exceptions', () async {
      when(() => query.get()).thenThrow(Exception("weird error"));

      expect(
        () => source.isQuizExist(4444),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}