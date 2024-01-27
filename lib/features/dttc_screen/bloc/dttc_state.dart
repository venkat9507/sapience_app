part of 'dttc_bloc.dart';

@immutable
abstract class DttcState {}

abstract class DttcActionState extends DttcState {}

class DttcInitial extends DttcState {}

class DTTCInitialState extends DttcState {}


class DTTCLoadingState extends DttcState {}

class DTTCLoadedSuccessState extends DttcState {
  final  List<DTTCList>? dttcList;
  final  List<DashboardList>? dashboardList;
  DTTCLoadedSuccessState({this.dttcList,this.dashboardList});
}

class DTTCErrorState extends DttcState {
  final String error;
  DTTCErrorState({required this.error, });
}

class DTTCDrawerActionButtonState extends DttcState {
  final int? index;
  final int? sectionID ;
  DTTCDrawerActionButtonState({this.index,this.sectionID});
}

class DTTCActionButtonState extends DttcActionState {
  final int? sectionID;
  final String? term;
  final String? title;
  // final String? price;
  DTTCActionButtonState({this.term,this.title,this.sectionID});
}

class DTTCBackActionButtonState extends DttcActionState {}

class DTTCLogoutButtonLoadingState extends DttcActionState {}

class DTTCLogoutButtonLoadedSuccessState extends DttcActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class DTTCLogoutButtonErrorState extends DttcActionState {
  final String error;
  DTTCLogoutButtonErrorState({required this.error});
}
