import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>>signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}