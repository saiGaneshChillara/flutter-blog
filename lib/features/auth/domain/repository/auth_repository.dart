import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failures.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>>signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}