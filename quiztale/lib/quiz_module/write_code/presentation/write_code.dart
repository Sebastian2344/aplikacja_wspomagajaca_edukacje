import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/quiz_module/write_code/cubit/game_code_cubit.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_repo.dart/gamecode_repo.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_source.dart/gamecode_source.dart';

import '../../write_nick/presentation/write_nick.dart';

class GameCodeScreen extends StatelessWidget {
  const GameCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCodeCubit(
          GameCodeRepo(GameCodeSource(FirebaseFirestore.instance))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wpisynanie kodu gry',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange.shade600,
          centerTitle: true,
        ),
        body: BlocConsumer<GameCodeCubit, GameCodeState>(
          listener: (mycontext, state) {
            if (state is GameCodeSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NicknameScreen(
                    quizOwnerId: state.userId,
                      gameCode: state.gameCode, quizId: state.quizId),
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade100],
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3 * 2,
                    child: TextField(
                      onChanged:
                          context.read<GameCodeCubit>().gameCodeChanged,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.orange.shade100,
                        errorText:
                            state is GameCodeError ? state.error.error : null,
                        labelText: 'Kod gry',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                          MediaQuery.of(context).size.width / 3 * 2,
                          MediaQuery.of(context).size.height / 9),
                      backgroundColor: state is GameCodeChanges
                          ? Colors.orange
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      state is GameCodeChanges
                          ? context
                              .read<GameCodeCubit>()
                              .submitGameCode(state.gameCode)
                          : null;
                    },
                    child: Text(
                      'Wyślij kod gry',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
