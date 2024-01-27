import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../../main.dart';
import '../../dashboard_screen/api/dashboard_api.dart';
import '../../dashboard_screen/dashboard_model/dashboard_model.dart';
import '../../rating/api/rating.dart';
import '../../rating/database/item_data.dart';
import '../../rating/model/rating_model.dart';
import '../../ukg_inside_screen/models/ukg_inside_models.dart';
import '../api/kids_food_video.dart';
import '../database_items/items_data.dart';
import '../models/kids_food_video_inside_models.dart';

part 'kids_food_video_inside_event.dart';
part 'kids_food_video_inside_state.dart';

class KidsFoodVideoInsideBloc extends Bloc<KidsFoodVideoInsideEvent, KidsFoodVideoInsideState> {
  KidsFoodVideoInsideBloc() : super(KidsFoodVideoInsideInitial()) {
    on<KidsFoodVideoInsideInitialEvent>(kfvInitialEvent);
    on<KidsFoodVideoInsideChangingTheColorEvent>(kfvInsideChangingTheColorEvent);
    on<KidsFoodVideoInsideNavigateButtonEvent>(kfvInsideNavigateButtonEvent);
    on<KidsFoodVideoInsideBackNavigateButtonEvent>(kfvInsideBackNavigateButtonEvent);
    on<KFVChangingTheDrawerColorEvent>(kfvChangingTheDrawerColorEvent);
    on<LogoutKFVEvent>(logoutEvent);
    on<KFVInsideUpdatingRatingStarEvent>(kfvInsideUpdatingRatingStarEvent);


  }

  Future<FutureOr<void>> logoutEvent(
      LogoutKFVEvent event, Emitter<KidsFoodVideoInsideState> emit) async {


    emit(KFVLogoutButtonLoadingState());


    try {
      bool logout = await DashboardApi.logout();
      await Future.delayed(const Duration(milliseconds: 100));
      if(logout){
        emit(KFVLogoutButtonLoadedSuccessState());
      }
      else
      {
        emit(KFVLogoutButtonErrorState(error: 'error occurred while logout'));
      }

    } catch (e) {
      emit(KFVLogoutButtonErrorState(error: 'error occurred while logout'));

    }
  }

