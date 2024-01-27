import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/food_categories/api/food_category_api.dart';
import 'package:nimu_tv/features/food_categories/database/item_data.dart';
import 'package:nimu_tv/features/lkg_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/lkg_screen/models/lkg_models.dart';
import 'package:nimu_tv/features/video_categories/api/video_category_api.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/color_const.dart';
import '../../../../config/shared_preference.dart';
import '../../../../main.dart';
import '../../../dashboard_screen/api/dashboard_api.dart';
import '../../../dashboard_screen/dashboard_model/dashboard_model.dart';
import '../../../dashboard_screen/database_items/items_data.dart';
import '../../../food_categories/database/lkg_local_database.dart';
import '../../../food_categories/models/food_category_models.dart';
import '../../../video_categories/model/video_category_model.dart';
import '../../database_items/local_database.dart';

part 'lkg_event.dart';
part 'lkg_state.dart';

class LkgBloc extends Bloc<LkgEvent, LkgState> {
  LkgBloc() : super(LkgInitial()) {
    on<LkgInitialEvent>(lkgInitialEvent);
    on<LkgChangingTheColorEvent>(lkgChangingTheColorEvent);
    on<LkgChangingTheDrawerColorEvent>(lkgChangingTheDrawerColorEvent);
    on<LkgNavigateButtonEvent>(lkgNavigateButtonEvent);
    // on<LkgNavigateButtonEvent>(lkgNavigateButtonEvent);
    on<LkgBackNavigateButtonEvent>(lkgBackNavigateButtonEvent);
    on<LogoutLkgEvent>(logoutEvent);
  }

  Future<FutureOr<void>> logoutEvent(
      LogoutLkgEvent event, Emitter<LkgState> emit) async {


    emit(LkgLogoutButtonLoadingState());


    try {
      bool logout = await DashboardApi.logout();
      await Future.delayed(const Duration(milliseconds: 100));
      if(logout){
        emit(LkgLogoutButtonLoadedSuccessState());
      }
      else
      {
        emit(LkgLogoutButtonErrorState(error: 'error occurred while logout'));
      }

    } catch (e) {
      emit(LkgLogoutButtonErrorState(error: 'error occurred while logout'));

    }
  }


  Future<FutureOr<void>> lkgChangingTheDrawerColorEvent(
      LkgChangingTheDrawerColorEvent event, Emitter<LkgState> emit) async {

    for(var item in event.dashboardList! ){
      item.isSelected = false;
    }
    event.dashboardList![event.index!-1].isSelected = true;

    try {
      emit(LkgInitialLoadedSuccessState(
        lkgProducts: event.lkgProducts,
        dashboardList: event.dashboardList!,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LkgDrawerActionButtonState(index: event.index,sectionID: event.sectionID));
    } catch (e) {
      emit(LkgInitialErrorState(error: 'error ${e.toString()}'));
    }
  }


  Future<FutureOr<void>> lkgInitialEvent(
      LkgInitialEvent event, Emitter<LkgState> emit) async {
    var responseValue;

    emit(LkgInitialLoadingState());



print('checking the lkg length ${lkgCategoryModel?.data.length} and then food category length ${foodLkgCategoryModel?.data.length}');

    if (lkgCategoryModel != null && foodLkgCategoryModel!= null) {


      if (dashboardModel?.data.length == 5) {
        dashboardModel?.data.removeAt(4);
      }

      lkgCategoryModel!.data.removeWhere((element) => element.isLkgFoodCategory == true);


      for(var item in foodLkgCategoryModel!.data){
        lkgCategoryModel!.data.add(VideoCategoriesList(
            id: item.id,
            sectionId: item.sectionId,
            name: item.name,
            description: item.description,
            accessibility: null,
            order: 0, active: item.active,
            image: item.image,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            isSelected: false,
            borderColor: primaryBlue,
            isLkgFoodCategory: true));
        print('checking the food category adding value item name ${item.name}');
      }
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LkgInitialLoadedSuccessState(
        lkgProducts: lkgCategoryModel!.data,
        dashboardList: dashboardModel!.data,
        foodCategoryProducts: foodLkgCategoryModel!.data,
      ));
    }
    else {
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the token value $token');
      Response response = await VideoCategoryApi.getVideoCategoriesSectionID(
          token: token, sectionID: event.sectionID);

      Response response2 = await FoodCategoryApi.getFoodCategoriesSectionID(
        token: token,sectionID: event.sectionID,
      );

      LocalLKGDatabase.instance.createLKG(
          videoCategoryModelString(response.body));
      LocalFoodLKGCategoryDatabase.instance.createFoodLKGCategory(
          foodCategoryModelFromJson(response2.body));

      debugPrint(' checking the video category response  value ${response
          .statusCode}');

      await     Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200 && response2.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));

