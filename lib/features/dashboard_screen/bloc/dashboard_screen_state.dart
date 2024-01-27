part of 'dashboard_screen_bloc.dart';

@immutable
abstract class DashboardScreenState {}

abstract class DashboardScreenActionState  extends DashboardScreenState{}

class DashboardScreenInitial extends DashboardScreenState {}
class DashboardScreenInitialState extends DashboardScreenState {}


class DashboardLoadingState extends DashboardScreenState {}

class DashboardLoadedSuccessState extends DashboardScreenState {
 final  List<DashboardList> dashboardList;
  DashboardLoadedSuccessState({required this.dashboardList});
}

class DashboardErrorState extends DashboardScreenState {
  final String error;
  DashboardErrorState({required this.error, });
}

class DashboardActionButtonState extends DashboardScreenActionState {
  final int? index;
  final int? sectionID;
  // final String? price;
  DashboardActionButtonState({this.index,this.sectionID});
}

class DashboardBackActionButtonState extends DashboardScreenActionState {}


class DashboardLogoutButtonLoadingState extends DashboardScreenActionState {}

class DashboardLogoutButtonLoadedSuccessState extends DashboardScreenActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class DashboardLogoutButtonErrorState extends DashboardScreenActionState {
  final String error;
  DashboardLogoutButtonErrorState({required this.error});
}


// class BarCodeAddingButtonLoadingState extends LoginActionState {}
//
// class BarCodeAddingButtonLoadedSuccessState extends LoginActionState {
//   // final String qrCode;
//   // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
// }
//
// class BarCodeAddingButtonErrorState extends LoginActionState {
//   final String error;
//   BarCodeAddingButtonErrorState({required this.error});
// }
