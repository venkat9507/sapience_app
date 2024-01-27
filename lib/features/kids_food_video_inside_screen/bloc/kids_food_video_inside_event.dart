part of 'kids_food_video_inside_bloc.dart';

@immutable
abstract class KidsFoodVideoInsideEvent {}

class KidsFoodVideoInsideInitialEvent extends KidsFoodVideoInsideEvent {
  final int? sectionID ;
  final int? videoCatID ;
  final String? title;
  KidsFoodVideoInsideInitialEvent({this.videoCatID,this.sectionID,this.title});
}

class KidsFoodVideoInsideChangingTheColorEvent extends KidsFoodVideoInsideEvent {
  final int? index ;
  final bool? isRightButton ;
  final List<KFVInsideModelList>? kidsFoodVideoInsideProducts ;
  KidsFoodVideoInsideChangingTheColorEvent({this.index,this.isRightButton,this.kidsFoodVideoInsideProducts});
}

class KidsFoodVideoInsideNavigateButtonEvent extends KidsFoodVideoInsideEvent {
  final int? videoID;
  KidsFoodVideoInsideNavigateButtonEvent({this.videoID});
}
class KidsFoodVideoInsideBackNavigateButtonEvent extends KidsFoodVideoInsideEvent {}


class KFVInsideUpdatingRatingStarEvent extends KidsFoodVideoInsideEvent {
  final double? rating ;
  final int? videoID ;
  KFVInsideUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class KFVChangingTheDrawerColorEvent extends KidsFoodVideoInsideEvent {
  final int? index ;
  final List<DashboardList>? dashboardList;
  final List<KFVInsideModelList>? kidsFoodVideoInsideProducts ;
  final int? sectionID ;
  KFVChangingTheDrawerColorEvent({this.index,this.dashboardList,this.kidsFoodVideoInsideProducts,this.sectionID});
}

class LogoutKFVEvent  extends KidsFoodVideoInsideEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}