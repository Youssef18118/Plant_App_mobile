part of 'guide_created_cubit.dart';

@immutable
sealed class GuideCreatedState {}

final class GuideCreatedInitial extends GuideCreatedState {}

class GuideCreatedLoading extends GuideCreatedState {}

class GuideCreatedLoaded extends GuideCreatedState {
  final String? wateringText;
  final String? sunlightText;
  final String? pruningText;

  GuideCreatedLoaded(this.wateringText, this.sunlightText, this.pruningText);
}

class GuideCreatedError extends GuideCreatedState {
  final String errorMessage;

  GuideCreatedError(this.errorMessage);
}