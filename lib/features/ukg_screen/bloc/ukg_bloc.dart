import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/lkg_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/lkg_screen/models/lkg_models.dart';
import 'package:nimu_tv/features/video_categories/api/video_category_api.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/shared_preference.dart';
import '../../../config/color_const.dart';
import '../../../main.dart';
import '../../dashboard_screen/api/dashboard_api.dart';
import '../../dashboard_screen/dashboard_model/dashboard_model.dart';
import '../../dashboard_screen/database_items/items_data.dart';
import '../../food_categories/api/food_category_api.dart';
import '../../food_categories/database/item_data.dart';
import '../../food_categories/database/ukg_local_database.dart';
import '../../food_categories/models/food_category_models.dart';
import '../../video_categories/model/video_category_model.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';

part 'ukg_event.dart';
part 'ukg_state.dart';

class UkgBloc extends Bloc<UkgEvent, UkgState> {
  UkgBloc() : super(UkgInitial()) {
    on<UkgInitialEvent>(ukgInitialEvent);
    on<UkgChangingTheColorEvent>(ukgChangingTheColorEvent);
    on<UkgChangingTheDrawerColorEvent>(ukgChangingTheDrawerColorEvent);
    on<UkgNavigateButtonEvent>(ukgNavigateButtonEvent);
    on<UkgBackNavigateButtonEvent>(ukgBackNavigateButtonEvent);
    on<LogoutUkgEvent>(logoutEvent);
  }

  Future<FutureOr<void>> logoutEvent(
      LogoutUkgEvent event, Emitter<UkgState> emit) async {


    emit(UkgLogoutButtonLoadingState());


    try {
      bool logout = await DashboardApi.logout();
      await Future.delayed(const Duration(milliseconds: 100));
      if(logout){
        emit(UkgLogoutButtonLoadedSuccessState());
      }
      else
      {
        emit(UkgLogoutButtonErrorState(error: 'error occurred while logout'));
      }

    } catch (e) {
      emit(UkgLogoutButtonErrorState(error: 'error occurred while logout'));

    }
  }


  Future<FutureOr<void>> ukgChangingTheDrawerColorEvent(
      UkgChangingTheDrawerColorEvent event, Emitter<UkgState> emit) async {

    for(var item in event.dashboardList! ){
      item.isSelected = false;
    }
    event.dashboardList![event.index!-1].isSelected = true;

    try {
      emit(UkgInitialLoadedSuccessState(
        ukgProducts: event.ukgProducts,
        dashboardList: event.dashboardList!,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(UkgDrawerActionButtonState(index: event.index,sectionID: event.sectionID));
    } catch (e) {
      emit(UkgInitialErrorState(error: 'error $e'));
    }
  }


  Future<FutureOr<void>> ukgInitialEvent(
      UkgInitialEvent event, Emitter<UkgState> emit) async {
    var responseValue;

    emit(UkgInitialLoadingState());


    if (ukgCategoryModel != null && foodUkgCategoryModel!= null) {

      print('ukg category model is calling at != NULL ');

      if (dashboardModel?.data.length == 5) {
        dashboardModel?.data.removeAt(4);
      }
      ukgCategoryModel!.data.removeWhere((element) => element.isLkgFoodCategory == true);

      for(var item in foodUkgCategoryModel!.data){
        ukgCategoryModel!.data.add(VideoCategoriesList(
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
      emit(UkgInitialLoadedSuccessState(
        ukgProducts: ukgCategoryModel!.data,
        dashboardList: dashboardModel!.data,
      ));
    }
    else {
      // dashboardList.clear();
      // for( var item in DashboardData.dashboardList){
      //   dashboardList.add(DashboardModel(
      //     title: item['title'],
      //     index: item['index'],
      //     isSelected: item['isSelected'],
      //   ));
      // }
      try {
        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' checking the token value $token');
        Response response = await VideoCategoryApi.getVideoCategoriesSectionID(
            token: token, sectionID: event.sectionID);

        Response response2 = await FoodCategoryApi.getFoodCategoriesSectionID(
          token: token,sectionID: event.sectionID,
        );

        debugPrint('checking the jsonData ukg bloc initial data  ${json.decode(response.body)}');
        LocalUKGDatabase.instance.createUKG(
            videoCategoryModelString(response.body));
        LocalFoodUKGCategoryDatabase.instance.createFoodUKGCategory(
            foodCategoryModelFromJson(response2.body));
        // responseValue = json.decode(response.body);
        // videoCategoryModel = VideoCategoryModel.fromJson(responseValue);

        debugPrint(' checking the ukg video  category response  value ${response
            .statusCode}');

    await     Future.delayed(Duration(seconds: 1), () async {
          if (response.statusCode == 200 && response2.statusCode == 200) {
            // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
            // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));

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
            for(var item in foodUkgCategoryModel!.data){
              ukgCategoryModel!.data.add(VideoCategoriesList(
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
            print('checking the video category list after getting the data from the api ${ukgCategoryModel!.data}');
            emit(UkgInitialLoadedSuccessState(
              ukgProducts: ukgCategoryModel!.data,
              dashboardList: dashboardModel!.data,
            ));
          }
          else {
            emit(UkgInitialErrorState(error: videoCategoryModel!.message));
          }
        });
      } catch (e) {
        emit(UkgInitialErrorState(error: 'error ${e.toString()}'));
      }
    }
  }

  FutureOr<void> ukgChangingTheColorEvent(UkgChangingTheColorEvent event, Emitter<UkgState> emit) {


    if(event.isRightButton!){
      videoCategoryModel!.data[event.index!].isSelected = false;
      videoCategoryModel!.data[event.index!+1].isSelected = true;
      try {
        emit(UkgInitialLoadedSuccessState(
          ukgProducts: videoCategoryModel!.data,
          dashboardList: dashboardModel!.data,
        ));
      } catch (e) {
        emit(UkgInitialErrorState(error: 'error'));
      }
    }
    else
    {
      videoCategoryModel!.data[event.index!].isSelected = false;
      videoCategoryModel!.data[event.index!-1].isSelected = true;
      try {
        emit(UkgInitialLoadedSuccessState(
          ukgProducts: videoCategoryModel!.data,
          dashboardList: dashboardModel!.data,
        ));
      } catch (e) {
        emit(UkgInitialErrorState(error: 'error ${e.toString()}'));
      }
    }

  }

  FutureOr<void> ukgNavigateButtonEvent(UkgNavigateButtonEvent event, Emitter<UkgState> emit) {
    emit(UkgActionButtonState(
      sectionID: event.sectionID,
      videoCatID: event.videoCatID,
      title: event.title,
      isLkgFoodCategory: event.isLkgFoodCategory,
    ));
  }

  FutureOr<void> ukgBackNavigateButtonEvent(UkgBackNavigateButtonEvent event, Emitter<UkgState> emit) {
    emit(UkgBackActionButtonState());
  }
}
