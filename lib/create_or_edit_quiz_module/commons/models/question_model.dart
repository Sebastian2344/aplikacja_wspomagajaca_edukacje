import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String userId;
  final String question;
  final List<String> answers;
  final String correctAnswer;
  final int points;
  final int timeLimit;
  final String urlImage;
  QuestionModel({
    required this.userId,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.points,
    required this.timeLimit,
    required this.urlImage,
  });

  factory QuestionModel.fromMap(DocumentSnapshot<Map<String,dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return QuestionModel(
      userId: data['userId'],
      question: data['question'],
      answers: List<String>.from(data['answers']),
      correctAnswer: data['correctAnswer'],
      points: data['points'],
      timeLimit: data['timeLimit'],
      urlImage: data['urlImage'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'userId':userId,
      'question':question,
      'answers':answers,
      'correctAnswer':correctAnswer,
      'points':points,
      'timeLimit':timeLimit,
      'urlImage':urlImage,
    };
  }
}