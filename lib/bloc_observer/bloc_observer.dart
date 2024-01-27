 // ignore_for_file: avoid_print
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:nimu_tv/config/audio_player.dart';
import 'package:nimu_tv/local_download/isolates_download.dart';

import '../config/check_internet_connection.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    print('checking the print event ${event} '
        'checkig the bloc ${bloc.toString()}');
    // Instance of 'VideoBloc'


    if(event.toString() == "Instance of 'DashboardInitialScreenEvent'"){
      CheckInternetConnection.instance.checkInternet().then((value) {
        if (value.toString() != 'none') {
          downloadLocally();
        }
      });
    }

    if(bloc.toString() == "Instance of 'VideoBloc'"
        || bloc.toString() == "Instance of 'FoodVideoBloc'"
    ){
      // musicStop();
      print('checking observer catching instance of video bloc');
      isPlayerNeededToPlay = false;
      player.stop();
    }
    else
      {
        print('checking the player state ${player.state}'
            'isBackgroundMuted.value ${isBackgroundMuted.value}');
       if(player.state == PlayerState.stopped && isBackgroundMuted.value == false){
         isPlayerNeededToPlay = true;
         musicStart();
       }
      }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print('checking the print error $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    print('checking the print change $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print('transition $transition');
  }

  ///We can even run something, when we close our Bloc
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print("BLOC is closed");
  }
}
