import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/dashboard_screen/api/dashboard_api.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/local_database.dart';
import 'package:nimu_tv/features/video/features/database/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../../data/user_data_api/user_data_api.dart';
import '../../../food_inside_screen/database_items/local_database.dart';
import '../../../food_video/features/database/local_database.dart';
import '../../food_categories/database/lkg_local_database.dart';
import '../../food_categories/database/ukg_local_database.dart';
import '../../food_days_screen/database_items/local_database.dart';
import '../../food_types_screen/database_items/local_database.dart';
import '../../lkg_inside_screen/database_items/local_database.dart';
import '../../lkg_screen/database_items/local_database.dart';
import '../../login_screen/database/create_user_doc.dart';
import '../../login_screen/database/local_database.dart';
import '../../ukg_inside_screen/database_items/local_database.dart';
import '../../ukg_screen/database_items/local_database.dart';
import '../dashboard_model/dashboard_model.dart';

part 'dashboard_screen_event.dart';
part 'dashboard_screen_state.dart';

class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc() : super(DashboardScreenInitial()) {
    on<DashboardInitialScreenEvent>(dashboardInitialScreenEvent);
    on<DashboardNavigateButtonEvent>(dashboardNavigateButtonEvent);
    on<DashboardBackNavigateButtonEvent>(dashboardBackNavigateButtonEvent);
    on<DashboardChangingTheColorEvent>(dashboardChangingTheColorEvent);
    on<LogoutEvent>(logoutEvent);

  }

  Future<FutureOr<void>> logoutEvent(
      LogoutEvent event, Emitter<DashboardScreenState> emit) async {


    emit(DashboardLogoutButtonLoadingState());


    try {
      bool logout = await DashboardApi.logout();
      await Future.delayed(const Duration(milliseconds: 100));
      if(logout){

        SharedPreferences preferences = await sharedPref();
        preferences.remove('mobileNo',);
        preferences.remove('token', );
        preferences.remove('created_at', );
        preferences.remove('updated_at', );
        preferences.remove('role', );
        preferences.remove('otp', );
        preferences.remove('isLoggedIn',);
        preferences.remove('user_subscription', );
        preferences.remove('isLKGAvailable',);
        preferences.remove('isUKGAvailable',);
        preferences.remove('isKidsFoodVideoAvailable',);


     await   LocalUserDatabase.instance.deleteUser();
        await   LocalDashboardDatabase.instance.deleteDashboard();
        await    LocalUKGDatabase.instance.deleteUKG();
        await    LocalLKGDatabase.instance.deleteLKG();
        await     LocalUKGInsideDatabase.instance.deleteUKGInside();
        await     LocalLKGInsideDatabase.instance.deleteLKGInside();
        await     LocalFoodInsideDatabase.instance.deleteFoodInside();
        await LocalVideoDatabase.instance.deleteVideo();
        await LocalFoodTypesDatabase.instance.deleteFoodTypes();
        await LocalFoodDaysDatabase.instance.deleteFoodDays();
        await LocalFoodVideoDatabase.instance.deleteFoodVideo();
        await LocalFoodLKGCategoryDatabase.instance.deleteFoodLKGCategory();
        await LocalFoodUKGCategoryDatabase.instance.deleteFoodUKGCategory();

        emit(DashboardLogoutButtonLoadedSuccessState());
      }
      else
        {
          emit(DashboardLogoutButtonErrorState(error: 'error occurred while logout'));
        }

    } catch (e) {
      emit(DashboardLogoutButtonErrorState(error: 'error occurred while logout'));

    }
  }


  Future<FutureOr<void>> dashboardChangingTheColorEvent(
      DashboardChangingTheColorEvent event, Emitter<DashboardScreenState> emit) async {

    debugPrint('checking the event index ${event.index} ');

    for(var item in event.dashboardList! ){
      item.isSelected = false;
      debugPrint('checking the event very closely ${item.index} ${item.name}');
    }

    // debugPrint('item name  ${event.dashboardList![event.index!].name} item index  ${event.dashboardList![event.index!].index}');
    event.dashboardList![1].isSelected = true;

    // for(var item in event.dashboardList! ){
    //   // item.isSelected = false;
    //   debugPrint('checking the event very closely selected ${item.isSelected} ${item.name}');
    // }
    //
    // debugPrint('selected index data isSelected event index ${event.index} ${event.dashboardList![event.index!].isSelected} name ${event.dashboardList![event.index!].name} index ${event.dashboardList![event.index!].index}');

    try {
      emit(DashboardLoadedSuccessState(
          dashboardList: event.dashboardList!,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(DashboardActionButtonState(index: event.index,sectionID: event.sectionID));
    } catch (e) {
      emit(DashboardErrorState(error: 'error $e'));
    }
  }




  FutureOr<void> dashboardNavigateButtonEvent(
      DashboardNavigateButtonEvent event, Emitter<DashboardScreenState> emit) {
    emit(DashboardActionButtonState());
  }

  FutureOr<void> dashboardBackNavigateButtonEvent(
      DashboardBackNavigateButtonEvent event, Emitter<DashboardScreenState> emit) {
    emit(DashboardBackActionButtonState());
  }

  Future<FutureOr<void>> dashboardInitialScreenEvent(DashboardScreenEvent event, Emitter<DashboardScreenState> emit) async {
    SharedPreferences preferences = await sharedPref();
    var responseValue;
    final String? token = preferences.getString('token');
    mobileNo = preferences.getInt('mobileNo');
    emit(DashboardLoadingState());
    print('checking the dashboard modal ${dashboardModel == null ? true : false}');

    if ( dashboardModel != null) {
      print('checking the dashboard modal ');
      var isLKGAvailable = preferences.getBool('isLKGAvailable',);
      var isUKGAvailable = preferences.getBool('isUKGAvailable',);
      var isKidsFoodVideoAvailable = preferences.getBool(
        'isKidsFoodVideoAvailable',);

      print('isUKGAvailable  at dashboard ${isUKGAvailable}');
      print('isLKGAvailable  at dashboard ${isLKGAvailable}');
      print(
          'isKidsFoodVideoAvailable  at dashboard ${isKidsFoodVideoAvailable}');

      if (isLKGAvailable == false || isLKGAvailable == null) {
        for (var i = 0; i < dashboardModel!.data.length; i++) {
          if (dashboardModel!.data[i].name.contains('LKG')) {
            dashboardModel!.data.removeAt(i);
          }
        }
      }
      if (isUKGAvailable == false || isUKGAvailable == null) {
        for (var i = 0; i < dashboardModel!.data.length; i++) {
          if (dashboardModel!.data[i].name.contains('UKG')) {
            dashboardModel!.data.removeAt(i);
          }
        }
      }
      if (isKidsFoodVideoAvailable == false ||
          isKidsFoodVideoAvailable == null) {
        for (var i = 0; i < dashboardModel!.data.length; i++) {
          if (dashboardModel!.data[i].name.contains('KIDS FOOD VIDEO')) {
            dashboardModel!.data.removeAt(i);
          }
        }
      }


      for (var i = 0; i < dashboardModel!.data.length; i++) {
        if (dashboardModel!.data[i].name.contains('KIDS FOOD VIDEO')) {
          dashboardModel!.data.removeAt(i);
        }
      }


      print('checking the dashboard before emit');
      dashboardModel!.data.sort((a, b) => a.index.compareTo(b.index));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DashboardLoadedSuccessState(
          dashboardList: dashboardModel!.data
      ));
    }
    else
      {

    try {
      SharedPreferences preferences = await sharedPref();

      debugPrint(' checking the token value $token');

      Response response = await DashboardApi.getDashboardSections(token: token);
       await UserDataApi.getUserApi(token: token);

      LocalDashboardDatabase.instance.createDashboard(dashboardModelFromJson(response.body));

      // responseValue = json.decode(response.body);
      // dashboardModel = DashboardModel.fromJson(responseValue);


      // print('checking the response 2 value status code ${response2.statusCode} '
      //     'checking the user data ${userData!.data.subscriptionList}');

await     Future.delayed(Duration(seconds: 1),() async {
       if (response.statusCode == 200) {
         var isLKGAvailable = preferences.getBool('isLKGAvailable',);
         var isUKGAvailable = preferences.getBool('isUKGAvailable',);
         var isKidsFoodVideoAvailable = preferences.getBool(
           'isKidsFoodVideoAvailable',);

         print('isUKGAvailable  at dashboard ${isUKGAvailable}');
         print('isLKGAvailable  at dashboard ${isLKGAvailable}');
         print(
             'isKidsFoodVideoAvailable  at dashboard ${isKidsFoodVideoAvailable}');


         if (isLKGAvailable == false || isLKGAvailable == null) {
           for (var i = 0; i < dashboardModel!.data.length; i++) {
             if (dashboardModel!.data[i].name.contains('LKG')) {
               dashboardModel!.data.removeAt(i);
             }
           }
         }
         if (isUKGAvailable == false || isUKGAvailable == null) {
           for (var i = 0; i < dashboardModel!.data.length; i++) {
             if (dashboardModel!.data[i].name.contains('UKG')) {
               dashboardModel!.data.removeAt(i);
             }
           }
         }
         // if (isKidsFoodVideoAvailable == false ||
         //     isKidsFoodVideoAvailable == null) {
         //   for (var i = 0; i < dashboardModel!.data.length; i++) {
         //     if (dashboardModel!.data[i].name.contains('KIDS FOOD VIDEO')) {
         //       dashboardModel!.data.removeAt(i);
         //     }
         //   }
         // }

         for (var i = 0; i < dashboardModel!.data.length; i++) {
           if (dashboardModel!.data[i].name.contains('KIDS FOOD VIDEO')) {
             dashboardModel!.data.removeAt(i);
           }
         }

         // dashboardModel!.data.add(
         //     DashboardList(index: 3,
         //         name: 'Scan QR',
         //         active: 1,
         //         isSelected: false,
         //         description: null,
         //         createdAt: null,
         //         updatedAt: null,
         //     ));
         // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));

         print('checking the dashboard before emit');
         dashboardModel!.data.sort((a, b) => a.index.compareTo(b.index));
         // await Future.delayed(const Duration(milliseconds: 500));
         emit(DashboardLoadedSuccessState(
             dashboardList: dashboardModel!.data
         ));
       }
       else {


         emit(DashboardErrorState(error: dashboardModel!.message));
       }
     });


      // print('isLoggedIn $isLoggedIn');
    } catch (e) {
      emit(DashboardErrorState(error: dashboardModel!.message));
    }
  }




  // emit(DashboardErrorState(error: 'error'));

  }
}
