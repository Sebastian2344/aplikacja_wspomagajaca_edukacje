import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';
import 'menu_auth.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resetowanie hasła'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(fontSize: width * 0.05,color:Colors.white,fontWeight: FontWeight.bold),
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
          if (state is PasswordChanged) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
      
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'E-mail z linkiem do resetowania hasła został wysłany! Teraz po resecie hasła możesz się zalogować.')),
            );
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
            return Center(child: const CircularProgressIndicator());
          } else {
            return Container(
              width: width,
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  SizedBox(
                    width: width / 3 * 2, 
                    child: TextField(
                      onChanged: (value) => authCubit.emailChanged(value),
                      decoration: InputDecoration(
                        fillColor: Colors.blue.shade100,
                        filled: true,
                        labelText: 'Email',
                        errorText: state is AuthFieldsChanged
                            ? state.email.isNotValid && !state.email.isPure
                                ? "Wpisz poprawny emial!"
                                : null
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 2 / 3,
                    child: ElevatedButton(
                      onPressed: authCubit.changePassword,
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: width * 0.05),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Zmień hasło'),
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
