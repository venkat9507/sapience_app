part of 'dttc_bloc.dart';

@immutable
abstract class DttcEvent {}

class DTTCInitialEvent extends DttcEvent {
  final int? sectionID ;
  DTTCInitialEvent({this.sectionID});
}

class DTTCChangingTheDrawerColorEvent extends DttcEvent {
  final int? index ;
  final List<DTTCList>? dttcList;
  final int? sectionID ;
  final List<DashboardList>? dashboardList;
  DTTCChangingTheDrawerColorEvent({this.index,this.dttcList,this.sectionID,this.dashboardList});
}

class DTTCNavigateButtonEvent extends DttcEvent {
  final int? sectionID;
  final String? term;
  final String? title;
  DTTCNavigateButtonEvent({this.sectionID,this.term,this.title});

}
class DTTCBackNavigateButtonEvent extends DttcEvent {}

class LogoutDTTCEvent  extends DttcEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}