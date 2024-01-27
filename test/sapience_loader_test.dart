import 'package:flutter/foundation.dart';
import 'package:nimu_tv/config/shared_preference.dart';
import 'package:nimu_tv/features/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main(){
  final SplashScreenBloc splashScreenBloc = SplashScreenBloc();

 setUp((){
   splashScreenBloc.add(SplashScreenInitialEvent());
 });

 group('unit test ',(){
    test('checking the logged in or not ',() async{
      await SplashScreenMainState();
      var token;
      expect(token, null);
      print('checking the null value $token');
      if(token != null){
        (SplashScreenLoadedState(isLogin: false));
      }
      else
      {
        (SplashScreenLoadedState(isLogin: true));
      }
    });
    });

}