import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/quiz_module/write_nick/cubit/write_nick_cubit.dart';

import '../../quiz_game/presentation/screens/quiz_screen.dart';

class NicknameScreen extends StatelessWidget {
  const NicknameScreen(
      {super.key, required this.gameCode, required this.quizId, required this.quizOwnerId, this.cubit});
  final int gameCode;
  final String quizId;
  final String quizOwnerId;
  final WriteNickCubit? cubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit ?? WriteNickCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ustawiane nazwy gracza', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: BlocConsumer<WriteNickCubit, WriteNickState>(
          listener: (context, state) {
            if (state is WriteNickSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => QuizScreen(
                        quizOwnerId: quizOwnerId,
                        gameCode: gameCode,
                        quizId: quizId,
                        nickname: state.nickname)),
              );
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.purple.shade100],
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      child: TextField(
                        onChanged:
                            context.read<WriteNickCubit>().nicknameChanged,
                        decoration: InputDecoration(
                           filled: true,
                        fillColor: Colors.purple.shade100,
                          errorText: state is WriteNickError
                              ? state.error.error
                              : null,
                          labelText: 'Nazwa gracza',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                         fixedSize: Size(
                          MediaQuery.of(context).size.width / 3 * 2,
                          MediaQuery.of(context).size.height / 9),
                        backgroundColor: state is WriteNickChanges
                            ? Colors.purple
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        state is WriteNickChanges
                            ? context
                                .read<WriteNickCubit>()
                                .submitNickname(state.nickname)
                            : null;
                      },
                      child: Text(
                        'Ustaw nazwę garcza',
                        style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
