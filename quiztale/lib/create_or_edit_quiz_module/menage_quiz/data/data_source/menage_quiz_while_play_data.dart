import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../commons/exceptions/exceptions.dart';

class MenageQuizWhilePlayData {
  MenageQuizWhilePlayData(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  Future<void> setSettings(Map<String, dynamic> settings, String docId) async {
    try {
      await _firebaseFirestore
          .collection('ConfigQuizies')
          .doc(docId)
          .update(settings);
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> downloadQuizConfig(
      int gameCode) async {
    try {
      return await _firebaseFirestore
          .collection('ConfigQuizies')
          .where('gameCode', isEqualTo: gameCode)
          .limit(1)
          .get();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<void> deleteStats(String quizId) async {
    try {
      final playersStats = await _firebaseFirestore
          .collection('Quizies')
          .doc(quizId)
          .collection('PlayersStats')
          .get();

      if (playersStats.docs.isNotEmpty) {
        WriteBatch batch = _firebaseFirestore.batch();

        for (int i = 0; i < playersStats.docs.length; i++) {
          final playerStats = _firebaseFirestore
              .collection('Quizies')
              .doc(quizId)
              .collection('PlayersStats')
              .doc(playersStats.docs[i].id);
          batch.delete(playerStats);
        }

        await batch.commit();
      }
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
    } else {
      return OtherFirebaseException(
            error: e.message ?? 'Błąd związany z usługą colud firestore. Kod błędu: ${e.code}.');
    }
  }
}