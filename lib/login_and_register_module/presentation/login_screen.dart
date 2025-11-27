import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/login_and_register_module/presentation/menu_auth.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'change_password_screen.dart';
import 'menu_teacher.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie',),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: width * 0.05,color:Colors.white, fontWeight: FontWeight.bold),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade700,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            authCubit.clearFields();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MenuAuth()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Zalogowano pomyślnie",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MenuTeacher()));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.9,
                    child: TextField(
                      onChanged: (value) => authCubit.emailChanged(value),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: state is AuthFieldsChanged
                            ? state.email.isNotValid && !state.email.isPure
                                ? "Wpisz poprawny email!"
                                : null
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: width * 0.9,
                    child: TextField(
                      onChanged: (value) =>
                          authCubit.passwordChanged(value),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Hasło',
                        errorText: state is AuthFieldsChanged
                            ? state.password.isNotValid &&
                                    !state.password.isPure
                                ? """Hasło ma mieć: wielką literę, znak specjalny, liczbę i minimum 6 znaków."""
                                : null
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width * 0.9,
                    child: ElevatedButton(
                      onPressed: () async {
                        await authCubit.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Zaloguj się',
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      authCubit.clearFields();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen()));
                    },
                    child: Text(
                      'Nie masz konta? Zarejestruj się!',
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.deepPurple),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      authCubit.clearFields();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()));
                    },
                    child: Text(
                      'Nie pamiętasz hasła? Zmień je podając email!',
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
