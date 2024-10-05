part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}


class LoginPasswordVisibilityChanged extends LoginState {
  final bool isPasswordVisible;

  LoginPasswordVisibilityChanged(this.isPasswordVisible);
}

final class LoginLoadingState extends LoginState {}
final class LoginSucessState extends LoginState {}
final class LogineErrorState extends LoginState {
 final String message;
 LogineErrorState(this.message);
}

final class LogOutSucessState extends LoginState {}
final class LogOutErrorState extends LoginState {
 final String message;
 LogOutErrorState(this.message);
}

