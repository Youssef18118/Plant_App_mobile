part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterSuccessState extends RegisterState {
  bool snackbarShown = false; 
}

final class RegisterErrorState extends RegisterState {
  final String message;
  bool snackbarShown = false; 


  RegisterErrorState(this.message);
}

