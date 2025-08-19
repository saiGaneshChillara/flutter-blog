import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failures.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<User, UserSignupParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
  
}

class UserSignupParams {
  final String email;
  final String password;
  final String name;

  UserSignupParams({
    required this.email,
    required this.password,
    required this.name,
  });
}