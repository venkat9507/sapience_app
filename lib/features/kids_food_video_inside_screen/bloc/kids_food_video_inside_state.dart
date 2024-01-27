part of 'kids_food_video_inside_bloc.dart';


@immutable
abstract class KidsFoodVideoInsideState {}

class KidsFoodVideoInsideInitial extends KidsFoodVideoInsideState {}

abstract class KidsFoodVideoInsideActionState extends KidsFoodVideoInsideState {}

class KidsFoodVideoInsideInitialLoadingState extends KidsFoodVideoInsideState {}

class KidsFoodVideoInsideInitialLoadedSuccessState extends KidsFoodVideoInsideState {
  final List<KFVInsideModelList>? kidsFoodVideoProducts ;
  final  List<DashboardList>? dashboardList;
  final String title;
  KidsFoodVideoInsideInitialLoadedSuccessState({this.kidsFoodVideoProducts,this.dashboardList,required this.title});
}

class KidsFoodVideoInsideInitialErrorState extends KidsFoodVideoInsideState {
  final String? error;
  KidsFoodVideoInsideInitialErrorState({required this.error});
}

class KidsFoodVideoInsideActionButtonState extends KidsFoodVideoInsideActionState {

  final int? videoID;

  KidsFoodVideoInsideActionButtonState({this.videoID});
}
class KidsFoodVideoInsideBackActionButtonState extends KidsFoodVideoInsideActionState {}

class KFVDrawerActionButtonState extends KidsFoodVideoInsideActionState {
  final int? index;
  final int? sectionID ;
  KFVDrawerActionButtonState({this.index,this.sectionID});
}

class KFVLogoutButtonLoadingState extends KidsFoodVideoInsideActionState {}

class KFVLogoutButtonLoadedSuccessState extends KidsFoodVideoInsideActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class KFVLogoutButtonErrorState extends KidsFoodVideoInsideActionState {
  final String error;
  KFVLogoutButtonErrorState({required this.error});
}

class KFVInsideUpdatingRatingStarButtonLoadingState extends KidsFoodVideoInsideActionState {}

class KFVInsideUpdatingRatingStarButtonLoadedSuccessState extends KidsFoodVideoInsideActionState {
  final double? rating ;
  final int? videoID ;
  KFVInsideUpdatingRatingStarButtonLoadedSuccessState({required this.rating,required this.videoID});
}

class KFVInsideUpdatingRatingStarButtonErrorState extends KidsFoodVideoInsideActionState {
  final String error;
  KFVInsideUpdatingRatingStarButtonErrorState({required this.error});
}
