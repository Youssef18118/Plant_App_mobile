part of 'details_created_cubit.dart';

@immutable
sealed class DetailsCreatedState {}

class DetailsCreatedInitial extends DetailsCreatedState {}

class DetailsCreatedLoading extends DetailsCreatedState {}

class DetailsCreatedLoaded extends DetailsCreatedState {
  final String type;
  final String growthRate;
  final String watering;
  final String sunlight;
  final String pruning;
  final String description;
  final String origin;
  final String leafColor;

  DetailsCreatedLoaded({
    required this.type,
    required this.growthRate,
    required this.watering,
    required this.sunlight,
    required this.pruning,
    required this.description,
    required this.origin,
    required this.leafColor,
  });
}

class DetailsCreatedError extends DetailsCreatedState {
  final String errorMessage;
  DetailsCreatedError(this.errorMessage);
}