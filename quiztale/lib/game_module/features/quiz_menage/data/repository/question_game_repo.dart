import '../data_source/question_game_source.dart';
import '../model/question_model_game.dart';
import '../model/quiz_model_game.dart';

class QuestionGameRepo {
  QuestionGameRepo(this._questionGameSource);
  final QuestionGameSource _questionGameSource;
  
  Future<List<QuestionModelGame>> questionsFromJSON(String source)async{
     final jsonData = await _questionGameSource.questionsFromJSON(source);
    return QuizModelGame.fromJson(jsonData,jsonData.keys.first).questionModelGame;
  }
}