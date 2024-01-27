part of 'subscribe_bloc.dart';

@immutable
abstract class SubscribeState {}

class SubscribeInitial extends SubscribeState {}



abstract class SubscribeActionState extends SubscribeState {}

class SubscribeInitialLoadingState extends SubscribeState {}

class SubscribeInitialLoadedSuccessState extends SubscribeState {
  final List<SubscribeDatum>? subscribeModels ;
  SubscribeInitialLoadedSuccessState({this.subscribeModels});
}

class SubscribeInitialErrorState extends SubscribeState {
  final String? error;
  SubscribeInitialErrorState({required this.error});
}


class SubscribeActionButtonState extends SubscribeActionState {
  final String? title;
  final String? price;
  SubscribeActionButtonState({this.title,this.price});
}

class SubscribeBackActionButtonState extends SubscribeActionState {}

