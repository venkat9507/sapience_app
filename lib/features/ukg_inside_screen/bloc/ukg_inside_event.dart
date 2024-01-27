part of 'ukg_inside_bloc.dart';


@immutable
abstract class UkgInsideEvent {}

class UkgInsideInitialEvent extends UkgInsideEvent {
  final int? sectionID ;
  final int? videoCatID ;
  final String? title;
  UkgInsideInitialEvent({this.sectionID,this.videoCatID,this.title});
}

class UkgInsideChangingTheColorEvent extends UkgInsideEvent {
  final int? index ;
  final bool? isRightButton ;
  final List<UkgInsideModelList>? ukgInsideProducts ;
  UkgInsideChangingTheColorEvent({this.index,this.isRightButton,this.ukgInsideProducts});
}

class UkgInsideUpdatingRatingStarEvent extends UkgInsideEvent {
  final double? rating ;
  final int? videoID ;
  UkgInsideUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class UkgInsideNavigateButtonEvent extends UkgInsideEvent {
  final int? videoID;
  final bool? isDownload;

  final String? videoUrl;
  UkgInsideNavigateButtonEvent({this.videoID,this.isDownload,this.videoUrl});
}

class UkgInsideWatchOnlineNavigateButtonEvent extends UkgInsideEvent {
  final int? videoID;

  UkgInsideWatchOnlineNavigateButtonEvent({this.videoID});

}

class UkgInsideBackNavigateButtonEvent extends UkgInsideEvent {}
class UkgInsideDownloadNavigateButtonEvent extends UkgInsideEvent {}
