import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/register_screen.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
class FakeUser extends Mock implements User {}

void main() {
  late final FakeUser user;
  setUpAll(() {
   user = FakeUser();
  });
  testWidgets('RegisterScreen displays inputs and button', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const RegisterScreen(),
        ),
      ),
    );

    expect(find.text('Rejestracja'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Zarejestruj się'), findsOneWidget);
    expect(find.text('Masz już konto? Zaloguj się!'), findsOneWidget);
  });

  testWidgets('Typing email/password triggers cubit methods', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const RegisterScreen(),
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

  testWidgets('Pressing register button calls cubit.register()',
      (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(() => mockCubit.register()).thenAnswer((_) async {});
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const RegisterScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Zarejestruj się'));
    await tester.pump();

    verify(() => mockCubit.register()).called(1);
  });

  testWidgets('Shows CircularProgressIndicator when AuthLoading',
      (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthLoading());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const RegisterScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AuthSuccess shows snackbar and navigates', (tester) async {
    final mockCubit = MockAuthCubit();

    whenListen(
      mockCubit,
      Stream.fromIterable([AuthSuccess(user)]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const RegisterScreen(),
          ),
        ),
    );

    await tester.pump(); // trigger listener
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Zarejestrowano pomyślnie'), findsOneWidget);
  });

  testWidgets('AuthFailure shows error snackbar', (tester) async {
    final mockCubit = MockAuthCubit();

    whenListen(
      mockCubit,
      Stream.fromIterable([AuthFailure('Błąd rejestracji')]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const RegisterScreen(),
        ),
      ),
    );

    await tester.pump(); // listener
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Błąd rejestracji'), findsOneWidget);
  });

  testWidgets('Back button clears fields and navigates', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home:const RegisterScreen(),
          ),
        ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    verify(() => mockCubit.clearFields()).called(1);
  });

  testWidgets('Go to login screen button clears fields', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const RegisterScreen(),
          ),
        ),
    );

    await tester.tap(find.text('Masz już konto? Zaloguj się!'));
    await tester.pumpAndSettle();

    verify(() => mockCubit.clearFields()).called(1);
  });
}
