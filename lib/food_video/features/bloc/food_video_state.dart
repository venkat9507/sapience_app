part of 'food_video_bloc.dart';



@immutable
abstract class FoodVideoState {}

class FoodVideoInitial extends FoodVideoState {}

abstract class FoodVideoActionState extends FoodVideoState {}


class FoodVideoInitialLoadingState extends FoodVideoState {}

class FoodVideoInitialLoadedSuccessState extends FoodVideoState {
  final FoodVideoData? videoData ;
  final bool? isDownload;
  FoodVideoInitialLoadedSuccessState({this.videoData,this.isDownload});
}

class FoodVideoInitialErrorState extends FoodVideoState {
  final String? error;
  FoodVideoInitialErrorState({required this.error});
}
class FoodVideoPrevOrNextState extends FoodVideoActionState {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  FoodVideoPrevOrNextState({required this.videoNumber,
    this.videosList,
    this.isPrevButtonPressed,this.prevVideoID,this.nextVideoID});
}

class FoodVideoPrevOrNextErrorState extends FoodVideoActionState {
  final String? error;
  FoodVideoPrevOrNextErrorState({required this.error});
}

class FoodVideoPrevOrNextLoadingState extends FoodVideoActionState {
  // final String? loading;
  // VideoPrevOrNextLoadingState({ this.loading});
}
class FoodVideoPauseButtonState extends FoodVideoActionState {
  // final String? loading;
  // VideoPrevOrNextLoadingState({ this.loading});
}
class FoodVideoBackButtonPressedState extends FoodVideoActionState {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  FoodVideoBackButtonPressedState({
    this.videosList,
    this.videoNumber,
    this.isPrevButtonPressed,
    this.prevVideoID,
    this.nextVideoID});
}

class FoodVideoDownloadActionButtonLoadingState extends FoodVideoActionState {}
class FoodVideoDownloadActionButtonSuccessState extends FoodVideoActionState {
  final String? successState;
  FoodVideoDownloadActionButtonSuccessState({this.successState});
}
class FoodVideoDownloadActionButtonErrorState extends FoodVideoActionState {
  final String? error;
  FoodVideoDownloadActionButtonErrorState({required this.error});
}