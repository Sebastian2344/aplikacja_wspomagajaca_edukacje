import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/presentation/login_screen.dart';
import 'package:quiztale/login_and_register_module/presentation/menu_auth.dart';
import 'package:quiztale/login_and_register_module/presentation/register_screen.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
//class FakeAuthState extends Fake implements AuthState {}
class FakeUser extends Mock implements User {}

void main() {
  late final FakeUser fakeUser;
  setUp((){
    fakeUser = FakeUser();
  });
  
  testWidgets('MenuAuth displays all buttons', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const MenuAuth(),
        ),
      ),
    );

    expect(find.text('QUIZTALE'), findsOneWidget);
    expect(find.text('Zarejestruj się jako nauczyciel'), findsOneWidget);
    expect(find.text('Zaloguj się jako nauczyciel'), findsOneWidget);
    expect(find.text('Zaloguj się jako uczeń'), findsOneWidget);
    expect(find.text('Wyjście'), findsOneWidget);
  });
  testWidgets('Click register navigates to RegisterScreen', (tester) async {
    final mockCubit = MockAuthCubit();

    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const MenuAuth(), 
        ),
      ),
    );

    await tester.tap(find.text('Zarejestruj się jako nauczyciel'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });
  testWidgets('Click login navigates to LoginScreen', (tester) async {
    final mockCubit = MockAuthCubit();
    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const MenuAuth(),
          ),
        ),
    );

    await tester.tap(find.text('Zaloguj się jako nauczyciel'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
  testWidgets('Click login anonymous calls cubit.loginAnonymous',
      (tester) async {
    final mockCubit = MockAuthCubit();
    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(() => mockCubit.loginAnonymous()).thenAnswer((_) async {});
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: const MenuAuth(),
        ),
      ),
    );

    await tester.tap(find.text('Zaloguj się jako uczeń'));
    await tester.pump();

    verify(() => mockCubit.loginAnonymous()).called(1);
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
          child: const MenuAuth(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('AuthSuccess shows snackbar and navigates', (tester) async {
    final mockCubit = MockAuthCubit();

    whenListen(
      mockCubit,
      Stream.fromIterable([AuthSuccess(fakeUser)]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const MenuAuth(),
          ),
        ),
    );

    await tester.pump(); // trigger listener
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
          child: const MenuAuth(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Błąd logowania'), findsOneWidget);
  });
  testWidgets('Click exit button pops navigation', (tester) async {
    final mockCubit = MockAuthCubit();
    when(() => mockCubit.state).thenReturn(AuthInitial());
    when(()=> mockCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const MenuAuth(),
          ),)
    );

    await tester.tap(find.text('Wyjście'));
    await tester.pumpAndSettle();
    
    expect(find.byType(MenuAuth), findsNothing);
  });
}
