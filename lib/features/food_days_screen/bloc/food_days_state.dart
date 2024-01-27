part of 'food_days_bloc.dart';

@immutable
abstract class FoodDaysState {}

class FoodDaysInitial extends FoodDaysState {}

abstract class FoodDaysActionState extends FoodDaysState {}

class FoodDaysInitialLoadingState extends FoodDaysState {}

class FoodDaysInitialLoadedSuccessState extends FoodDaysState {
  final FoodDaysModel? foodDaysModel ;
  final String title;
  FoodDaysInitialLoadedSuccessState({this.foodDaysModel,required this.title});
}

class FoodDaysInitialErrorState extends FoodDaysState {
  final String? error;
  FoodDaysInitialErrorState({required this.error});
}

class FoodDaysActionButtonState extends FoodDaysActionState {

  final int? foodDaysID;
  final String? title;

  FoodDaysActionButtonState({this.foodDaysID,this.title,});
}

class FoodDaysWatchOnlineActionButtonState extends FoodDaysActionState {

  final int? videoID;

  FoodDaysWatchOnlineActionButtonState({this.videoID});
}
class FoodDaysBackActionButtonState extends FoodDaysActionState {}


class FoodDaysDownloadActionButtonLoadingState extends FoodDaysActionState {}
class FoodDaysDownloadActionButtonSuccessState extends FoodDaysActionState {}
class FoodDaysDownloadActionButtonErrorState extends FoodDaysState {
  final String? error;
  FoodDaysDownloadActionButtonErrorState({required this.error});
}


class FoodDaysUpdatingRatingStarButtonLoadingState extends FoodDaysActionState {}

class FoodDaysUpdatingRatingStarButtonLoadedSuccessState extends FoodDaysActionState {
  final double? rating ;
  final int? videoID ;
  FoodDaysUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class FoodDaysUpdatingRatingStarButtonErrorState extends FoodDaysActionState {
  final String error;
  FoodDaysUpdatingRatingStarButtonErrorState({required this.error});
}

