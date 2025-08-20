import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/usecases/user_login.dart';
import 'package:myapp/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin, 
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignup(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final response = await _userSignUp(
      UserSignupParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user))
    );
  }

  void _onAuthLogin(
    AuthLogin event, Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final response = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user))
    );
  }
}
