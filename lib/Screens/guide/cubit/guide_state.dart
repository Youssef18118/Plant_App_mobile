part of 'guide_cubit.dart';

@immutable
sealed class GuideState {}

final class GuideInitial extends GuideState {}

final class GuideLoadingState extends GuideState {}
final class GuideSuccessState extends GuideState {}
final class GuideErrorState extends GuideState {
  String? message;
  GuideErrorState(this.message);
}