import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/data_source/question_game_source.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/model/question_model_game.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/repository/question_game_repo.dart';
class MockQuestionGameSource extends Mock implements QuestionGameSource {}
void main(){
  late final QuestionGameRepo questionGameRepo;
  late final MockQuestionGameSource mockQuestionGameSource;
  setUp((){
    mockQuestionGameSource = MockQuestionGameSource();
    questionGameRepo = QuestionGameRepo(mockQuestionGameSource);
  });
  test('questionsFromJSON() returns List<QuestionModelGame>', () async {
    final sampleJsonData = {
        "sample_source": [
          {
            "pytanie": "Sample Question?",
            "odpowiedzi": ["A", "B", "C", "D"],
            "poprawna_odpowiedź": "A",
            "kategoria": "Sample Category"
          }
        ]
    };
    when(() => mockQuestionGameSource.questionsFromJSON(any()))
        .thenAnswer((_) async => sampleJsonData);
    final result = await questionGameRepo.questionsFromJSON('sample_source');
    expect(result, isA<List<QuestionModelGame>>());
    expect(result.length, 1);
    expect(result.first.question, 'Sample Question?');
    expect(result.first.answers, containsAll(['A', 'B', 'C', 'D']));
    expect(result.first.correctAnswer, 'A');
    expect(result.first.category, 'Sample Category');
    
  });
}