import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<SplashScreenInitialEvent>(splashScreenInitialEvent);
  }

  Future<FutureOr<void>> splashScreenInitialEvent(SplashScreenInitialEvent event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenMainState());
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      await Future.delayed(const Duration(milliseconds: 1000 ));
      if(token != null){
        emit(SplashScreenLoadedState(isLogin: false));
      }
      else
        {
          emit(SplashScreenLoadedState(isLogin: true));
        }

    }
    catch(e){
      emit(SplashScreenErrorState(error: e.toString()));
    }

  }
}
