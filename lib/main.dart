// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//
//   SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
//       .then((value) => runApp(const MyWebsite()));
// }
//
// class MyWebsite extends StatefulWidget {
//   const MyWebsite({Key? key}) : super(key: key);
//
//   @override
//   State<MyWebsite> createState() => _MyWebsiteState();
// }
//
// class _MyWebsiteState extends State<MyWebsite> {
//
//   double _progress = 0;
//   late InAppWebViewController  inAppWebViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: ()async{
//
//         var isLastPage = await inAppWebViewController.canGoBack();
//
//         if(isLastPage){
//           inAppWebViewController.goBack();
//           return false;
//         }
//
//         return true;
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: SafeArea(
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 InAppWebView(
//                   initialUrlRequest: URLRequest(
//                       url: Uri.parse("https://marypouline.com/")
//                   ),
//                   onWebViewCreated: (InAppWebViewController controller){
//                     inAppWebViewController = controller;
//                   },
//                   onProgressChanged: (InAppWebViewController controller , int progress){
//                     setState(() {
//                       _progress = progress / 100;
//                     });
//                   },
//                 ),
//                 _progress < 1 ? Container(
//                   child: LinearProgressIndicator(
//                     value: _progress,
//                   ),
//                 ):SizedBox()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nimu_tv/config/no_internet_connection.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/local_database.dart';
import 'package:nimu_tv/features/food_categories/database/lkg_local_database.dart';
import 'package:nimu_tv/features/food_types_screen/database_items/local_database.dart';
import 'package:nimu_tv/features/food_types_screen/view/food_types_screen.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/login_screen/database/local_database.dart';
import 'package:nimu_tv/features/ukg_inside_screen/database_items/local_database.dart';
import 'package:nimu_tv/features/ukg_screen/database_items/local_database.dart';
import 'package:nimu_tv/features/video/features/database/local_database.dart';
import 'package:nimu_tv/food_inside_screen/view/food_inside_screen.dart';
import 'package:nimu_tv/food_video/features/database/local_database.dart';
import 'config/check_internet_connection.dart';
import 'config/image_picker_scanner.dart';
import 'features/food_categories/database/ukg_local_database.dart';
import 'features/food_days_screen/database_items/local_database.dart';
import 'features/food_days_screen/view/food_days_screen.dart';
import 'features/lkg_inside_screen/database_items/local_database.dart';
import 'features/lkg_screen/database_items/local_database.dart';
import 'firebase_options.dart';
import 'package:nimu_tv/features/dashboard_screen/view/dashboard_screen.dart';
import 'package:nimu_tv/features/lkg_screen/view/lkg_screen.dart';
import 'package:nimu_tv/features/login_screen/view/login_screen_view.dart';
import 'package:nimu_tv/features/splash_screen/view/splash_screen_view.dart';
import 'package:nimu_tv/video_player.dart';
import 'bloc_observer/bloc_observer.dart';
import 'config/audio_player.dart';
import 'config/constants.dart';
import 'config/method_channel.dart';
import 'features/dttc_screen/view/dttc_screen.dart';
import 'features/kids_food_video_inside_screen/view/kids_food_video_inside_screen.dart';
import 'features/lkg_inside_screen/view/lkg_inside_screen.dart';
import 'features/subscribe_screen/view/subscribe_screen_view.dart';
import 'features/ukg_inside_screen/view/ukg_inside_screen.dart';
import 'features/ukg_screen/view/ukg_screen.dart';
import 'food_inside_screen/database_items/local_database.dart';
import 'views/home_page.dart';

var PlatformType = MyPlatform();

checkingTheTv() async {
  PlatformType.tvType = await false.findingTheAndroidDevice;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = const AppBlocObserver();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);

  checkingTheTv();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  RxString? internetStatus = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    LocalUserDatabase.instance.getUser();
    LocalDashboardDatabase.instance.getDashboard();
    LocalFoodTypesDatabase.instance.getFoodTypes();

    LocalUKGDatabase.instance.getUKG();
    LocalLKGDatabase.instance.getLKG();
    LocalFoodLKGCategoryDatabase.instance.getFoodLKGCategory();
    LocalFoodUKGCategoryDatabase.instance.getFoodUKGCategory();
    LocalUKGInsideDatabase.instance.getUKGInside();
    LocalFoodInsideDatabase.instance.getFoodInside();
    LocalLKGInsideDatabase.instance.getLKGInside();
    LocalVideoDatabase.instance.getVideo();
    LocalFoodDaysDatabase.instance.getFoodDays();
    LocalFoodVideoDatabase.instance.getFoodVideo();

    // print('getting local database token ${u serData!.data.token}');

    // musicStart();

    // player.onPlayerComplete.listen((event) {
    //   musicStart();
    // });


    CheckInternetConnection.instance.checkInternet().then((value) {
      print('v--> ${value.toString()}');
      if (value.toString() == 'none') {
        internetStatus!.value = value.toString();
      }
      // else {
      //   val.value =  'Error ';
      // }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('Current state = $state');
    // print('image pickup ${ImagePickerScanner.pickImage()}');

    if (state == AppLifecycleState.paused) {
      player.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (player.state == PlayerState.stopped &&
          isPlayerNeededToPlay == true &&
          isBackgroundMuted.value == false) {
        musicStart();
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Connectivity example app'),
  //       elevation: 4,
  //     ),

  // }

  Widget build(BuildContext context) {

    debugInvertOversizedImages = true;


    return GetMaterialApp(
      // title: 'Nimu TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:  Video(),
      // home:  MyHomePage(),
      // home:  LoginScreenView(),
      // home:  const DttcScreenView(),
      // home:  const DashboardScreenView(),

      // home: const KidsFoodVideoInsideScreenView(),
      // home: const ukgInsideScreenView(),
      // home: const LkgInsideScreenView(),
      // home: const ukgScreenView(),
      // home: const SubscribeScreenView(),
      // home: const LkgScreenView(),
      home: Obx(() {
        return Scaffold(
          body:
          internetStatus!.value != 'none' ?
          SplashScreenView() : SplashScreenView(),
          // body:
          // SplashScreenView()
          // FoodTypesScreenView(title: 'Healthy meals',)
          // FoodDaysScreenView(title: 'Break Fast',)
          // FoodInsideScreenView(title: 'BreakFast - Day:1',foodCatID: 1,foodDayID: 1,foodTypeID: 1,sectionID: 1,)

          // Center(
          //     child: Text('Connection Status: ${_connectionStatus.toString().replaceAll('ConnectivityResult.', '')}')),
        );
      }),
      // body: const SplashScreenView()),
    );
  }
}
