part of 'splash_screen_bloc.dart';

@immutable
abstract class SplashScreenState {}

class SplashScreenInitial extends SplashScreenState {}


abstract class SplashScreenActionState extends  SplashScreenState {}

class SplashScreenMainState extends SplashScreenState {}


class SplashScreenLoadedState extends SplashScreenActionState {
  final bool? isLogin;
  SplashScreenLoadedState({required this.isLogin});
}

class SplashScreenErrorState extends SplashScreenActionState {
  final String? error;
  SplashScreenErrorState({required this.error});
}