import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/screens/menu_create_or_edit.dart';

class MockCreateOrEditQuizCubit extends Mock implements CreateOrEditQuizCubit {}

void main() {
  late MockCreateOrEditQuizCubit mockCubit;
  late MockFirebaseAuth auth;

  setUp(() {
    auth = MockFirebaseAuth(
      mockUser: MockUser(uid: "user123"),
      signedIn: true,
    );

    mockCubit = MockCreateOrEditQuizCubit();

    when(() => mockCubit.state).thenReturn(const CreateQuizInitial());
    when(() => mockCubit.stream).thenAnswer((e)=> const Stream.empty());
    when(() => mockCubit.quizModelList).thenReturn([]);

    // Zwracanie userId z mocka
    when(() => mockCubit.getUserId()).thenReturn("user123");
    when(() => mockCubit.close()).thenAnswer((_) async => {});
  });

  tearDown( () {
    auth.signOut();
    mockCubit.close();
  });

  testWidgets("CreateOrEdit renders UI correctly", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateOrEdit(createOrEditQuizCubit: mockCubit),
      ),
    );

    expect(find.text("Moduł tworzenia quizu"), findsOneWidget);
    expect(find.text("Stwórz quiz"), findsOneWidget);
    expect(find.text("Edytuj lub zarządzaj quizem"), findsOneWidget);
    expect(find.text("Wyjście"), findsOneWidget);
  });

  testWidgets("Clicking 'Stwórz quiz' triggers getUserId()",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateOrEdit(createOrEditQuizCubit: mockCubit),
      ),
    );

    await tester.tap(find.text("Stwórz quiz"));
    await tester.pumpAndSettle();

    verify(() => mockCubit.getUserId()).called(1);
  });

  testWidgets(
      "Clicking 'Edytuj lub zarządzaj quizem' triggers downloadListQuiz() when list is empty",
      (WidgetTester tester) async {
    // quizModelList = []
    when(() => mockCubit.quizModelList).thenReturn([]);

    when(() => mockCubit.downloadListQuiz()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: CreateOrEdit(createOrEditQuizCubit: mockCubit),
      ),
    );

    await tester.tap(find.text("Edytuj lub zarządzaj quizem"));
    await tester.pump();

    verify(() => mockCubit.downloadListQuiz()).called(1);
  });
}
