import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final String userId;
  final bool nextQuestion;
  final bool pause;
  final bool start;
  final bool end;
  final int gameCode;

  SettingsModel({
    required this.userId,
    required this.nextQuestion,
    required this.pause,
    required this.start,
    required this.end,
    required this.gameCode,
  });

  factory SettingsModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return SettingsModel(
        userId: data['userId'],
        nextQuestion: data['nextQuestion'],
        pause: data['pause'],
        start: data['start'],
        end: data['end'],
        gameCode: data['gameCode']);
  }
}
