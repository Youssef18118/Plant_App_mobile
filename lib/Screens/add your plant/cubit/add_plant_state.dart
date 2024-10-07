part of 'add_plant_cubit.dart';

@immutable
sealed class AddPlantState {}

final class AddPlantInitial extends AddPlantState {}

final class getImageSuccessState extends AddPlantState {}

