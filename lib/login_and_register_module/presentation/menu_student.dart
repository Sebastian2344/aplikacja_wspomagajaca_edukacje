import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../game_module/quiz_choice.dart';
import '../../quiz_module/write_code/presentation/write_code.dart';
import '../cubit/auth_cubit.dart';
import 'menu_auth.dart';

class MenuStudent extends StatelessWidget {
  const MenuStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu ucznia'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: width * 0.05,color:Colors.white,fontWeight: FontWeight.bold),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(context, null, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GameCodeScreen(),
                    ),
                  );
                }, 'Moduł quizu', Colors.orangeAccent),
                _button(context,() async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QuizChoice(),
                    ),
                  );
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                } ,null , 'Moduł gry przygodowej', Colors.lightGreen),
                _button(context, () async {
                  await context.read<AuthCubit>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MenuAuth(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                }, null, 'Wyloguj się', Colors.redAccent)
              ],
            ),
          ),
        ),
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
        fixedSize: Size(MediaQuery.of(context).size.width / 3 *  2, MediaQuery.of(context).size.height / 7),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05),
      ),
    );
  }
}
