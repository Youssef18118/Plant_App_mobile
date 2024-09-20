part of 'species_cubit.dart';

@immutable
sealed class SpeciesState {}

final class SpeciesInitial extends SpeciesState {}

final class speciesloadingState extends SpeciesState {}

final class speciesSuccessState extends SpeciesState {}

final class speciesErrorState extends SpeciesState {
  String? message;
  speciesErrorState(this.message);
  }
  class SpeciesFiltered extends SpeciesState {}
