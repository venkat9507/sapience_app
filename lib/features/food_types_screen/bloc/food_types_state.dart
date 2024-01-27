part of 'food_types_bloc.dart';

@immutable
abstract class FoodTypesState {}

class FoodTypesInitial extends FoodTypesState {}

abstract class FoodTypesActionState extends FoodTypesState {}

class FoodTypesInitialLoadingState extends FoodTypesState {}

class FoodTypesInitialLoadedSuccessState extends FoodTypesState {
  final FoodTypesModel? foodTypesModel ;
  final String title;
  FoodTypesInitialLoadedSuccessState({this.foodTypesModel,required this.title});
}

class FoodTypesInitialErrorState extends FoodTypesState {
  final String? error;
  FoodTypesInitialErrorState({required this.error});
}

class FoodTypesActionButtonState extends FoodTypesActionState {

  final int? foodTypeID;
  final String? title;

  FoodTypesActionButtonState({this.foodTypeID,this.title,});
}

class FoodTypesWatchOnlineActionButtonState extends FoodTypesActionState {

  final int? videoID;

  FoodTypesWatchOnlineActionButtonState({this.videoID});
}
class FoodTypesBackActionButtonState extends FoodTypesActionState {}


class FoodTypesDownloadActionButtonLoadingState extends FoodTypesActionState {}
class FoodTypesDownloadActionButtonSuccessState extends FoodTypesActionState {}
class FoodTypesDownloadActionButtonErrorState extends FoodTypesState {
  final String? error;
  FoodTypesDownloadActionButtonErrorState({required this.error});
}


class FoodTypesUpdatingRatingStarButtonLoadingState extends FoodTypesActionState {}

class FoodTypesUpdatingRatingStarButtonLoadedSuccessState extends FoodTypesActionState {
  final double? rating ;
  final int? videoID ;
  FoodTypesUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class FoodTypesUpdatingRatingStarButtonErrorState extends FoodTypesActionState {
  final String error;
  FoodTypesUpdatingRatingStarButtonErrorState({required this.error});
}

