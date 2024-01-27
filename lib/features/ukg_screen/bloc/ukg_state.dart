part of 'ukg_bloc.dart';




@immutable
abstract class UkgState {}

class UkgInitial extends UkgState {}

abstract class UkgActionState extends UkgState {}

class UkgInitialLoadingState extends UkgState {}

class UkgInitialLoadedSuccessState extends UkgState {
  final List<VideoCategoriesList>? ukgProducts ;
  final  List<DashboardList>? dashboardList;
  UkgInitialLoadedSuccessState({this.ukgProducts, this.dashboardList});
}

class UkgInitialErrorState extends UkgState {
  final String? error;
  UkgInitialErrorState({required this.error});
}


class UkgActionButtonState extends UkgActionState {
  final int? sectionID;
  final int? videoCatID;
  final String? title;
  final bool? isLkgFoodCategory;
  UkgActionButtonState({this.videoCatID,this.sectionID,this.title,this.isLkgFoodCategory});
}

class UkgBackActionButtonState extends UkgActionState {}

class UkgDrawerActionButtonState extends UkgActionState {
  final int? index;
  final int? sectionID;
  UkgDrawerActionButtonState({this.index,this.sectionID});
}


class UkgLogoutButtonLoadingState extends UkgActionState {}

class UkgLogoutButtonLoadedSuccessState extends UkgActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class UkgLogoutButtonErrorState extends UkgActionState {
  final String error;
  UkgLogoutButtonErrorState({required this.error});
}