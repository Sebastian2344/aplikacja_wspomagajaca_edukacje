// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String docId;
  final String question;
  final List<String> answers;
  final String correctAnswer;
  final int points;
  final int timeLimit;
  final String urlImage;
  QuestionModel({
    required this.docId,
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
      docId: doc.id,
      question: data['question'],
      answers: List<String>.from(data['answers']),
      correctAnswer: data['correctAnswer'],
      points: data['points'],
      timeLimit: data['timeLimit'],
      urlImage: data['urlImage'],
    );
  }
}
