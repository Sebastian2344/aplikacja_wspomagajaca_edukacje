import 'package:cloud_firestore/cloud_firestore.dart';

class QuizConfigModel {
  final String userId;
  bool nextQuestion;
  bool pause;
  bool start;
  bool end;
  final int gameCode;
  final String docId;

  QuizConfigModel({
    required this.docId,
    required this.userId,
    required this.nextQuestion,
    required this.pause,
    required this.start,
    required this.end,
    required this.gameCode,
  });

  factory QuizConfigModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return QuizConfigModel(
        docId: doc.id,
        userId: data['userId'],
        nextQuestion: data['nextQuestion'],
        pause: data['pause'],
        start: data['start'],
        end: data['end'],
        gameCode: data['gameCode']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nextQuestion': nextQuestion,
      'pause': pause,
      'start': start,
      'end': end,
      'gameCode': gameCode,
    };
  }
}
