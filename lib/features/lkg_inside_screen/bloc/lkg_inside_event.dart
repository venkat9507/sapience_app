part of 'lkg_inside_bloc.dart';

@immutable
abstract class LkgInsideEvent {}

class LkgInsideInitialEvent extends LkgInsideEvent {
  final int? sectionID ;
  final int? videoCatID ;
  final String? title;
  // final List<LkgInsideModelList>? lkgInsideProducts ;
  LkgInsideInitialEvent({this.sectionID,this.videoCatID,this.title});
}

class LkgInsideChangingTheColorEvent extends LkgInsideEvent {
  final int? index ;
  final bool? isRightButton ;
  final List<LkgInsideModelList>? lkgInsideProducts ;
  LkgInsideChangingTheColorEvent({this.index,this.isRightButton,this.lkgInsideProducts});
}

class LkgInsideUpdatingRatingStarEvent extends LkgInsideEvent {
  final double? rating ;
  final int? videoID ;
  LkgInsideUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class LkgInsideNavigateButtonEvent extends LkgInsideEvent {
  final int? videoID;
  final bool? isDownload;
  final String? videoUrl;

  LkgInsideNavigateButtonEvent({this.videoID,this.isDownload,this.videoUrl});

}
class LkgInsideWatchOnlineNavigateButtonEvent extends LkgInsideEvent {
  final int? videoID;

  LkgInsideWatchOnlineNavigateButtonEvent({this.videoID});

}
class LkgInsideBackNavigateButtonEvent extends LkgInsideEvent {}
class LkgInsideDownloadNavigateButtonEvent extends LkgInsideEvent {}
