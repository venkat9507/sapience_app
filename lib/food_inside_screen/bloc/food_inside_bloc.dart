import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/rating/api/rating.dart';
import 'package:nimu_tv/features/rating/database/item_data.dart';
import 'package:nimu_tv/features/rating/model/rating_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../api/food_inside_api.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';
import '../models/food_inside_models.dart';

part 'food_inside_event.dart';
part 'food_inside_state.dart';

class FoodInsideBloc extends Bloc<FoodInsideEvent, FoodInsideState> {
  FoodInsideBloc() : super(FoodInsideInitial()) {
    on<FoodInsideInitialEvent>(foodInitialEvent);
    // on<FoodInsideChangingTheColorEvent>(lkgInsideChangingTheColorEvent);
    on<FoodInsideNavigateButtonEvent>(foodInsideNavigateButtonEvent);
    on<FoodInsideWatchOnlineNavigateButtonEvent>(foodInsideWatchOnlineNavigateButtonEvent);
    on<FoodInsideBackNavigateButtonEvent>(foodInsideBackNavigateButtonEvent);
    // on<FoodInsideUpdatingRatingStarEvent>(lkgInsideUpdatingRatingStarEvent);
    // on<LkgInsideDownloadNavigateButtonEvent>(lkgInsideDownloadNavigateButtonEvent);
  }




  Future<FutureOr<void>> foodInitialEvent(
      FoodInsideInitialEvent event, Emitter<FoodInsideState> emit) async {
    print('checking food inside initial event section ID ${event.sectionID} and video cat id ${event.foodCatID}');
    foodInsideModel= null;
    var responseValue;
    emit(FoodInsideInitialLoadingState());
    print('checking the food inside model ${foodInsideModelList?.length}');

    for(int i=0; i<foodInsideModelList!.length; i++){
      print('checking the food inside model local database cat ID  ${foodInsideModelList![i].foodCatID} event.foodCatID ${event.foodCatID}');
      print('checking the food inside model local database food day ID  ${foodInsideModelList![i].foodDayID} event.foodCatID ${event.foodDayID}');
      print('checking the food inside model local database food type ID  ${foodInsideModelList![i].foodTypeID} event.foodCatID ${event.foodTypeID}');
      print('checking the food inside model local database section ID  ${foodInsideModelList![i].sectionID} event.foodCatID ${event.sectionID}');
      if(
      foodInsideModelList![i].foodCatID == event.foodCatID &&
      foodInsideModelList![i].foodTypeID == event.foodTypeID &&
      foodInsideModelList![i].foodDayID == event.foodDayID &&
      foodInsideModelList![i].sectionID == event.sectionID

      ){
        foodInsideModel = foodInsideModelList![i];
      }
    }

    if (foodInsideModel != null) {
      print('checking the food inside value');
      await Future.delayed(const Duration(milliseconds: 100));
      emit(FoodInsideInitialLoadedSuccessState(
        foodProducts: foodInsideModel!.data,
        title: foodInsideModel!.title!,
      ));
    }
    else {
      try {
        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' food inside screen check the token $token '
            'food inside title : ${event.title!} sectionID : ${event.sectionID} foodCat : ${event.foodCatID} foodType : ${event.foodTypeID} foodDay : ${event.foodDayID}');
        Response response = await FoodInsideApi.getFoodInsideVideosApi(
            token: token,
            sectionID: event.sectionID,
            foodCatID: event.foodCatID,
            foodTypeID: event.foodTypeID,
            foodDayID: event.foodDayID,
        );

        responseValue = json.decode(response.body);
        foodInsideModel = FoodInsideModel.fromJson(
            responseValue, title: event.title!,
            sectionID: event.sectionID!,
            foodTypeID: event.foodTypeID,foodDayID: event.foodDayID,foodCatID: event.foodCatID);
        print(
            'check the cat id coming from the ukg inside model api ${foodInsideModel!
                .foodCatID}');
        LocalFoodInsideDatabase.instance.createFoodInside(
          foodInsideModel!,
        );

        await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          await Future.delayed(const Duration(milliseconds: 100));
          emit(FoodInsideInitialLoadedSuccessState(
            foodProducts: foodInsideModel!.data,
            title: foodInsideModel!.title!,
          ));
        }
        else {
          emit(FoodInsideInitialErrorState(error: foodInsideModel!.message));
        }
      });
      } catch (e) {
        emit(FoodInsideInitialErrorState(error: 'error ${e.toString()}'));
      }
    }
  }

  FutureOr<void> foodInsideNavigateButtonEvent(FoodInsideNavigateButtonEvent event, Emitter<FoodInsideState> emit) {
    emit(FoodInsideActionButtonState(videoID: event.videoID,isDownload: event.isDownload,videoUrl: event.videoUrl));

  }

  FutureOr<void> foodInsideBackNavigateButtonEvent(FoodInsideBackNavigateButtonEvent event, Emitter<FoodInsideState> emit) {
    emit(FoodInsideBackActionButtonState());
  }




  FutureOr<void> foodInsideWatchOnlineNavigateButtonEvent(FoodInsideWatchOnlineNavigateButtonEvent event, Emitter<FoodInsideState> emit) {
    emit(FoodInsideWatchOnlineActionButtonState(videoID: event.videoID));

  }
}