          print('checking the dashboard length ${dashboardModel?.data.length}');

          if (dashboardModel?.data.length == 5) {
            dashboardModel?.data.removeAt(4);
          }

          // if(PlatformType.isTv!=true){
          //   dashboardModel!.data.add(
          //       DashboardList(
          //         index: 5,
          //         name: 'SUBSCRIPTION',
          //         description: 'NIL',
          //         active: 0,
          //         createdAt: DateTime.now(),
          //         updatedAt: DateTime.now(),
          //         isSelected : false,
          //       )
          //   );
          //
          // }

          print('checking the index after ${dashboardModel!.data.length}');
          for(var item in foodLkgCategoryModel!.data){
            lkgCategoryModel!.data.add(VideoCategoriesList(
                id: item.id,
                sectionId: item.sectionId,
                name: item.name,
                description: item.description,
                accessibility: null,
                order: 0, active: item.active,
                image: item.image,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
                isSelected: false,
                borderColor: primaryBlue,
                isLkgFoodCategory: true));
          }

          await Future.delayed(const Duration(milliseconds: 100));
          emit(LkgInitialLoadedSuccessState(
            lkgProducts: lkgCategoryModel!.data,
            dashboardList: dashboardModel!.data,
            foodCategoryProducts: foodLkgCategoryModel!.data,
          ));
        }
        else {
          emit(LkgInitialErrorState(error: lkgCategoryModel!.message));
        }
      });
    } catch (e) {
      emit(LkgInitialErrorState(error: 'Lkg Screen ${e.toString()}'));
    }
  }
  }

  FutureOr<void> lkgChangingTheColorEvent(LkgChangingTheColorEvent event, Emitter<LkgState> emit) {


    if(event.isRightButton!){
      lkgCategoryModel!.data[event.index!].isSelected = false;
      lkgCategoryModel!.data[event.index!+1].isSelected = true;
      try {
        emit(LkgInitialLoadedSuccessState(
            lkgProducts: lkgCategoryModel!.data,
          dashboardList: dashboardModel!.data,
        ));
      } catch (e) {
        emit(LkgInitialErrorState(error: 'error'));
      }
    }
    else
      {
        lkgCategoryModel!.data[event.index!].isSelected = false;
        lkgCategoryModel!.data[event.index!-1].isSelected = true;
        try {
          emit(LkgInitialLoadedSuccessState(
              lkgProducts: lkgCategoryModel!.data,
            dashboardList: dashboardModel!.data,
          ));
        } catch (e) {
          emit(LkgInitialErrorState(error: 'error ${e.toString()}'));
        }
      }

  }

  FutureOr<void> lkgNavigateButtonEvent(LkgNavigateButtonEvent event, Emitter<LkgState> emit) {
    emit(LkgActionButtonState(
      sectionID: event.sectionID,
      videoCatID: event.videoCatID,
      title: event.title,
      isLkgFoodCategory: event.isLkgFoodCategory,
    ));
  }

  FutureOr<void> lkgBackNavigateButtonEvent(LkgBackNavigateButtonEvent event, Emitter<LkgState> emit) {
    emit(LkgBackActionButtonState());
  }
}
