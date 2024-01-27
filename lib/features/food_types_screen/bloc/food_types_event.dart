part of 'food_types_bloc.dart';

@immutable
abstract class FoodTypesEvent {}

class FoodTypesInitialEvent extends FoodTypesEvent {
  // final int? sectionID ;
  // final int? videoCatID ;
  final String? title;
  // final List<LkgInsideModelList>? lkgInsideProducts ;
  FoodTypesInitialEvent({
    // this.sectionID,this.videoCatID,
    this.title});
}

class FoodTypesChangingTheColorEvent extends FoodTypesEvent {
  final int? index ;
  final bool? isRightButton ;
  final FoodTypesModel? foodTypesModel ;
  FoodTypesChangingTheColorEvent({this.index,this.isRightButton,this.foodTypesModel});
}

class FoodTypesUpdatingRatingStarEvent extends FoodTypesEvent {
  final double? rating ;
  final int? videoID ;
  FoodTypesUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class FoodTypesNavigateButtonEvent extends FoodTypesEvent {
  final int? foodTypeID;
  final String? title;

  FoodTypesNavigateButtonEvent({this.foodTypeID,this.title});

}
class FoodTypesWatchOnlineNavigateButtonEvent extends FoodTypesEvent {
  final int? videoID;

  FoodTypesWatchOnlineNavigateButtonEvent({this.videoID});

}
class FoodTypesBackNavigateButtonEvent extends FoodTypesEvent {}
class FoodTypesDownloadNavigateButtonEvent extends FoodTypesEvent {}
