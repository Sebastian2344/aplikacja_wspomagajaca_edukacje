import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/login_screen.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

class FakeUser extends Fake implements User {}

void main() {
  late final FakeUser mockUser;

  setUpAll(() {
   mockUser = FakeUser();
  });
  group('tests login screen', () {
    testWidgets('LoginScreen displays all inputs and buttons', (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.text('Logowanie'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Zaloguj się'), findsOneWidget);
      expect(find.text('Nie masz konta? Zarejestruj się!'), findsOneWidget);
      expect(find.text('Nie pamiętasz hasła? Zmień je podając email!'),
          findsOneWidget);
    });
    testWidgets('Typing email/password triggers cubit methods', (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'test@mail.com');
      verify(() => mockCubit.emailChanged('test@mail.com')).called(1);

      await tester.enterText(
          find.widgetWithText(TextField, 'Hasło'), 'Password1!');
      verify(() => mockCubit.passwordChanged('Password1!')).called(1);
    });
    testWidgets('Pressing login button calls cubit.login()', (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.login()).thenAnswer((_) async {});
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Zaloguj się'));
      await tester.pump();

      verify(() => mockCubit.login()).called(1);
    });
    testWidgets('Shows CircularProgressIndicator when AuthLoading',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthLoading());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('AuthSuccess shows snackbar and navigates to MenuTeacher',
        (tester) async {
      final mockCubit = MockAuthCubit();

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthSuccess(mockUser)]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const LoginScreen(),
            ),
          ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Zalogowano pomyślnie'), findsOneWidget);
    });
    testWidgets('AuthFailure shows snackbar with error', (tester) async {
      final mockCubit = MockAuthCubit();

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthFailure('Błąd logowania')]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Błąd logowania'), findsOneWidget);
    });
    testWidgets('Back button clears fields and navigates to MenuAuth',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const LoginScreen(),
            ),
          ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      verify(() => mockCubit.clearFields()).called(1);
    });
    testWidgets(
        'Click "Nie masz konta?" clears fields and navigates to RegisterScreen',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Nie masz konta? Zarejestruj się!'));
      await tester.pumpAndSettle();

      verify(() => mockCubit.clearFields()).called(1);
    });
    testWidgets(
        'Click "Nie pamiętasz hasła?" clears fields and navigates to ChangePasswordScreen',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      await tester
          .tap(find.text('Nie pamiętasz hasła? Zmień je podając email!'));
      await tester.pumpAndSettle();

      verify(() => mockCubit.clearFields()).called(1);
    });
  });
}
