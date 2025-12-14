import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/data_source/question_game_source.dart';

void main(){
  test('questionsFromJSON returns future<map<string,dynamic>>', () {
    QuestionGameSource questionGameSource = QuestionGameSource();
    expect(questionGameSource.questionsFromJSON('klasa_1'), isA<Future<Map<String, dynamic>>>());
  });
}