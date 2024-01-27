part of 'dashboard_screen_bloc.dart';

@immutable
abstract class DashboardScreenEvent {}


class DashboardInitialScreenEvent extends DashboardScreenEvent {}

class DashboardNavigateButtonEvent extends DashboardScreenEvent {
  // DashboardNavigateButtonEvent({this.title,this.price});
}
class DashboardBackNavigateButtonEvent extends DashboardScreenEvent {}


class DashboardChangingTheColorEvent extends DashboardScreenEvent {
  final int? index ;
  final int? sectionID ;
  final List<DashboardList>? dashboardList;
  DashboardChangingTheColorEvent({this.index,this.dashboardList,this.sectionID});
}

class DashboardApiCallingEvent  extends DashboardScreenEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}

class LogoutEvent  extends DashboardScreenEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}