  Future<FutureOr<void>> kfvChangingTheDrawerColorEvent(
      KFVChangingTheDrawerColorEvent event, Emitter<KidsFoodVideoInsideState> emit) async {

    for(var item in event.dashboardList! ){
      item.isSelected = false;
    }
    event.dashboardList![event.index!-1].isSelected = true;

    try {
      emit(KidsFoodVideoInsideInitialLoadedSuccessState(
        kidsFoodVideoProducts: kfvInsideModel!.data,
        dashboardList: event.dashboardList!,
        title: kfvInsideModel!.title!
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(KFVDrawerActionButtonState(index: event.index,sectionID: event.sectionID));
    } catch (e) {
      emit(KidsFoodVideoInsideInitialErrorState(error: 'error'));
    }
  }

  FutureOr<void> kfvInsideChangingTheColorEvent(KidsFoodVideoInsideChangingTheColorEvent event, Emitter<KidsFoodVideoInsideState> emit) {

    debugPrint('event.index! ${event.index!} length ${event.kidsFoodVideoInsideProducts!.length}');

    if(event.isRightButton!){
      if(event.index! <= event.kidsFoodVideoInsideProducts!.length-2){
        kfvInsideModel!.data[event.index!].isSelected = false;
        kfvInsideModel!.data[event.index!+1].isSelected = true;
        try {
          emit(KidsFoodVideoInsideInitialLoadedSuccessState(
              kidsFoodVideoProducts: kfvInsideModel!.data,
            dashboardList: dashboardModel!.data,
            title: kfvInsideModel!.title!
          ));
        } catch (e) {
          emit(KidsFoodVideoInsideInitialErrorState(error: 'error'));
        }
      }
      else
        {
          kfvInsideModel!.data[event.index!].isSelected = false;
          kfvInsideModel!.data[0].isSelected = true;
          try {
            emit(KidsFoodVideoInsideInitialLoadedSuccessState(
                dashboardList: dashboardModel!.data,
                kidsFoodVideoProducts: kfvInsideModel!.data,
                title: kfvInsideModel!.title!
            ));
          } catch (e) {
            emit(KidsFoodVideoInsideInitialErrorState(error: 'error'));
          }
        }
    }
    else
    {
      if(event.index == 0){
        kfvInsideModel!.data[event.index!].isSelected = false;
        kfvInsideModel!.data[event.kidsFoodVideoInsideProducts!.length-1].isSelected = true;
        try {
          emit(KidsFoodVideoInsideInitialLoadedSuccessState(
              dashboardList: dashboardModel!.data,
              kidsFoodVideoProducts: kfvInsideModel!.data,
            title: kfvInsideModel!.title!,
          ));
        } catch (e) {
          emit(KidsFoodVideoInsideInitialErrorState(error: 'error'));
        }
      }
      else
        {
          kfvInsideModel!.data[event.index!].isSelected = false;
          kfvInsideModel!.data[event.index!-1].isSelected = true;
          try {
            emit(KidsFoodVideoInsideInitialLoadedSuccessState(
                dashboardList: dashboardModel!.data,
                kidsFoodVideoProducts: kfvInsideModel!.data,
              title: kfvInsideModel!.title!
            ));
          } catch (e) {
            emit(KidsFoodVideoInsideInitialErrorState(error: 'error'));
          }
        }
    }

  }


  Future<FutureOr<void>> kfvInitialEvent(
      KidsFoodVideoInsideInitialEvent event, Emitter<KidsFoodVideoInsideState> emit) async {
    var responseValue;
    emit(KidsFoodVideoInsideInitialLoadingState());
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' event.title! ${event.title!}');
      Response   response = await KidsFoodVideoApi.getKFVInsideVideosApi(token: token,
          sectionID: event.sectionID,
          // videoCatID: event.videoCatID,
      );

      responseValue = json.decode(response.body);
      kfvInsideModel = KFVInsideModel.fromJson(responseValue,event.title!);

      if(response.statusCode == 200){

        // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
        // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
        if(dashboardModel?.data.length == 5){
          dashboardModel?.data.removeAt(4);
        }

        if(PlatformType.isTv!=true){
          dashboardModel!.data.add(
              DashboardList(
                index: 5,
                name: 'SUBSCRIPTION',
                description: 'NIL',
                active: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isSelected : false,
              )
          );

        }
        await Future.delayed(const Duration(milliseconds: 100));
        emit(KidsFoodVideoInsideInitialLoadedSuccessState(
          kidsFoodVideoProducts: kfvInsideModel!.data,
          title: kfvInsideModel!.title!,
          dashboardList: dashboardModel!.data,
        ));
      }
      else
      {
        emit(KidsFoodVideoInsideInitialErrorState(error:kfvInsideModel!.message));
      }

    } catch (e) {
      emit(KidsFoodVideoInsideInitialErrorState(error: 'error ${e.toString()}'));
    }
  }

  FutureOr<void> kfvInsideNavigateButtonEvent(KidsFoodVideoInsideNavigateButtonEvent event, Emitter<KidsFoodVideoInsideState> emit) {
    emit(KidsFoodVideoInsideActionButtonState(
      videoID: event.videoID,
    ));

  }

  FutureOr<void> kfvInsideBackNavigateButtonEvent(KidsFoodVideoInsideBackNavigateButtonEvent event, Emitter<KidsFoodVideoInsideState> emit) {
    emit(KidsFoodVideoInsideBackActionButtonState());
  }

  Future<FutureOr<void>> kfvInsideUpdatingRatingStarEvent(KFVInsideUpdatingRatingStarEvent event, Emitter<KidsFoodVideoInsideState> emit) async {
    var responseValue;
    emit(KFVInsideUpdatingRatingStarButtonLoadingState());
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
        emit(KidsFoodVideoInsideInitialLoadedSuccessState(
          kidsFoodVideoProducts: kfvInsideModel!.data,
          title: kfvInsideModel!.title!,
          dashboardList: dashboardModel!.data,
        ));
        emit(KFVInsideUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(KFVInsideUpdatingRatingStarButtonErrorState(error:ratingModel!.message));
      }

    } catch (e) {
      emit(KFVInsideUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }

}
