part of 'food_inside_bloc.dart';

@immutable
abstract class FoodInsideState {}

class FoodInsideInitial extends FoodInsideState {}

abstract class FoodInsideActionState extends FoodInsideState {}

class FoodInsideInitialLoadingState extends FoodInsideState {}

class FoodInsideInitialLoadedSuccessState extends FoodInsideState {
  final List<FoodInsideModelList>? foodProducts ;
  final String title;
  FoodInsideInitialLoadedSuccessState({this.foodProducts,required this.title});
}

class FoodInsideInitialErrorState extends FoodInsideState {
  final String? error;
  FoodInsideInitialErrorState({required this.error});
}

class FoodInsideActionButtonState extends FoodInsideActionState {

  final int? videoID;
  final bool? isDownload;
  final String? videoUrl;

  FoodInsideActionButtonState({this.videoID,this.isDownload,this.videoUrl});
}

class FoodInsideWatchOnlineActionButtonState extends FoodInsideActionState {

  final int? videoID;

  FoodInsideWatchOnlineActionButtonState({this.videoID});
}
class FoodInsideBackActionButtonState extends FoodInsideActionState {}


class FoodInsideDownloadActionButtonLoadingState extends FoodInsideActionState {}
class FoodInsideDownloadActionButtonSuccessState extends FoodInsideActionState {}
class FoodInsideDownloadActionButtonErrorState extends FoodInsideState {
  final String? error;
  FoodInsideDownloadActionButtonErrorState({required this.error});
}


class FoodInsideUpdatingRatingStarButtonLoadingState extends FoodInsideActionState {}

class FoodInsideUpdatingRatingStarButtonLoadedSuccessState extends FoodInsideActionState {
  final double? rating ;
  final int? videoID ;
  FoodInsideUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class FoodInsideUpdatingRatingStarButtonErrorState extends FoodInsideActionState {
  final String error;
  FoodInsideUpdatingRatingStarButtonErrorState({required this.error});
}

