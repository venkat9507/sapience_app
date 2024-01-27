import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/food_types_screen/api/food_types_api.dart';
import 'package:nimu_tv/features/rating/api/rating.dart';
import 'package:nimu_tv/features/rating/database/item_data.dart';
import 'package:nimu_tv/features/rating/model/rating_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';
import '../models/food_types_models.dart';

part 'food_types_event.dart';
part 'food_types_state.dart';

class FoodTypesBloc extends Bloc<FoodTypesEvent, FoodTypesState> {
  FoodTypesBloc() : super(FoodTypesInitial()) {
    on<FoodTypesInitialEvent>(foodTypesInitialEvent);
    on<FoodTypesNavigateButtonEvent>(foodTypesInsideNavigateButtonEvent);
    on<FoodTypesWatchOnlineNavigateButtonEvent>(foodTypesInsideWatchOnlineNavigateButtonEvent);
    on<FoodTypesBackNavigateButtonEvent>(foodTypesInsideBackNavigateButtonEvent);
    on<FoodTypesUpdatingRatingStarEvent>(foodTypesInsideUpdatingRatingStarEvent);
  }



  Future<FutureOr<void>> foodTypesInitialEvent(
      FoodTypesInitialEvent event, Emitter<FoodTypesState> emit) async {
    print('checking food tyoes inside initial event section ID ');
    // foodTypesModel= null;
    var responseValue;
    emit(FoodTypesInitialLoadingState());
    print('checking the food types model ${foodTypesModel?.data.length} ');

    if (foodTypesModel != null) {
      print('checking the food type local  inside value that it is not null');
      await Future.delayed(const Duration(milliseconds: 100));
      emit(FoodTypesInitialLoadedSuccessState(
        foodTypesModel: foodTypesModel,
        title: event.title!,
      ));
    }
    else {
      try {
        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' event.title! ${event.title!}');
        Response response = await FoodTypesApi.getFoodTypesApi(
            token: token,);

        responseValue = json.decode(response.body);
        foodTypesModel = FoodTypesModel.fromJson(
            responseValue, title: event.title!,
           );
        print(
            'check the cat id coming from the ukg inside model api ');
        LocalFoodTypesDatabase.instance.createFoodTypes(
          foodTypesModel!,
        );

        await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          await Future.delayed(const Duration(milliseconds: 100));
          emit(FoodTypesInitialLoadedSuccessState(
            foodTypesModel: foodTypesModel,
            title: event.title!,
            // title: foodTypesModel!.data[0].name,
          ));
        }
        else {
          emit(FoodTypesInitialErrorState(error: foodTypesModel!.message));
        }
      });
      } catch (e) {
        emit(FoodTypesInitialErrorState(error: 'error ${e.toString()}'));
      }
    }
  }

  FutureOr<void> foodTypesInsideNavigateButtonEvent(FoodTypesNavigateButtonEvent event, Emitter<FoodTypesState> emit) {
    emit(FoodTypesActionButtonState(foodTypeID: event.foodTypeID,title: event.title,));

  }

  FutureOr<void> foodTypesInsideBackNavigateButtonEvent(FoodTypesBackNavigateButtonEvent event, Emitter<FoodTypesState> emit) {
    emit(FoodTypesBackActionButtonState());
  }

  Future<FutureOr<void>> foodTypesInsideUpdatingRatingStarEvent(FoodTypesUpdatingRatingStarEvent event, Emitter<FoodTypesState> emit) async {
    var responseValue;
    emit(FoodTypesUpdatingRatingStarButtonLoadingState());
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
        emit(FoodTypesInitialLoadedSuccessState(
          foodTypesModel: foodTypesModel,
          title:foodTypesModel!.data[0].name,
        ));
        emit(FoodTypesUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(FoodTypesUpdatingRatingStarButtonErrorState(error:foodTypesModel!.message));
      }

    } catch (e) {
      emit(FoodTypesUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }


  FutureOr<void> foodTypesInsideWatchOnlineNavigateButtonEvent(FoodTypesWatchOnlineNavigateButtonEvent event, Emitter<FoodTypesState> emit) {
    emit(FoodTypesWatchOnlineActionButtonState(videoID: event.videoID));

  }
}
