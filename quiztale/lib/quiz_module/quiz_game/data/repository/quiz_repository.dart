import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../commons/exceptions/exceptions.dart';
import '../data_source/quiz_source.dart';
import '../../../commons/model/question_model.dart';
import '../../../commons/model/settings_model.dart';
import '../../../commons/model/solved_quiz_model.dart';

class QuizRepository {
  QuizRepository(this.quizDataSource);
  final QuizSource quizDataSource;

  Future<Either<Exceptions, List<QuestionModel>>> getQuestions(
      String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> listQuestion =
          await quizDataSource.getQuestions(id);
      final List<QuestionModel> questions =
          listQuestion.docs.map((e) => QuestionModel.fromMap(e)).toList();
      return Right(questions);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<Exceptions, Stream<SettingsModel>>> getSettings(
      int gameCode) async {
    try {
      final Stream<DocumentSnapshot<Map<String, dynamic>>> settings =
          await quizDataSource.getSettings(gameCode);
      return Right(settings.map((doc) => SettingsModel.fromJson(doc)));
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<Exceptions, String>> putSolvedQuiz(
      int points, String nickname, String id, String userId) async {
    try {
      final docId = await quizDataSource
          .putSolvedQuiz({'quizOwnerUserId':userId,'nickname':nickname, 'result':points}, id);
      return Right(docId);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<Exceptions, List<SolvedQuizModel>>> getSolvedQuizies(
      String id) async {
    try {
      final solvedQuizies = await quizDataSource.getSolvedQuizies(id);
      final List<SolvedQuizModel> listSolvedQuizies = solvedQuizies.docs
          .map((e) => SolvedQuizModel.fromQueryDocumentSnapshot(e))
          .toList();
      return Right(listSolvedQuizies);
    } catch (e) {
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
