part of 'dttc_inside_bloc.dart';

@immutable
abstract class DTTCInsideEvent {}

class DTTCInsideInitialEvent extends DTTCInsideEvent {
  final int? sectionID ;
  final String? term ;
  final String? title;
  // final List<DTTCInsideModelList>? dttcInsideProducts ;
  DTTCInsideInitialEvent({this.sectionID,this.term,this.title});
}

class DTTCInsideChangingTheColorEvent extends DTTCInsideEvent {
  final int? index ;
  final bool? isRightButton ;
  final List<DTTCInsideModelList>? dttcInsideProducts ;
  DTTCInsideChangingTheColorEvent({this.index,this.isRightButton,this.dttcInsideProducts});
}

class DTTCInsideUpdatingRatingStarEvent extends DTTCInsideEvent {
  final double? rating ;
  final int? videoID ;
  DTTCInsideUpdatingRatingStarEvent({this.rating,this.videoID,});
}

class DTTCInsideNavigateButtonEvent extends DTTCInsideEvent {
  final int? videoID;

  DTTCInsideNavigateButtonEvent({this.videoID});

}
class DTTCInsideBackNavigateButtonEvent extends DTTCInsideEvent {}
