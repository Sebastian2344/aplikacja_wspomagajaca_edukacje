import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/login_and_register_module/data/data_source/auth_source.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockCollectionRef extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentRef extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockUser extends Mock implements User {}

void main() {
  late final MockFirebaseAuth mockFirebaseAuth;
  late final MockFirebaseFirestore mockFirebaseFirestore;
  late final MockUserCredential mockUserCredential;
  late final FirebaseAuthDataSource authSource;
  late MockCollectionRef mockCollection;
  late MockDocumentRef mockDoc;
  late MockDocumentSnapshot mockSnapshot;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    authSource =
        FirebaseAuthDataSource(mockFirebaseAuth, mockFirebaseFirestore);
        mockCollection = MockCollectionRef();
    mockDoc = MockDocumentRef();
    mockSnapshot = MockDocumentSnapshot();
    mockUser = MockUser();

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn("123");
  });

  group('success', () {
    test('login success', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'j@gmail.com', password: '123456'),
      ).thenAnswer((_) async => mockUserCredential);
      await authSource.login('j@gmail.com', '123456');
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'j@gmail.com', password: '123456'),
      ).called(1);
    });

    test('register success', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email@g.com', password: '123456'),
      ).thenAnswer((_) async => mockUserCredential);
      final a = await authSource.register('email@g.com', '123456');
      expect(a, isA<User?>());
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email@g.com', password: '123456'),
      ).called(1);
    });

    test('changePassword succes', () async {
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: "x"),
      ).thenAnswer((_) async {});
      await authSource.changePassword('x');
      verify(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: "x"),
      ).called(1);
    });

    test('signInAnonymously succes', () async {
      when(
        () => mockFirebaseAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockUserCredential);
      await authSource.loginAnonymous();
      verify(
        () => mockFirebaseAuth.signInAnonymously(),
      ).called(1);
    });

    test('signOut succes', () async {
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenAnswer((_) async => {});
      await authSource.logout();
      verify(
        () => mockFirebaseAuth.signOut(),
      ).called(1);
    });
  });

  group('firebase error', () {
    test('login powinno przepuścić FirebaseAuthException', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      expect(
        () => authSource.login('email@test.com', 'pass'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('register firebase error', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')),
      ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authSource.register('email', 'password'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('changePassword firebase error', () async {
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: 'email'),
      ).thenThrow(FirebaseAuthException(code: 'invalid-email'));
      expect(
        () => authSource.changePassword('email'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('signInAnonymously firebase error', () async {
      when(
        () => mockFirebaseAuth.signInAnonymously(),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
     expect(
        () => authSource.loginAnonymous(),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('signOut firebase error', () async {
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
       expect(
        () => authSource.logout(),
        throwsA(isA<Exception>()),
      );
    });
  });

  test('isVerifiedUser powinno zwrócić true, jeśli verified = true', () async {
    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.get())
        .thenAnswer((_) async => mockSnapshot);

    when(() => mockSnapshot.data())
        .thenReturn({'verified': true});

    final result = await authSource.isVerifiedUser();

    expect(result, true);
  });

  test('isVerifiedUser powinno rzucić FirebaseException gdy Firestore rzuci błąd', () async {
    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.get())
        .thenThrow(FirebaseException(plugin: 'firestore'));

    expect(
      () => authSource.isVerifiedUser(),
      throwsA(isA<FirebaseException>()),
    );
  });

  test('isVerifiedUser powinno opakować inne wyjątki w Exception', () async {
    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.get())
        .thenThrow(Exception("Inny błąd"));

    expect(
      () => authSource.isVerifiedUser(),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'zawiera komunikat',
        contains('Wystąpił nieznany błąd'),
      )),
    );
  });

  // --------------------------
  // TEST addUserToDB()
  // --------------------------

  test('addUserToDB powinno zapisać dane do Firestore', () async {
    final data = {'name': 'Test'};

    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.set(data))
        .thenAnswer((_) async => Future.value());

    await authSource.addUserToDB(mockUser, data);

    verify(() => mockDoc.set(data)).called(1);
  });

  test('addUserToDB powinno przepuścić FirebaseException', () async {
    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.set(any()))
        .thenThrow(FirebaseException(plugin: 'firestore'));

    expect(
      () => authSource.addUserToDB(mockUser, {'name': 'Test'}),
      throwsA(isA<FirebaseException>()),
    );
  });

  test('addUserToDB powinno opakować inne wyjątki w Exception', () async {
    when(() => mockFirebaseFirestore.collection('Users'))
        .thenReturn(mockCollection);

    when(() => mockCollection.doc("123"))
        .thenReturn(mockDoc);

    when(() => mockDoc.set(any()))
        .thenThrow(Exception("Inny błąd"));

    expect(
      () => authSource.addUserToDB(mockUser, {'name': 'Test'}),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'zawiera komunikat',
        contains('Wystąpił nieznany błąd'),
      )),
    );
  });
}
