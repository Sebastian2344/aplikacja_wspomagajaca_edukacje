import 'package:dartz/dartz.dart';

import '../../../commons/exceptions/exceptions.dart';
import '../data_source/create_or_edit_quiz_data.dart';
import '../../../commons/models/question_model.dart';
import '../../../commons/models/quiz_config_model.dart';
import '../../../commons/models/quiz_model.dart';

class CreateOrEditQuizRepo {
  const CreateOrEditQuizRepo(this._createQuizData);
  final CreateOrEditQuizData _createQuizData;
  
  Future<Either<Exceptions,String>> createQuiz(QuizModel quiz,List<QuestionModel> questions,QuizConfigModel settings)async{
    try {
      final Map<String,dynamic> mapSettings = settings.toMap();
      final List<Map<String,dynamic>> mapQuestions = questions.map((e)=>e.toMap()).toList();
      final Map<String,dynamic> mapQuiz = quiz.toMap();
      final id = await _createQuizData.createQuiz(mapQuiz, mapQuestions, mapSettings);
      return Right(id);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<Exceptions,void>> editQuiz(String id,QuizModel quiz,List<QuestionModel> questionsToDB,List<QuestionModel> downloadedQuestion)async{
    try {  
      final List<Map<String,dynamic>> mapQuestionsToDB = questionsToDB.map((e)=>e.toMap()).toList();
      final List<Map<String,dynamic>> mapDownloadedQuestion = downloadedQuestion.map((e)=>e.toMap()).toList();
      final Map<String,dynamic> mapQuiz = quiz.toMap();
      return Right(await _createQuizData.editQuiz(mapQuiz, mapQuestionsToDB, id, mapDownloadedQuestion));
    } catch (e) {
      return Left(_returnException(e));
    } 
  }

  Future<Either<Exceptions,List<QuizModel>>> downloadListQuizToSelect()async{
    try {
      final listMap = await _createQuizData.downloadListQuizToSelect();
      final listQuizModel = listMap.docs.map((e)=> QuizModel.fromMap(e)).toList();
      return Right(listQuizModel);
    } catch (e) {
      return Left(_returnException(e));
    }  
  }

  Future<Either<Exceptions,List<QuestionModel>>> downloadQuestions(String id)async{
    try {
     final listMap = await _createQuizData.downloadQuestions(id);
     final listQuestionModel = listMap.docs.map((e) => QuestionModel.fromMap(e),).toList();
     return Right(listQuestionModel);
    } catch (e) {
      return Left(_returnException(e));
    }  
  }  

  Future<Either<Exceptions,bool>> gameCodeCheck(int code)async{
    try {
      final isNotExist = await _createQuizData.gameCodeCheck(code);
      return Right(isNotExist);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  String getUserId(){
    return _createQuizData.getUserId();
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