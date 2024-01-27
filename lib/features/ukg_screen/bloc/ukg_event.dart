part of 'ukg_bloc.dart';

// import 'package:flutter/material.dart';

@immutable
abstract class UkgEvent {}

class UkgInitialEvent extends UkgEvent {
  final int? sectionID ;
  UkgInitialEvent({this.sectionID});
}

class UkgChangingTheColorEvent extends UkgEvent {
  final int? index ;
  final bool? isRightButton ;
  UkgChangingTheColorEvent({this.index,this.isRightButton,});
}

class UkgChangingTheDrawerColorEvent extends UkgEvent {
  final int? index ;
  final List<DashboardList>? dashboardList;
  final List<VideoCategoriesList>? ukgProducts ;
  final int? sectionID ;

  UkgChangingTheDrawerColorEvent({this.index,this.dashboardList,this.ukgProducts,this.sectionID});
}

class UkgNavigateButtonEvent extends UkgEvent {
  final int? sectionID;
  final int? videoCatID;
  final String? title;
  final bool? isLkgFoodCategory;
  UkgNavigateButtonEvent({this.sectionID,this.videoCatID,this.title,this.isLkgFoodCategory});

}
class UkgBackNavigateButtonEvent extends UkgEvent {}

class LogoutUkgEvent  extends UkgEvent{
  // final String qrCode;
  // DashboardApiCallingEvent({required this.qrCode,});

}