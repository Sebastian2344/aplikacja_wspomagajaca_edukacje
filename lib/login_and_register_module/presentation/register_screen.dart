import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';
import 'menu_auth.dart';
import 'menu_teacher.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja',),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: width * 0.05,color:Colors.white, fontWeight: FontWeight.bold),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
              content: Text("Zarejestrowano pomyślnie",
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
                  colors: [Colors.teal.shade200, Colors.white],
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
                        fillColor: Colors.teal.shade50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: width * 0.9, 
                    child: TextField(
                      onChanged: (value) => authCubit.passwordChanged(value),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Hasło',
                        errorText: state is AuthFieldsChanged
                            ? state.password.isNotValid &&
                                    !state.password.isPure
                                ? "Hasło ma mieć: wielką literę, znak specjalny, liczbę i minimum 6 znaków."
                                : null
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.teal.shade50, // Tło pola
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width * 0.9, 
                    child: ElevatedButton(
                      onPressed: () async {
                        await authCubit.register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, 
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Zarejestruj się',
                        style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      authCubit.clearFields();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      'Masz już konto? Zaloguj się!',
                      style: TextStyle(fontSize: width * 0.04, color: Colors.teal),
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
