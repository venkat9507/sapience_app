part of 'lkg_bloc.dart';

@immutable
abstract class LkgEvent {}

class LkgInitialEvent extends LkgEvent {
  final int? sectionID ;
  LkgInitialEvent({this.sectionID});
}

class LkgChangingTheColorEvent extends LkgEvent {
  final int? index ;
  final bool? isRightButton ;
  LkgChangingTheColorEvent({this.index,this.isRightButton,});
}

class LkgChangingTheDrawerColorEvent extends LkgEvent {
  final int? index ;
  final List<DashboardList>? dashboardList;
  final List<VideoCategoriesList>? lkgProducts ;
  final int? sectionID ;

  LkgChangingTheDrawerColorEvent({this.index,this.dashboardList,this.lkgProducts,this.sectionID});
}

class LkgNavigateButtonEvent extends LkgEvent {
  final int? sectionID;
  final int? videoCatID;
  final String? title;
  final bool? isLkgFoodCategory;
  LkgNavigateButtonEvent({this.sectionID,this.videoCatID,this.title,this.isLkgFoodCategory});

}

class LkgFoodNavigateButtonEvent extends LkgEvent {
  final int? sectionID;
  final int? foodCatID;
  final String? title;
  LkgFoodNavigateButtonEvent({this.sectionID,this.foodCatID,this.title});

}

class LkgBackNavigateButtonEvent extends LkgEvent {}

class LogoutLkgEvent  extends LkgEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}