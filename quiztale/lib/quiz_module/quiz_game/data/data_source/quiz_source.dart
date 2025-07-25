import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../commons/exceptions/exceptions.dart';

class QuizSource {
  QuizSource(this._db); 
  final FirebaseFirestore _db;

  Future<QuerySnapshot<Map<String, dynamic>>> getQuestions(String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> questions = await _db
          .collection("Quizies")
          .doc(id)
          .collection('Questions')
          .get();
          
      return questions;
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getSettings(
      int gameCode) async {
    try {
      final id = await _db.collection('ConfigQuizies').where('gameCode',isEqualTo: gameCode).limit(1).get();
      return _db.collection('ConfigQuizies').doc(id.docs.first.id).snapshots().asBroadcastStream();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<String> putSolvedQuiz(Map<String, dynamic> json, String id) async {
    try {
      final doc = await _db
          .collection('Quizies')
          .doc(id)
          .collection('PlayersStats')
          .add(json);
      return doc.id;
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSolvedQuizies(
      String id) async {
    try {
      return await _db
          .collection('Quizies')
          .doc(id)
          .collection('PlayersStats')
          .get();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Exceptions _returnException(FirebaseException e){
    if (e.code == "unavailable") {
      return NetworkException(
            error:
                'Serwer niedostępny lub brak połączenia z internetem. Sprawdź dostęp do sieci i spróbuj ponownie.');
    }else if(e.code =='permission-denied'){
      return OtherFirebaseException(error: "Nie masz uprawnień do wykonania tej operacji.");
    } else if(e.code == 'deadline-exceeded'){
      return OtherFirebaseException(error: "Operacja nie zakończyła się w wyznaczonym czasie. Spróbuj ponownie.");
    }else {
      return OtherFirebaseException(
            error: e.message ?? 'Błąd związany z usługą colud firestore. Kod błędu: ${e.code}.');
    }
  }
}
