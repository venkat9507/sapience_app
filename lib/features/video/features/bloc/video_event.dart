part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class VideoInitialEvent extends VideoEvent {
  final int? videoNumber ;
  final List<dynamic>? videosList;
  final bool? isDTTC;
  final bool isDownload;
  final String? videoUrl;
  VideoInitialEvent({this.videoNumber,this.videosList,this.isDTTC , required this.isDownload,this.videoUrl});
}

class ChangingTheVideoEvent extends VideoEvent {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  ChangingTheVideoEvent({this.videoNumber,
    this.nextVideoID,
    this.prevVideoID,
    this.isPrevButtonPressed,
    this.videosList,
  });
}

class VideoBackNavigateButtonEvent extends VideoEvent {}
class VideoPauseButtonEvent extends VideoEvent {}

