import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/food_categories/database/item_data.dart';
import 'package:nimu_tv/features/food_types_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/rating/api/rating.dart';
import 'package:nimu_tv/features/rating/database/item_data.dart';
import 'package:nimu_tv/features/rating/model/rating_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../api/food_days_api.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';
import '../models/food_days_models.dart';

part 'food_days_event.dart';
part 'food_days_state.dart';

class FoodDaysBloc extends Bloc<FoodDaysEvent, FoodDaysState> {
  FoodDaysBloc() : super(FoodDaysInitial()) {
    on<FoodDaysInitialEvent>(foodDaysInitialEvent);
    // on<FoodTypesChangingTheColorEvent>(lkgInsideChangingTheColorEvent);
    on<FoodDaysNavigateButtonEvent>(foodDaysInsideNavigateButtonEvent);
    on<FoodDaysWatchOnlineNavigateButtonEvent>(foodDaysInsideWatchOnlineNavigateButtonEvent);
    on<FoodDaysBackNavigateButtonEvent>(foodDaysInsideBackNavigateButtonEvent);
    on<FoodDaysUpdatingRatingStarEvent>(foodDaysInsideUpdatingRatingStarEvent);
    // on<LkgInsideDownloadNavigateButtonEvent>(lkgInsideDownloadNavigateButtonEvent);
  }




  Future<FutureOr<void>> foodDaysInitialEvent(
      FoodDaysInitialEvent event, Emitter<FoodDaysState> emit) async {
    print('checking food tyoes inside initial event section ID ');
    // foodTypesModel= null;
    var responseValue;
    emit(FoodDaysInitialLoadingState());
    print('checking the food days model $foodDaysModel ');

    if (foodDaysModel != null) {
      print('checking the food type local  inside value');
      await Future.delayed(const Duration(milliseconds: 100));
      emit(FoodDaysInitialLoadedSuccessState(
        foodDaysModel: foodDaysModel,
        title: event.title!,
        // title: foodTypesModel!.data[foodDaysModelIndex!].name,
      ));
    }
    else {
      try {
        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' event.title! ${event.title!}');
        Response response = await FoodDaysApi.getFoodDaysApi(
            token: token,);

        responseValue = json.decode(response.body);
        foodDaysModel = FoodDaysModel.fromJson(
            responseValue, title: event.title!,
           );
        print(
            'check the cat id coming from the ukg inside model api ');
        LocalFoodDaysDatabase.instance.createFoodDays(
          foodDaysModel!,
        );

        await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          await Future.delayed(const Duration(milliseconds: 100));
          emit(FoodDaysInitialLoadedSuccessState(
            foodDaysModel: foodDaysModel,
            title: event.title!,
            // title: foodTypesModel!.data[0].name,
          ));
        }
        else {
          emit(FoodDaysInitialErrorState(error: foodDaysModel!.message));
        }
      });
      } catch (e) {
        emit(FoodDaysInitialErrorState(error: 'error ${e.toString()}'));
      }
    }
  }

  FutureOr<void> foodDaysInsideNavigateButtonEvent(FoodDaysNavigateButtonEvent event, Emitter<FoodDaysState> emit) {
    emit(FoodDaysActionButtonState(foodDaysID: event.foodTypeID,title: event.title,));

  }

  FutureOr<void> foodDaysInsideBackNavigateButtonEvent(FoodDaysBackNavigateButtonEvent event, Emitter<FoodDaysState> emit) {
    emit(FoodDaysBackActionButtonState());
  }

  Future<FutureOr<void>> foodDaysInsideUpdatingRatingStarEvent(FoodDaysUpdatingRatingStarEvent event, Emitter<FoodDaysState> emit) async {
    var responseValue;
    emit(FoodDaysUpdatingRatingStarButtonLoadingState());
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      Response   response = await RatingApi.updateRatingApi(token: token,rating: event.rating,videoID: event.videoID);

      responseValue = json.decode(response.body);
      ratingModel = RatingModel.fromJson(responseValue,);



      if(response.statusCode == 200){

        // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
        // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(FoodDaysInitialLoadedSuccessState(
          foodDaysModel: foodDaysModel,
          title:foodDaysModel!.data[0].name,
        ));
        emit(FoodDaysUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(FoodDaysUpdatingRatingStarButtonErrorState(error:foodDaysModel!.message));
      }

    } catch (e) {
      emit(FoodDaysUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }



  FutureOr<void> foodDaysInsideWatchOnlineNavigateButtonEvent(FoodDaysWatchOnlineNavigateButtonEvent event, Emitter<FoodDaysState> emit) {
    emit(FoodDaysWatchOnlineActionButtonState(videoID: event.videoID));

  }
}
