import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/dttc_screen/api/dttc_api.dart';
import 'package:nimu_tv/features/dttc_screen/database_items/item_data.dart';
import 'package:nimu_tv/features/dttc_screen/dttc_model/dttc_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../dashboard_screen/api/dashboard_api.dart';
import '../../dashboard_screen/dashboard_model/dashboard_model.dart';
import '../../dashboard_screen/database_items/items_data.dart';

part 'dttc_event.dart';
part 'dttc_state.dart';

class DttcBloc extends Bloc<DttcEvent, DttcState> {
  DttcBloc() : super(DttcInitial()) {
    on<DTTCInitialEvent>(dTTCInitialEvent);
    on<DTTCChangingTheDrawerColorEvent>(dttcChangingTheDrawerColorEvent);
    on<DTTCNavigateButtonEvent>(dttcNavigateButtonEvent);
    on<DTTCBackNavigateButtonEvent>(dttcBackNavigateButtonEvent);
    on<LogoutDTTCEvent>(logoutEvent);

  }

  Future<FutureOr<void>> logoutEvent(
      LogoutDTTCEvent event, Emitter<DttcState> emit) async {


    emit(DTTCLogoutButtonLoadingState());


    try {
      bool logout = await DashboardApi.logout();
      await Future.delayed(const Duration(milliseconds: 100));
      if(logout){
        emit(DTTCLogoutButtonLoadedSuccessState());
      }
      else
      {
        emit(DTTCLogoutButtonErrorState(error: 'error occurred while logout'));
      }

    } catch (e) {
      emit(DTTCLogoutButtonErrorState(error: 'error occurred while logout'));

    }
  }

  FutureOr<void> dttcNavigateButtonEvent(DTTCNavigateButtonEvent event, Emitter<DttcState> emit) {
    emit(DTTCActionButtonState(
      title: event.title,
      term: event.term,
      sectionID: event.sectionID
    ));
  }

  FutureOr<void> dttcBackNavigateButtonEvent(DTTCBackNavigateButtonEvent event, Emitter<DttcState> emit) {
    emit(DTTCBackActionButtonState());
  }

  Future<FutureOr<void>> dttcChangingTheDrawerColorEvent(
      DTTCChangingTheDrawerColorEvent event, Emitter<DttcState> emit) async {

    for(var item in event.dashboardList! ){
      item.isSelected = false;
    }
    event.dashboardList![event.index!-1].isSelected = true;

    try {
      emit(DTTCLoadedSuccessState(
        dttcList: event.dttcList!,
        dashboardList: dashboardModel!.data,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(DTTCDrawerActionButtonState(index: event.index,sectionID: event.sectionID));
    } catch (e) {
      emit(DTTCErrorState(error: 'error ${e.toString()}'));
    }
  }

  Future<FutureOr<void>> dTTCInitialEvent(DTTCInitialEvent event, Emitter<DttcState> emit) async {
    var responseValue;

    emit( DTTCLoadingState());

    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the token value $token');

      Response   response = await DTTCApi.getDTTCSections(token: token);

      responseValue = json.decode(response.body);
      dttcModel = DTTCModel.fromJson(responseValue);

      print('error value ');

      if(response.statusCode == 200){

        // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
        // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(DTTCLoadedSuccessState(
          dttcList: dttcModel!.data,
          dashboardList: dashboardModel!.data,
        ));
      }
      else
      {
        emit(DTTCErrorState(error: dttcModel!.message));
      }


      // print('isLoggedIn $isLoggedIn');
    } catch (e) {
      emit(DTTCErrorState(error: dttcModel!.message));
    }
  }
}
