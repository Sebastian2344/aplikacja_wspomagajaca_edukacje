import 'package:dartz/dartz.dart';
import 'package:quiztale/quiz_module/commons/model/quiz_model.dart';

import '../../../commons/exceptions/exceptions.dart';
import '../gamecode_source.dart/gamecode_source.dart';

class GameCodeRepo {
  GameCodeRepo(this._gameCodeSource);
  final GameCodeSource _gameCodeSource;

  Future<Either<Exceptions,(String,bool,String)>> isQuizExist (int gameCode) async {
    try{
      final response = await _gameCodeSource.isQuizExist(gameCode);
      final quiz = QuizModel.fromMap(response.$3.docs.first);
      return Right((response.$1,response.$2,quiz.userId));
    }catch(e){
      return Left(_returnException(e));
    }
  }

  Exceptions _returnException(Object e) {
    if (e is NetworkException) {
      return e;
    } else if (e is QuizDoesntExist) {
      return e;
    } else if (e is OtherFirebaseException) {
      return e;
    } else {
      return UnknownException(error: e.toString());
    }
  }
}