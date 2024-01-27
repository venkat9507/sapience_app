part of 'lkg_bloc.dart';

@immutable
abstract class LkgState {}

class LkgInitial extends LkgState {}

abstract class LkgActionState extends LkgState {}

class LkgInitialLoadingState extends LkgState {}

class LkgInitialLoadedSuccessState extends LkgState {
  final List<VideoCategoriesList>? lkgProducts ;
  final List<FoodCategoryList>? foodCategoryProducts ;
  final  List<DashboardList>? dashboardList;
  LkgInitialLoadedSuccessState({this.lkgProducts, this.dashboardList,this.foodCategoryProducts});
}

class LkgInitialErrorState extends LkgState {
  final String? error;
  LkgInitialErrorState({required this.error});
}


class LkgActionButtonState extends LkgActionState {
  final int? sectionID;
  final int? videoCatID;
  final String? title;
  final bool? isLkgFoodCategory;
  LkgActionButtonState({this.videoCatID,this.sectionID,this.title,this.isLkgFoodCategory});
}

class LkgFoodActionButtonState extends LkgActionState {
  final int? sectionID;
  final int? foodCatID;
  final String? title;
  LkgFoodActionButtonState({this.foodCatID,this.sectionID,this.title});
}

class LkgBackActionButtonState extends LkgActionState {}

class LkgDrawerActionButtonState extends LkgActionState {
  final int? index;
  final int? sectionID;
  LkgDrawerActionButtonState({this.index,this.sectionID});
}


class LkgLogoutButtonLoadingState extends LkgActionState {}

class LkgLogoutButtonLoadedSuccessState extends LkgActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class LkgLogoutButtonErrorState extends LkgActionState {
  final String error;
  LkgLogoutButtonErrorState({required this.error});
}