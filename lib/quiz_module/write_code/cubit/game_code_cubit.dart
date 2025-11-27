import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_repo.dart/gamecode_repo.dart';

import '../../commons/exceptions/exceptions.dart';

part 'game_code_state.dart';

class GameCodeCubit extends Cubit<GameCodeState> {
  GameCodeCubit(this._gameCodeRepo) : super(GameCodeInitial());
  final GameCodeRepo _gameCodeRepo;

  Future<void> submitGameCode(String gameCodeString) async {
    int gameCode = 0;
    gameCodeString = gameCodeString.trim();

    final validDigits = RegExp(r'^\d{6}$').hasMatch(gameCodeString);
    if (validDigits) {
      gameCode = int.parse(gameCodeString);
      final isQuizExist = await _gameCodeRepo.isQuizExist(gameCode);
      isQuizExist.fold((left) {
        emit(GameCodeError(left));
      }, (right) {
        emit(GameCodeSuccess(gameCode, right.$1, right.$3));
      },);
    } else {
      if (gameCodeString.length != 6) {
        emit(
          GameCodeError(
            UnknownException(error: 'Kod gry musi mieć 6 cyfr'),
          ),
        );
      } else {
        emit(
          GameCodeError(
            UnknownException(
                error: 'Niepoprawny kod. Możesz tylko wpisywać cyfry.'),
          ),
        );
      }
    }
  }

  void gameCodeChanged(String gameCode) {
    emit(GameCodeChanges(gameCode));
  }
}
