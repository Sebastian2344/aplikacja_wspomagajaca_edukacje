import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String userId;
  final int gameCode;
  final String quizTitle;
  final String docID;
  QuizModel({
    required this.docID, 
    required this.userId,
    required this.gameCode,
    required this.quizTitle,
  });

  factory QuizModel.fromMap(DocumentSnapshot<Map<String,dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return QuizModel(
      docID: doc.id,
      userId: data['userId'],
      gameCode: data['gameCode'],
      quizTitle: data['quizTitle'],
    );
  }

   Map<String,dynamic> toMap(){
    return {
      'userId':userId,
      'gameCode':gameCode,
      'quizTitle':quizTitle
    };
  }
}