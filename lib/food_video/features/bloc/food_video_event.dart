part of 'food_video_bloc.dart';

@immutable
abstract class FoodVideoEvent {}

class FoodVideoInitialEvent extends FoodVideoEvent {
  final int? videoNumber ;
  final List<dynamic>? videosList;
  final bool isDownload;
  final String? videoUrl;
  FoodVideoInitialEvent({this.videoNumber,this.videosList, required this.isDownload,this.videoUrl});
}

class FoodChangingTheVideoEvent extends FoodVideoEvent {
  final int? videoNumber ;
  final int? prevVideoID;
  final int? nextVideoID;
  final bool? isPrevButtonPressed;
  final List<dynamic>? videosList;
  FoodChangingTheVideoEvent({this.videoNumber,
    this.nextVideoID,
    this.prevVideoID,
    this.isPrevButtonPressed,
    this.videosList,
  });
}

class FoodVideoBackNavigateButtonEvent extends FoodVideoEvent {}
class FoodVideoPauseButtonEvent extends FoodVideoEvent {}

