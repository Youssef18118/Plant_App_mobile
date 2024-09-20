part of 'home_screen_cubit.dart';

@immutable
sealed class HomeScreenState {}

final class HomeScreenInitial extends HomeScreenState {}

final class GettingPlantsSuccess extends HomeScreenState {}

final class GettingPlantsFailed extends HomeScreenState {
  final String? msg;
  GettingPlantsFailed({required this.msg});
}

final class GettingPlantsLoading extends HomeScreenState {}

final class ChangeButton extends HomeScreenState {}

final class ToggeldSuccessState extends HomeScreenState {}
