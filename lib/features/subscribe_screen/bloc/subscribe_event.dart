part of 'subscribe_bloc.dart';

@immutable
abstract class SubscribeEvent {}

class SubscribeInitialEvent extends SubscribeEvent {
  final List<SubscribeDatum>? subscribeModels ;
  final int? sectionID ;
  SubscribeInitialEvent({this.subscribeModels,this.sectionID});
}

class SubscribeChangingTheColorEvent extends SubscribeEvent {
  final int? index ;
  SubscribeChangingTheColorEvent({this.index,});
}

class SubscribeNavigateButtonEvent extends SubscribeEvent {
  final String? title;
  final String? price;
  SubscribeNavigateButtonEvent({this.title,this.price});
}
class SubscribeBackNavigateButtonEvent extends SubscribeEvent {}
