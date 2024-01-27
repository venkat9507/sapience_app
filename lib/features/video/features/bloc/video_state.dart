part of 'video_bloc.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

abstract class VideoActionState extends VideoState {}


class VideoInitialLoadingState extends VideoState {}

class VideoInitialLoadedSuccessState extends VideoState {
  final VideoData? videoData ;
  final bool? isDownload;
  VideoInitialLoadedSuccessState({this.videoData,this.isDownload});
}

class VideoInitialErrorState extends VideoState {
  final String? error;
  VideoInitialErrorState({required this.error});
}
class VideoPrevOrNextState extends VideoActionState {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  VideoPrevOrNextState({required this.videoNumber,
    this.videosList,
    this.isPrevButtonPressed,this.prevVideoID,this.nextVideoID});
}

class VideoPrevOrNextErrorState extends VideoActionState {
  final String? error;
  VideoPrevOrNextErrorState({required this.error});
}

class VideoPrevOrNextLoadingState extends VideoActionState {
  // final String? loading;
  // VideoPrevOrNextLoadingState({ this.loading});
}
class VideoPauseButtonState extends VideoActionState {
  // final String? loading;
  // VideoPrevOrNextLoadingState({ this.loading});
}
class VideoBackButtonPressedState extends VideoActionState {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  VideoBackButtonPressedState({
    this.videosList,
    this.videoNumber,
    this.isPrevButtonPressed,
    this.prevVideoID,
    this.nextVideoID});
}

class VideoDownloadActionButtonLoadingState extends VideoActionState {}
class VideoDownloadActionButtonSuccessState extends VideoActionState {
  final String? successState;
  VideoDownloadActionButtonSuccessState({this.successState});
}
class VideoDownloadActionButtonErrorState extends VideoActionState {
  final String? error;
  VideoDownloadActionButtonErrorState({required this.error});
}