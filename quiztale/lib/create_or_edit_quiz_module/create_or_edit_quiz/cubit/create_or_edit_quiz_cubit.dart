import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../commons/models/question_model.dart';
import '../../commons/models/quiz_config_model.dart';
import '../../commons/models/quiz_model.dart';
import '../data/repository/create_or_edit_quiz_repo.dart';
import '../../commons/exceptions/exceptions.dart';

part 'create_or_edit_quiz_state.dart';

class CreateOrEditQuizCubit extends Cubit<CreateOrEditQuizState> {
  CreateOrEditQuizCubit(this._createQuizRepo) : super(const CreateQuizInitial());
  final CreateOrEditQuizRepo _createQuizRepo;
  List<QuizModel> _quizModelList = [];
  List<QuizModel> get quizModelList => _quizModelList;
  
  Future<void> saveInDatabaseCreatedQuiz(int gameCode, String quizTitle,
       List<QuestionModel> questions) async {
        final userId = _createQuizRepo.getUserId();
    final QuizConfigModel settings = QuizConfigModel(
        docId: '',
        userId: userId,
        nextQuestion: false,
        pause: false,
        start: false,
        end: false,
        gameCode: gameCode);

    final quiz = QuizModel(docID: '',
        userId: userId, gameCode: gameCode, quizTitle: quizTitle);

    final createQuizResult =
        await _createQuizRepo.createQuiz(quiz, questions, settings);
    createQuizResult.fold((left) => emit(CreateQuizError(left)), (right) {
     emit(const SuccessCreate('Quiz został poprawnie umieszczony w bazie.'));
    _quizModelList.add(QuizModel(docID: right, userId: userId, gameCode: gameCode, quizTitle: quizTitle)); 
    },);
  }

  Future<void> saveInDatabaseEditedQuiz(
      String id,
      QuizModel quiz,
      List<QuestionModel> questionsToDB,
      List<QuestionModel> downloadedQuestion) async {
    final editQuizResult = await _createQuizRepo.editQuiz(
        id, quiz, questionsToDB, downloadedQuestion);

    editQuizResult.fold((left) => emit(CreateQuizError(left)), (right) {
      emit(const SuccessEdit('Edycja quizu powiodła się.'));
      for(int i = 0; i<_quizModelList.length; i++) {
        if(_quizModelList[i].docID == id) {
          _quizModelList[i] = quiz;
        }
      }
    }); 
  }

  Future<void> downloadListQuiz() async {
    final quizList = await _createQuizRepo.downloadListQuizToSelect();
    quizList.fold((left) => emit(CreateQuizError(left)), (right) { _quizModelList = right; emit(DownloadedListQuizies(right));} );
  }

  Future<void> selectQuizToEdit(QuizModel quiz) async {
    final selectedQuiz = await _createQuizRepo.downloadQuestions(quiz.docID);
    selectedQuiz.fold((left) => emit(CreateQuizError(left)), (right) => emit(DownloadedSelectedQuiz(right,quiz)));
  }

  void backToSelectedState(List<QuestionModel> questions,QuizModel quiz){
    emit(DownloadedSelectedQuiz(questions,quiz));
  }

  void returnToQuizList(){
    emit(DownloadedListQuizies(_quizModelList));
  }

  Future<int> generateGameCode()async{
    bool isNotExist = false;
    int code = 100000;
    do {
      code = Random().nextInt(899999) + 100000;
      final x = await _createQuizRepo.gameCodeCheck(code);
      x.fold((left){
        emit(CreateQuizError(left));
      },(right){
        isNotExist = right;
      });
      
      if(isNotExist){break;}
    } while (isNotExist == false);
    return code;
  }

  String getUserId(){
    return _createQuizRepo.getUserId();
  }

  void backToInitial(){
    emit(const CreateQuizInitial());
  }
}
