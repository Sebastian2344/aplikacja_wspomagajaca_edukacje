import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../commons/exceptions/exceptions.dart';

class CreateOrEditQuizData {
  CreateOrEditQuizData(this._firebaseFirestore, this._authInstance);
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _authInstance;

  Future<String> createQuiz(
      Map<String, dynamic> quiz,
      List<Map<String, dynamic>> questions,
      Map<String, dynamic> settings) async {
    WriteBatch batch = _firebaseFirestore.batch();

    try {
      final id = _firebaseFirestore.collection('Quizies').doc();
      batch.set(id, quiz);

      
      for (var question in questions) {
        final questionsRef = _firebaseFirestore
          .collection('Quizies')
          .doc(id.id)
          .collection('Questions')
          .doc();
        batch.set(questionsRef, question);
      }

      final configQuiziesDocRef =
          _firebaseFirestore.collection('ConfigQuizies').doc();
      batch.set(configQuiziesDocRef, settings);

      await batch.commit();
      
      return id.id;
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<void> editQuiz(
      Map<String, dynamic> quiz,
      List<Map<String, dynamic>> questionsToDB,
      String id,
      List<Map<String, dynamic>> downloadedQuestion) async {
    WriteBatch batch = _firebaseFirestore.batch();

    try {
      final quiziesDocRef = _firebaseFirestore.collection('Quizies').doc(id);
      batch.set(quiziesDocRef, quiz);

      if (downloadedQuestion.length == questionsToDB.length) {
        for (int i = 0; i < questionsToDB.length; i++) {
          final concreteQuestion = _firebaseFirestore
              .collection('Quizies')
              .doc(id)
              .collection('Questions')
              .doc(downloadedQuestion.elementAt(i)['id']);
          batch.set(concreteQuestion, questionsToDB.elementAt(i));
        }
      } else if (downloadedQuestion.length > questionsToDB.length) {
        for (int i = 0; i < downloadedQuestion.length; i++) {
          if (i < questionsToDB.length) {
            final concreteQuestion = _firebaseFirestore
                .collection('Quizies')
                .doc(id)
                .collection('Questions')
                .doc(downloadedQuestion.elementAt(i)['id']);
            batch.set(concreteQuestion, questionsToDB.elementAt(i));
          } else {
            final concreteQuestion = _firebaseFirestore
                .collection('Quizies')
                .doc(id)
                .collection('Questions')
                .doc(downloadedQuestion.elementAt(i)['id']);
            batch.delete(concreteQuestion);
          }
        }
      } else if (downloadedQuestion.length < questionsToDB.length) {
        for (int i = 0; i < questionsToDB.length; i++) {
          if (i < downloadedQuestion.length) {
            final concreteQuestion = _firebaseFirestore
                .collection('Quizies')
                .doc(id)
                .collection('Questions')
                .doc(downloadedQuestion.elementAt(i)['id']);
            batch.set(concreteQuestion, questionsToDB.elementAt(i));
          } else {
            final concreteQuestion = _firebaseFirestore
                .collection('Quizies')
                .doc(id)
                .collection('Questions')
                .doc();
            batch.set(concreteQuestion, questionsToDB.elementAt(i));
          }
        }
      }

      await batch.commit();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> downloadListQuizToSelect() async {
    try {
      return await _firebaseFirestore
          .collection('Quizies')
          .where('userId', isEqualTo: _authInstance.currentUser!.uid)
          .get();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> downloadQuestions(
      String id) async {
    try {
      return await _firebaseFirestore
          .collection('Quizies')
          .doc(id)
          .collection('Questions')
          .get();
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }

  

  Future<bool> gameCodeCheck(int code) async {
    try {
      final response = await _firebaseFirestore
          .collection('Quizies')
          .where('gameCode', isEqualTo: code)
          .get();
      if (response.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e, _) {
      throw _returnException(e);
    } catch (e) {
      throw UnknownException(error: e.toString());
    }
  }
  
  String getUserId() {
    return _authInstance.currentUser!.uid;
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
