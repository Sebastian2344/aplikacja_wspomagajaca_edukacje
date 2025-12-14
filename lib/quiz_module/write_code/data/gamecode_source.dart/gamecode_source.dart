import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../commons/exceptions/exceptions.dart';

class GameCodeSource {
  GameCodeSource(this._db);
  final FirebaseFirestore _db;
  Future<(String, bool, QuerySnapshot<Map<String, dynamic>>)> isQuizExist(
      int gameCode) async {
    try {
      final quiz = await _db
          .collection('Quizies')
          .where('gameCode', isEqualTo: gameCode)
          .limit(1)
          .get();

      if (quiz.docs.isEmpty) {
        throw QuizDoesntExist(error: 'Ten quiz nie istnieje');
      }

      return (quiz.docs.first.id, true, quiz);
    } on FirebaseException catch (e) {
      throw _returnException(e);
    } on QuizDoesntExist catch (_) {
      rethrow;
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Exceptions _returnException(FirebaseException e) {
    if (e.code == "unavailable") {
      return NetworkException(
          error:
              'Serwer niedostępny lub brak połączenia z internetem. Sprawdź dostęp do sieci i spróbuj ponownie.');
    } else if (e.code == 'permission-denied') {
      return OtherFirebaseException(
          error: "Nie masz uprawnień do wykonania tej operacji.");
    } else if (e.code == 'deadline-exceeded') {
      return OtherFirebaseException(
          error:
              "Operacja nie zakończyła się w wyznaczonym czasie. Spróbuj ponownie.");
    } else {
      return OtherFirebaseException(
          error: e.message ??
              'Błąd związany z usługą colud firestore. Kod błędu: ${e.code}.');
    }
  }
}
