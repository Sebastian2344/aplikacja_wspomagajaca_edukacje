import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../create_or_edit_quiz_module/create_or_edit_quiz/presentation/screens/menu_create_or_edit.dart';
import '../../game_module/quiz_choice.dart';
import '../../quiz_module/write_code/presentation/write_code.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'menu_auth.dart';

class MenuTeacher extends StatelessWidget {
  const MenuTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu nauczyciela'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        titleTextStyle: TextStyle(fontSize: width * 0.05,color: Colors.white, fontWeight: FontWeight.bold),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUserIsNotVerified) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.red,
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 20),
                    contentTextStyle: const TextStyle(color: Colors.white),
                    title: const Text('Weryfikacja użytkownika'),
                    content: const Text(
                        "Nie jestem zweryfikowany. Administrator bazy udziela weryfikacji."),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          child: const Text('OK'))
                    ],
                  );
                });
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red, content: Text(state.error,style: TextStyle(color: Colors.white),)));
          } else if (state is AuthUserIsVerified) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Jestem zweryfikowany mogę przejść do modułu tworzenia quizu.',style: TextStyle(color: Colors.white)
                )));
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _button(context, () async {
                      if (state is AuthUserIsVerified) {
                        context.mounted && state.isVerified
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CreateOrEdit(),
                                ),
                              )
                            : null;
                      } else {
                        await context.read<AuthCubit>().userIsVerified();
                      }
                    }, null, 'Moduł tworzenia quizu', Colors.teal),
                    _button(context, null, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GameCodeScreen(),
                        ),
                      );
                    }, 'Moduł quizu', Colors.green.shade600),
                    _button(context, null, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuizChoice(),
                        ),
                      );
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ]);
                    }, 'Moduł gry przygodowej', Colors.orangeAccent),
                    _button(context, () async {
                      await context.read<AuthCubit>().logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MenuAuth()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }, null, 'Wyloguj się', Colors.redAccent),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _button(BuildContext context, AsyncCallback? onPressedAsync,
      VoidCallback? onPressed, String buttonText, Color backgroundColor) {
    return ElevatedButton(
      onPressed: () async {
        if (onPressedAsync != null) {
          await onPressedAsync();
        } else if (onPressed != null) {
          onPressed();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        fixedSize:Size(MediaQuery.of(context).size.width / 3 * 2,  MediaQuery.of(context).size.height / 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          )),
    );
  }
}
