import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({
    required UserSignUp userSignUp,
  }) : _userSignUp = userSignUp, 
  super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      on<AuthSignUp>((event, emit) async {
        final response = await _userSignUp(UserSignupParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ));

        response.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (uid) => emit(AuthSuccess(uid)));
      });
    });
  }
}
