import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/change_password_screen.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('change password screen test', () {
    testWidgets('ChangePasswordScreen displays email field and button',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Zmień hasło'), findsOneWidget);
    });
    testWidgets('Typing email triggers cubit.emailChanged', (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@mail.com');
      verify(() => mockCubit.emailChanged('test@mail.com')).called(1);
    });
    testWidgets('Pressing "Zmień hasło" calls cubit.changePassword',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(() => mockCubit.changePassword()).thenAnswer((_) async {});
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Zmień hasło'));
      await tester.pump();

      verify(() => mockCubit.changePassword()).called(1);
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
            child: const ChangePasswordScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('PasswordChanged shows snackbar and navigates to LoginScreen',
        (tester) async {
      final mockCubit = MockAuthCubit();

      whenListen(
        mockCubit,
        Stream.fromIterable([PasswordChanged()]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const ChangePasswordScreen(),
            ),
          ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('E-mail z linkiem do resetowania hasła'),
          findsOneWidget);
    });
    testWidgets('AuthFailure shows snackbar with error', (tester) async {
      final mockCubit = MockAuthCubit();

      whenListen(
        mockCubit,
        Stream.fromIterable([AuthFailure('Błąd resetu')]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockCubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Błąd resetu'), findsOneWidget);
    });
    testWidgets('Back button clears fields and navigates to MenuAuth',
        (tester) async {
      final mockCubit = MockAuthCubit();
      when(() => mockCubit.state).thenReturn(AuthInitial());
      when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: const ChangePasswordScreen(),
            ),
          ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      verify(() => mockCubit.clearFields()).called(1);
    });
  });
}
