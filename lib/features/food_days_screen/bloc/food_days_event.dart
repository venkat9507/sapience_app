part of 'food_days_bloc.dart';

@immutable
abstract class FoodDaysEvent {}

class FoodDaysInitialEvent extends FoodDaysEvent {
  // final int? sectionID ;
  // final int? videoCatID ;
  final String? title;
  // final List<LkgInsideModelList>? lkgInsideProducts ;
  FoodDaysInitialEvent({
    // this.sectionID,this.videoCatID,
    this.title});
}

class FoodDaysChangingTheColorEvent extends FoodDaysEvent {
  final int? index ;
  final bool? isRightButton ;
  final FoodDaysModel? foodDaysModel ;
  FoodDaysChangingTheColorEvent({this.index,this.isRightButton,this.foodDaysModel});
}

class FoodDaysUpdatingRatingStarEvent extends FoodDaysEvent {
  final double? rating ;
  final int? videoID ;
  FoodDaysUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class FoodDaysNavigateButtonEvent extends FoodDaysEvent {
  final int? foodTypeID;
  final String? title;

  FoodDaysNavigateButtonEvent({this.foodTypeID,this.title});

}
class FoodDaysWatchOnlineNavigateButtonEvent extends FoodDaysEvent {
  final int? videoID;

  FoodDaysWatchOnlineNavigateButtonEvent({this.videoID});

}
class FoodDaysBackNavigateButtonEvent extends FoodDaysEvent {}
class FoodDaysDownloadNavigateButtonEvent extends FoodDaysEvent {}
