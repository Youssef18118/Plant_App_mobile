part of 'details_cubit.dart';

@immutable
abstract class PlantDetailsState {}

class PlantDetailsInitial extends PlantDetailsState {}

class PlantDetailsLoadingState extends PlantDetailsState {}

class PlantDetailsSuccessState extends PlantDetailsState {}

class PlantDetailsErrorState extends PlantDetailsState {
  final String? message;

  PlantDetailsErrorState(this.message);
}
