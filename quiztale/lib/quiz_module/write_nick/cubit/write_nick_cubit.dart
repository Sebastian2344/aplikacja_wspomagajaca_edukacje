import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';

part 'write_nick_state.dart';

class WriteNickCubit extends Cubit<WriteNickState> {
  WriteNickCubit() : super(WriteNickInitial());

  void submitNickname(String userNickname) {
    userNickname = userNickname.trim();
    if (userNickname.length < 3 || userNickname.length > 12) {
      emit(WriteNickError(UnknownException(error: 'Zła długość nazwy użytkownika')));
      return;
    }
    final validCharacters = RegExp(r'^[a-zA-Z0-9ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+$').hasMatch(userNickname);
    if (validCharacters) {
      emit(WriteNickSuccess(userNickname));
    } else {
      emit(WriteNickError(UnknownException(
          error:
              'Niepoprawna nazwa użytkownika. Możesz tylko wpisywać litery i cyfry.')));
    }
  }

  void nicknameChanged(String nickname) {
    emit(WriteNickChanges(nickname));
  }
}
