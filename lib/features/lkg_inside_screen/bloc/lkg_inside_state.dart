part of 'lkg_inside_bloc.dart';

@immutable
abstract class LkgInsideState {}

class LkgInsideInitial extends LkgInsideState {}

abstract class LkgInsideActionState extends LkgInsideState {}

class LkgInsideInitialLoadingState extends LkgInsideState {}

class LkgInsideInitialLoadedSuccessState extends LkgInsideState {
  final List<LkgInsideModelList>? lkgProducts ;
  final String title;
  LkgInsideInitialLoadedSuccessState({this.lkgProducts,required this.title});
}

class LkgInsideInitialErrorState extends LkgInsideState {
  final String? error;
  LkgInsideInitialErrorState({required this.error});
}

class LkgInsideActionButtonState extends LkgInsideActionState {

  final int? videoID;
  final bool? isDownload;
  final String? videoUrl;

  LkgInsideActionButtonState({this.videoID,this.isDownload,this.videoUrl});
}

class LkgInsideWatchOnlineActionButtonState extends LkgInsideActionState {

  final int? videoID;

  LkgInsideWatchOnlineActionButtonState({this.videoID});
}
class LkgInsideBackActionButtonState extends LkgInsideActionState {}


class LkgInsideDownloadActionButtonLoadingState extends LkgInsideActionState {}
class LkgInsideDownloadActionButtonSuccessState extends LkgInsideActionState {}
class LkgInsideDownloadActionButtonErrorState extends LkgInsideState {
  final String? error;
  LkgInsideDownloadActionButtonErrorState({required this.error});
}


class LkgInsideUpdatingRatingStarButtonLoadingState extends LkgInsideActionState {}

class LkgInsideUpdatingRatingStarButtonLoadedSuccessState extends LkgInsideActionState {
  final double? rating ;
  final int? videoID ;
  LkgInsideUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class LkgInsideUpdatingRatingStarButtonErrorState extends LkgInsideActionState {
  final String error;
  LkgInsideUpdatingRatingStarButtonErrorState({required this.error});
}

