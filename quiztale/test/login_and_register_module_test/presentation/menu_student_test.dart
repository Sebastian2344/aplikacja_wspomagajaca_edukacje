import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/game_module/quiz_choice.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/menu_auth.dart';
import 'package:quiztale/login_and_register_module/presentation/menu_student.dart';
import 'package:quiztale/quiz_module/write_code/presentation/write_code.dart';


// --- MOCK CUBIT ---
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());
  });

  Widget createTestWidget() {
    return BlocProvider<AuthCubit>.value(
      value: mockAuthCubit,
      child: MaterialApp(
        home:const MenuStudent(),
        ),
    );
  }

  testWidgets('Wyświetla wszystkie przyciski', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Moduł quizu'), findsOneWidget);
    expect(find.text('Moduł gry przygodowej'), findsOneWidget);
    expect(find.text('Wyloguj się'), findsOneWidget);
  });

  testWidgets('Kliknięcie Moduł quizu -> przejście do GameCodeScreen', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Moduł quizu'));
    await tester.pumpAndSettle();

    expect(find.byType(GameCodeScreen), findsOneWidget);
  });

  testWidgets('Kliknięcie Moduł gry przygodowej -> przejście do QuizChoice', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Moduł gry przygodowej'));
    await tester.pumpAndSettle();

    expect(find.byType(QuizChoice), findsOneWidget);
  });

  testWidgets('Kliknięcie Wyloguj się wywołuje logout i wraca do MenuAuth', (tester) async {
    when(() => mockAuthCubit.logout()).thenAnswer((_) async {});
    when(()=> mockAuthCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Wyloguj się'));
    await tester.pumpAndSettle();

    verify(() => mockAuthCubit.logout()).called(1);

    expect(find.byType(MenuAuth), findsOneWidget);
  });
}
