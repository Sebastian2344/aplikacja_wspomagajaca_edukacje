import 'package:dartz/dartz.dart';

import '../../../commons/exceptions/exceptions.dart';
import '../data_source/menage_quiz_while_play_data.dart';
import '../../../commons/models/quiz_config_model.dart';

class MenageQuizWhilePlayRepo {
  MenageQuizWhilePlayRepo(this._menageQuizWhilePlayData);
  final MenageQuizWhilePlayData _menageQuizWhilePlayData;

  Future<Either<Exceptions,void>> setSettings(String docId,QuizConfigModel settings)async{
    try {
      final mapSettings = settings.toMap();
      return Right(await _menageQuizWhilePlayData.setSettings(mapSettings, docId));
    } catch (e) {
      return Left(_returnException(e));
    }    
  }

  Future<Either<Exceptions,QuizConfigModel>> downloadQuizConfig(int gameCode)async{
    try {
      final mapConfig = await _menageQuizWhilePlayData.downloadQuizConfig(gameCode);
      final modelConfig = QuizConfigModel.fromJson(mapConfig.docs.first);
      return Right(modelConfig);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<Exceptions,void>> deleteStats(String quizId) async {
    try {
      return Right(await _menageQuizWhilePlayData.deleteStats(quizId));
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Exceptions _returnException(Object e){
    if(e is NetworkException){
        return e;
      }else if(e is OtherFirebaseException){
        return e;
      }else{
        return UnknownException(error: e.toString());
      }
  }
}