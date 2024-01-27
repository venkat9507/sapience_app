part of 'dttc_inside_bloc.dart';

@immutable
abstract class DTTCInsideState {}

class DTTCInsideInitial extends DTTCInsideState {}

abstract class DTTCInsideActionState extends DTTCInsideState {}

class DTTCInsideInitialLoadingState extends DTTCInsideState {}

class DTTCInsideInitialLoadedSuccessState extends DTTCInsideState {
  final List<DTTCInsideModelList>? dttcProducts ;
  final String title;
  DTTCInsideInitialLoadedSuccessState({this.dttcProducts,required this.title});
}

class DTTCInsideInitialErrorState extends DTTCInsideState {
  final String? error;
  DTTCInsideInitialErrorState({required this.error});
}

class DTTCInsideActionButtonState extends DTTCInsideActionState {

  final int? videoID;

  DTTCInsideActionButtonState({this.videoID});
}
class DTTCInsideBackActionButtonState extends DTTCInsideActionState {}



class DTTCInsideUpdatingRatingStarButtonLoadingState extends DTTCInsideActionState {}

class DTTCInsideUpdatingRatingStarButtonLoadedSuccessState extends DTTCInsideActionState {
  final double? rating ;
  final int? videoID ;
  DTTCInsideUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class DTTCInsideUpdatingRatingStarButtonErrorState extends DTTCInsideActionState {
  final String error;
  DTTCInsideUpdatingRatingStarButtonErrorState({required this.error});
}


