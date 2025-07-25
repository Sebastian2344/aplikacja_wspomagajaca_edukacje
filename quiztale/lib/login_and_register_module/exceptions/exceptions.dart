enum AuthError {
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidEmail,
  operationNotAllowed,
  weakPassword,
  unknownError,
  networkRequestFailed
}

class AuthException implements Exception {
  final AuthError error;

  AuthException(this.error);

  @override
  String toString() {
    switch (error) {
      case AuthError.userNotFound:
        return 'Użytkownik nie został znaleziony.';
      case AuthError.wrongPassword:
        return 'Nieprawidłowe hasło.';
      case AuthError.emailAlreadyInUse:
        return 'Ten adres e-mail jest już używany.';
      case AuthError.invalidEmail:
        return 'Nieprawidłowy adres e-mail.';
      case AuthError.operationNotAllowed:
        return 'Operacja nie jest dozwolona.';
      case AuthError.weakPassword:
        return 'Hasło jest zbyt słabe.';
      case AuthError.unknownError:
        return 'Wystąpił nieznany błąd.';
      case AuthError.networkRequestFailed:
        return 'Nie udało się połączyć z serwerem. Sprawdź internet i spróbuj ponownie.';
    }
  }
}