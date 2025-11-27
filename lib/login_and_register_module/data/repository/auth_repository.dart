import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../exceptions/exceptions.dart';
import '../data_source/auth_source.dart';

class AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Stream<User?> get streamUser => _dataSource.streamUser;
  User? get user => _dataSource.user;

  Future<Either<Exception,bool>> isUserVerified() async {
    try {
      final isVerified = await _dataSource.isVerifiedUser();
      return Right(isVerified);
    } catch (e) {
      return Left(_returnException(e));
    } 
  }

  Future<Either<Exception, Unit>> addUserToDB(User? user) async {
    try {
      Map<String,dynamic> data = {'verified': false};
      await _dataSource.addUserToDB(user,data);
      return const Right(unit);
    } catch (e) {
      return Left(_returnException(e));
    }
  }

  Future<Either<AuthException, void>> login(String email, String password) async {
    try {
      await _dataSource.login(email, password);
      return Right(null);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(_mapFirebaseAuthExceptionToAuthException(e));
      } else {
        return Left(AuthException(AuthError.unknownError));
      }
    }
  }

  Future<Either<AuthException, User?>> register(String email, String password) async {
    try {
      final user = await _dataSource.register(email, password);
      return Right(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(_mapFirebaseAuthExceptionToAuthException(e));
      } else {
        return Left(AuthException(AuthError.unknownError));
      }
    }
  }

  Future<Either<AuthException, void>> loginAnonymous() async {
    try {
      await _dataSource.loginAnonymous();
      return Right(null);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(_mapFirebaseAuthExceptionToAuthException(e));
      } else {
        return Left(AuthException(AuthError.unknownError));
      }
    }
  }

  Future<Either<AuthException,Unit>> changePassword(String email)async{
    try {
      await _dataSource.changePassword(email);
      return const Right(unit);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(_mapFirebaseAuthExceptionToAuthException(e));
      } else {
        return Left(AuthException(AuthError.unknownError));
      }
    }
  }

  Future<Either<AuthException, Unit>> logout() async {
    try {
      await _dataSource.logout();
      return const Right(unit);
    } catch (e) {
      return Left(AuthException(AuthError.unknownError));
    }
  }

  AuthException _mapFirebaseAuthExceptionToAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(AuthError.userNotFound);
      case 'wrong-password':
        return AuthException(AuthError.wrongPassword);
      case 'email-already-in-use':
        return AuthException(AuthError.emailAlreadyInUse);
      case 'invalid-email':
        return AuthException(AuthError.invalidEmail);
      case 'operation-not-allowed':
        return AuthException(AuthError.operationNotAllowed);
      case 'weak-password':
        return AuthException(AuthError.weakPassword);
      case 'network-request-failed':
        return AuthException(AuthError.networkRequestFailed);
      default:
        return AuthException(AuthError.unknownError);
    }
  }

  Exception _returnException(Object e){
    if(e is FirebaseException){
        if(e.code == 'unavailable'){
          return Exception('Sprawdź połączenie z internetem');
        }else{
          return Exception(e.toString());
        }       
      }else{
        return Exception(e.toString());
      }
  }
}
