part of 'food_inside_bloc.dart';

@immutable
abstract class FoodInsideEvent {}

class FoodInsideInitialEvent extends FoodInsideEvent {
  final int? sectionID ;
  final int? foodCatID ;
  final int? foodTypeID ;
  final int? foodDayID ;
  final String? title;
  // final List<LkgInsideModelList>? lkgInsideProducts ;
  FoodInsideInitialEvent({this.sectionID,
    this.foodDayID,
    this.foodCatID,this.title,this.foodTypeID});
}

class FoodInsideChangingTheColorEvent extends FoodInsideEvent {
  final int? index ;
  final bool? isRightButton ;
  final List<FoodInsideModelList>? foodInsideProducts ;
  FoodInsideChangingTheColorEvent({this.index,this.isRightButton,this.foodInsideProducts});
}

class FoodInsideUpdatingRatingStarEvent extends FoodInsideEvent {
  final double? rating ;
  final int? videoID ;
  FoodInsideUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class FoodInsideNavigateButtonEvent extends FoodInsideEvent {
  final int? videoID;
  final bool? isDownload;
  final String? videoUrl;

  FoodInsideNavigateButtonEvent({this.videoID,this.isDownload,this.videoUrl});

}
class FoodInsideWatchOnlineNavigateButtonEvent extends FoodInsideEvent {
  final int? videoID;

  FoodInsideWatchOnlineNavigateButtonEvent({this.videoID});

}
class FoodInsideBackNavigateButtonEvent extends FoodInsideEvent {}
class FoodInsideDownloadNavigateButtonEvent extends FoodInsideEvent {}
