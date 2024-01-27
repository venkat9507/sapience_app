import 'dart:developer'as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class CheckInternetConnection {
  CheckInternetConnection._privateConstructor();
  static final  CheckInternetConnection instance = CheckInternetConnection._privateConstructor();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();


 Future checkInternet() async{
   ConnectivityResult res = await initConnectivity();

    return res.name;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<ConnectivityResult> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);

    }



    return result;
  }

}