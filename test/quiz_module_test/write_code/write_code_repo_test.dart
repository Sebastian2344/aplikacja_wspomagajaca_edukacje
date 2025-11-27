import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_repo.dart/gamecode_repo.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_source.dart/gamecode_source.dart';
class MockGameCodeSource extends Mock implements GameCodeSource {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionRef extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}


class FakeQuerySnapshot extends Fake implements QuerySnapshot<Map<String, dynamic>> {
  FakeQuerySnapshot(this.docsList);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList;

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => docsList;
}

class FakeQueryDocumentSnapshot extends Fake implements QueryDocumentSnapshot<Map<String, dynamic>> {
  FakeQueryDocumentSnapshot(this._id, this._data);

  final String _id;
  final Map<String, dynamic> _data;

  @override
  String get id => _id;

  @override
  Map<String, dynamic> data() => _data;
}

void main(){
  late MockGameCodeSource source;
  late GameCodeRepo repo;
  setUp((){
    source = MockGameCodeSource();
    repo = GameCodeRepo(source);
  });
  test('returns Right when quiz exists', () async {
  final fakeDoc = FakeQueryDocumentSnapshot(
    'quiz123',
    {
      'userId': 'user123',
      'title': 'Quiz testowy',
    },
  );

  final fakeSnapshot = FakeQuerySnapshot([fakeDoc]);

  when(() => source.isQuizExist(1234))
      .thenAnswer((_) async => ('quiz123', true, fakeSnapshot));

  final result = await repo.isQuizExist(1234);

  expect(result.isRight(), true);

  final tuple = result.getOrElse(() => throw "err");

  expect(tuple.$1, 'quiz123');     // id
  expect(tuple.$2, true);          // isExist
  expect(tuple.$3, 'user123');     // userId from QuizModel
});

    test('returns Left(QuizDoesntExist) when source throws QuizDoesntExist', () async {
      when(() => source.isQuizExist(1111))
          .thenThrow(QuizDoesntExist(error: 'no quiz'));

      final result = await repo.isQuizExist(1111);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<QuizDoesntExist>());
    });

    test('returns Left(NetworkException) on network error', () async {
      when(() => source.isQuizExist(2222))
          .thenThrow(NetworkException(error: "net"));

      final result = await repo.isQuizExist(2222);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<NetworkException>());
    });

    test('returns Left(UnknownException) on unexpected error', () async {
      when(() => source.isQuizExist(3333))
          .thenThrow(Exception("weird"));

      final result = await repo.isQuizExist(3333);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<UnknownException>());
    });
}