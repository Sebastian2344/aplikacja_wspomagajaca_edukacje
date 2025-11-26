import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/game_module/quiz_choice.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/menu_teacher.dart';
import 'package:quiztale/quiz_module/write_code/presentation/write_code.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
class FakeUser extends Mock implements User {}

void main() {
  late final FakeUser fakeUser;
  late final MockAuthCubit mockCubit;

  setUpAll(() async {
    fakeUser = FakeUser();
    mockCubit = MockAuthCubit();
  },);

  group('menu teatcher screen tests', () {
    testWidgets('MenuTeacher displays all module buttons', (tester) async {
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const MenuTeacher(),
          ),
        ),
      );

      expect(find.text('Moduł tworzenia quizu'), findsOneWidget);
      expect(find.text('Moduł quizu'), findsOneWidget);
      expect(find.text('Moduł gry przygodowej'), findsOneWidget);
      expect(find.text('Wyloguj się'), findsOneWidget);
    });

    testWidgets(
        'Pressing create quiz button calls userIsVerified when not verified',
        (tester) async {
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.userIsVerified()).thenAnswer((_) async {});
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const MenuTeacher(),
          ),
        ),
      );

      await tester.tap(find.text('Moduł tworzenia quizu'));
      await tester.pump();

      verify(() => mockCubit.userIsVerified()).called(1);
    });

    testWidgets('AuthUserIsNotVerified shows AlertDialog', (tester) async {

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthUserIsNotVerified(false,fakeUser)]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const MenuTeacher(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Weryfikacja użytkownika'), findsOneWidget);

      // kliknięcie OK
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('AuthUserIsVerified shows green snackbar', (tester) async {

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthUserIsVerified(true,fakeUser)]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const MenuTeacher(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Jestem zweryfikowany'), findsOneWidget);
    });

    testWidgets('AuthFailure shows red snackbar', (tester) async {

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthFailure('Błąd')]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const MenuTeacher(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Błąd'), findsOneWidget);
    });

    testWidgets('Logout button calls cubit.logout and navigates to MenuAuth',
        (tester) async {
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.logout()).thenAnswer((_) async {});
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const MenuTeacher(),
            ),
          ),
      );

      await tester.tap(find.text('Wyloguj się'));
      await tester.pumpAndSettle();

      verify(() => mockCubit.logout()).called(1);
    });

    testWidgets('Other module buttons navigate correctly', (tester) async {
      when(() => mockCubit.state)
          .thenReturn(AuthUserIsVerified(true,fakeUser));
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());
      
      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const MenuTeacher(),
            ),
          ),
      );

      await tester.tap(find.text('Moduł quizu'));
      await tester.pumpAndSettle();
      expect(find.byType(GameCodeScreen), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Moduł gry przygodowej'));
      await tester.pumpAndSettle();
      expect(find.byType(QuizChoice), findsOneWidget);
    });
  });
}
