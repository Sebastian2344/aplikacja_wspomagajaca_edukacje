abstract class Exceptions {
  final String error;

  const Exceptions({required this.error});
}

final class NetworkException extends Exceptions {
  const NetworkException({required super.error});
}

final class OtherFirebaseException extends Exceptions{
 const OtherFirebaseException({required super.error});
}

final class UnknownException extends Exceptions {
 const UnknownException({required super.error});
}