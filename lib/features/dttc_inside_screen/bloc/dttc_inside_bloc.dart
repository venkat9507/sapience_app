import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/dttc_inside_screen/database_items/item_data.dart';
import 'package:nimu_tv/features/dttc_screen/database_items/item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../rating/api/rating.dart';
import '../../rating/database/item_data.dart';
import '../../rating/model/rating_model.dart';
import '../api/dttc_inside_api.dart';
import '../dttc_inside_model/dttc_inside_model.dart';

part 'dttc_inside_event.dart';
part 'dttc_inside_state.dart';

class DTTCInsideBloc extends Bloc<DTTCInsideEvent, DTTCInsideState> {
  DTTCInsideBloc() : super(DTTCInsideInitial()) {
    on<DTTCInsideInitialEvent>(dttcInitialEvent);
    on<DTTCInsideChangingTheColorEvent>(dttcInsideChangingTheColorEvent);
    on<DTTCInsideNavigateButtonEvent>(dttcInsideNavigateButtonEvent);
    on<DTTCInsideBackNavigateButtonEvent>(dttcInsideBackNavigateButtonEvent);
    on<DTTCInsideUpdatingRatingStarEvent>(dttcInsideUpdatingRatingStarEvent);
  }

  FutureOr<void> dttcInsideNavigateButtonEvent(DTTCInsideNavigateButtonEvent event, Emitter<DTTCInsideState> emit) {
    emit(DTTCInsideActionButtonState(videoID: event.videoID));

  }

  FutureOr<void> lkgInsideBackNavigateButtonEvent(DTTCInsideBackNavigateButtonEvent event, Emitter<DTTCInsideState> emit) {
    emit(DTTCInsideBackActionButtonState());
  }

  Future<FutureOr<void>> dttcInitialEvent(
      DTTCInsideInitialEvent event, Emitter<DTTCInsideState> emit) async {
    var responseValue;
    emit(DTTCInsideInitialLoadingState());
    // await Future.delayed(const Duration(seconds: 2));
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' event.title! ${event.title!}');
      Response   response = await DTTCInsideApi.getDTTCInsideVideosApi(token: token,sectionID: event.sectionID,term: event.term);

      responseValue = json.decode(response.body);
      dttcInsideModel = DTTCInsideModel.fromJson(responseValue,event.title!);


      if(response.statusCode == 200){

        // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
        // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
        await Future.delayed(const Duration(seconds: 1));
        emit(DTTCInsideInitialLoadedSuccessState(
          dttcProducts: dttcInsideModel!.data,
          title: dttcInsideModel!.title!,
        ));
      }
      else
      {
        emit(DTTCInsideInitialErrorState(error:dttcInsideModel!.message));
      }

    } catch (e) {
      emit(DTTCInsideInitialErrorState(error: 'error ${e.toString()}'));
    }
  }

  FutureOr<void> dttcInsideChangingTheColorEvent(DTTCInsideChangingTheColorEvent event, Emitter<DTTCInsideState> emit) {

    debugPrint('event.index! ${event.index!} length ${event.dttcInsideProducts!.length}');

    if(event.isRightButton!){
      if(event.index! <= event.dttcInsideProducts!.length-2){
        dttcInsideModel!.data[event.index!].isSelected = false;
        dttcInsideModel!.data[event.index!+1].isSelected = true;
        try {
          emit(DTTCInsideInitialLoadedSuccessState(
              dttcProducts: dttcInsideModel!.data,
              title: dttcInsideModel!.title!
          ));
        } catch (e) {
          emit(DTTCInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
      {
        dttcInsideModel!.data[event.index!].isSelected = false;
        dttcInsideModel!.data[0].isSelected = true;
        try {
          emit(DTTCInsideInitialLoadedSuccessState(
              dttcProducts: dttcInsideModel!.data,
              title: dttcInsideModel!.title!

          ));
        } catch (e) {
          emit(DTTCInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
    }
    else
    {
      if(event.index == 0){
        dttcInsideModel!.data[event.index!].isSelected = false;
        dttcInsideModel!.data[event.dttcInsideProducts!.length-1].isSelected = true;
        try {
          emit(DTTCInsideInitialLoadedSuccessState(
              dttcProducts: dttcInsideModel!.data,
              title: dttcInsideModel!.title!
          ));
        } catch (e) {
          emit(DTTCInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
      {
        dttcInsideModel!.data[event.index!].isSelected = false;
        dttcInsideModel!.data[event.index!-1].isSelected = true;
        try {
          emit(DTTCInsideInitialLoadedSuccessState(
              dttcProducts: dttcInsideModel!.data,
              title: dttcInsideModel!.title!
          ));
        } catch (e) {
          emit(DTTCInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
    }

  }


  FutureOr<void> dttcInsideBackNavigateButtonEvent(DTTCInsideBackNavigateButtonEvent event, Emitter<DTTCInsideState> emit) {
    emit(DTTCInsideBackActionButtonState());
  }

  Future<FutureOr<void>> dttcInsideUpdatingRatingStarEvent(DTTCInsideUpdatingRatingStarEvent event, Emitter<DTTCInsideState> emit) async {
    var responseValue;
    emit(DTTCInsideUpdatingRatingStarButtonLoadingState());
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      Response   response = await RatingApi.updateRatingApi(token: token,rating: event.rating,videoID: event.videoID);

      responseValue = json.decode(response.body);
      ratingModel = RatingModel.fromJson(responseValue,);



      if(response.statusCode == 200){

        // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
        // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
        await Future.delayed(const Duration(seconds: 1));
        emit(DTTCInsideInitialLoadedSuccessState(
          dttcProducts: dttcInsideModel!.data,
          title: dttcInsideModel!.title!,
        ));
        emit(DTTCInsideUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(DTTCInsideUpdatingRatingStarButtonErrorState(error:dttcInsideModel!.message));
      }

    } catch (e) {
      emit(DTTCInsideUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }

}
