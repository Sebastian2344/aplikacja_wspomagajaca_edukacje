import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedQuizModel {
  final String quizOwnerUserId;
  final String nickname;
  final int points;
  SolvedQuizModel({
    required this.quizOwnerUserId,
    required this.nickname,
    required this.points,
  });

  factory SolvedQuizModel.fromQueryDocumentSnapshot(DocumentSnapshot<Map<String,dynamic>> doc){
    Map<String, dynamic> data = doc.data()!;
    return SolvedQuizModel(quizOwnerUserId:data['quizOwnerUserId'],nickname:data['nickname'], points:data['result']);
  }
}
