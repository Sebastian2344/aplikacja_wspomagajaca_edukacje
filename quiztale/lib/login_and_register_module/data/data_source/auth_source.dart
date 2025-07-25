import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._firebaseAuth,this._firebaseFirestore);
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  Stream<User?> get streamUser => _firebaseAuth.authStateChanges();
  User? get user => _firebaseAuth.currentUser;

  Future<void> login(String email, String password) async {
    try {
       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException{
      rethrow;
    } catch (e) {
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return user.user;
    } on FirebaseAuthException{
      rethrow; 
    } catch (e) {
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<void> changePassword(String email) async {
    try{
       await _firebaseAuth.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException{
      rethrow; 
    }catch(e){
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<void> loginAnonymous() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException{
      rethrow;
    } catch (e) {
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<bool> isVerifiedUser() async {
   try{
    final user = await _firebaseFirestore.collection('Users').doc(_firebaseAuth.currentUser!.uid).get();
    final bool isVerified = user.data()!['verified'];
    return isVerified;
   }on FirebaseException{
      rethrow;
    }catch(e){
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<void> addUserToDB(User? user,Map<String,dynamic> data) async {
    try {
      await _firebaseFirestore.collection('Users').doc(user!.uid).set(data);
    }on FirebaseException{
      rethrow;
    }catch(e){
      throw Exception('Wystąpił nieznany błąd: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Wystąpił problem podczas wylogowywania: $e');
    }
  }

}
