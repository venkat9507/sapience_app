part of 'ukg_inside_bloc.dart';

@immutable
abstract class UkgInsideState {}

class UkgInsideInitial extends UkgInsideState {}

abstract class UkgInsideActionState extends UkgInsideState {}

class UkgInsideInitialLoadingState extends UkgInsideState {}

class UkgInsideInitialLoadedSuccessState extends UkgInsideState {
  final List<UkgInsideModelList>? ukgProducts ;
  final String title;
  UkgInsideInitialLoadedSuccessState({this.ukgProducts,required this.title});
}

class UkgInsideInitialErrorState extends UkgInsideState {
  final String? error;
  UkgInsideInitialErrorState({required this.error});
}

class UkgInsideActionButtonState extends UkgInsideActionState {
  final int? videoID;
  final bool? isDownload;
  final String? videoUrl;
  UkgInsideActionButtonState({this.videoID,this.isDownload,this.videoUrl});
}

class UkgInsideWatchOnlineActionButtonState extends UkgInsideActionState {

  final int? videoID;

  UkgInsideWatchOnlineActionButtonState({this.videoID});
}

class UkgInsideBackActionButtonState extends UkgInsideActionState {}



class UkgInsideDownloadActionButtonLoadingState extends UkgInsideActionState {}
class UkgInsideDownloadActionButtonSuccessState extends UkgInsideActionState {}
class UkgInsideDownloadActionButtonErrorState extends UkgInsideState {
  final String? error;
  UkgInsideDownloadActionButtonErrorState({required this.error});
}

class UkgInsideUpdatingRatingStarButtonLoadingState extends UkgInsideActionState {}

class UkgInsideUpdatingRatingStarButtonLoadedSuccessState extends UkgInsideActionState {
  final double? rating ;
  final int? videoID ;
  UkgInsideUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}



class UkgInsideUpdatingRatingStarButtonErrorState extends UkgInsideActionState {
  final String error;
  UkgInsideUpdatingRatingStarButtonErrorState({required this.error});
}
