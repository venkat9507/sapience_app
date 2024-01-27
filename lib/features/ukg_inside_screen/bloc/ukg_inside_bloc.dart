import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../rating/api/rating.dart';
import '../../rating/database/item_data.dart';
import '../../rating/model/rating_model.dart';
import '../api/ukg_inside_api.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';
import '../models/ukg_inside_models.dart';

part 'ukg_inside_event.dart';
part 'ukg_inside_state.dart';

class UkgInsideBloc extends Bloc<UkgInsideEvent, UkgInsideState> {
  UkgInsideBloc() : super(UkgInsideInitial()) {
    on<UkgInsideInitialEvent>(ukgInitialEvent);
    on<UkgInsideChangingTheColorEvent>(ukgInsideChangingTheColorEvent);
    on<UkgInsideNavigateButtonEvent>(ukgInsideNavigateButtonEvent);
    on<UkgInsideWatchOnlineNavigateButtonEvent>(ukgInsideWatchOnlineNavigateButtonEvent);

    on<UkgInsideBackNavigateButtonEvent>(ukgInsideBackNavigateButtonEvent);
    on<UkgInsideUpdatingRatingStarEvent>(ukgInsideUpdatingRatingStarEvent);

  }

  Future<FutureOr<void>> ukgInsideUpdatingRatingStarEvent(UkgInsideUpdatingRatingStarEvent event, Emitter<UkgInsideState> emit) async {
    var responseValue;
    emit(UkgInsideUpdatingRatingStarButtonLoadingState());
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
        emit(UkgInsideInitialLoadedSuccessState(
          ukgProducts: ukgInsideModel!.data,
          title: ukgInsideModel!.title!,
        ));
        emit(UkgInsideUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(UkgInsideUpdatingRatingStarButtonErrorState(error:ukgInsideModel!.message));
      }

    } catch (e) {
      emit(UkgInsideUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }


  FutureOr<void> ukgInsideChangingTheColorEvent(UkgInsideChangingTheColorEvent event, Emitter<UkgInsideState> emit) {

    debugPrint('event.index! ${event.index!} length ${event.ukgInsideProducts!.length}');

    if(event.isRightButton!){
      if(event.index! <= event.ukgInsideProducts!.length-2){
        ukgInsideModel!.data[event.index!].isSelected = false;
        ukgInsideModel!.data[event.index!+1].isSelected = true;
        try {
          emit(UkgInsideInitialLoadedSuccessState(
              ukgProducts: ukgInsideModel!.data,
              title: ukgInsideModel!.title!
          ));
        } catch (e) {
          emit(UkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
      {
        ukgInsideModel!.data[event.index!].isSelected = false;
        ukgInsideModel!.data[0].isSelected = true;
        try {
          emit(UkgInsideInitialLoadedSuccessState(
              ukgProducts: ukgInsideModel!.data,
              title: ukgInsideModel!.title!

          ));
        } catch (e) {
          emit(UkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
    }
    else
    {
      if(event.index == 0){
        ukgInsideModel!.data[event.index!].isSelected = false;
        ukgInsideModel!.data[event.ukgInsideProducts!.length-1].isSelected = true;
        try {
          emit(UkgInsideInitialLoadedSuccessState(
              ukgProducts: ukgInsideModel!.data,
              title: ukgInsideModel!.title!
          ));
        } catch (e) {
          emit(UkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
      {
        ukgInsideModel!.data[event.index!].isSelected = false;
        ukgInsideModel!.data[event.index!-1].isSelected = true;
        try {
          emit(UkgInsideInitialLoadedSuccessState(
              ukgProducts: ukgInsideModel!.data,
              title: ukgInsideModel!.title!
          ));
        } catch (e) {
          emit(UkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
    }

  }


  Future<FutureOr<void>> ukgInitialEvent(
      UkgInsideInitialEvent event, Emitter<UkgInsideState> emit) async {

    print('checking ukg inside initial event section ID ${event.sectionID} and video cat id ${event.videoCatID}');
    ukgInsideModel= null;
    var responseValue;
    emit(UkgInsideInitialLoadingState());
    // await Future.delayed(const Duration(seconds: 2));
    print('checking the ukg inside model ${ukgInsideModelList?.length}');

     for(int i=0; i<ukgInsideModelList!.length; i++){
       print('checking the ukg inside model local database cat ID  ${ukgInsideModelList![i].catID} event.videoCatID ${event.videoCatID}');
      if(ukgInsideModelList![i].catID == event.videoCatID){
        ukgInsideModel = ukgInsideModelList![i];
      }
    }

    if (ukgInsideModel != null) {
      print('checking the ukg inside value');
      await Future.delayed(const Duration(milliseconds: 100));
      emit(UkgInsideInitialLoadedSuccessState(
        ukgProducts: ukgInsideModel!.data,
        title: ukgInsideModel!.title!,
      ));
    }
    else {
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' event.title! ${event.title!}');
      Response response = await UkgInsideApi.getUkgInsideVideosApi(token: token,
          sectionID: event.sectionID,
          videoCatID: event.videoCatID);

      responseValue = json.decode(response.body);
      ukgInsideModel = UkgInsideModel.fromJson(responseValue, title: event.title!,sectionID: event.sectionID!,catID: event.videoCatID!);
       print('check the cat id coming from the ukg inside model api ${ukgInsideModel!.catID}');
      LocalUKGInsideDatabase.instance.createUKGInside(
        ukgInsideModel!,
      );


      await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          await Future.delayed(const Duration(milliseconds: 100));
          emit(UkgInsideInitialLoadedSuccessState(
            ukgProducts: ukgInsideModel?.data,
            title: ukgInsideModel!.title!,
          ));
        }
        else {
          emit(UkgInsideInitialErrorState(error: ukgInsideModel?.message));
        }
      });
    } catch (e) {
      emit(UkgInsideInitialErrorState(error: 'error ukg inside screen ${e.toString()}'));
    }
  }
  }

  FutureOr<void> ukgInsideWatchOnlineNavigateButtonEvent(UkgInsideWatchOnlineNavigateButtonEvent event, Emitter<UkgInsideState> emit) {
    emit(UkgInsideWatchOnlineActionButtonState(videoID: event.videoID));

  }

  FutureOr<void> ukgInsideNavigateButtonEvent(UkgInsideNavigateButtonEvent event, Emitter<UkgInsideState> emit) {
    emit(UkgInsideActionButtonState(videoID: event.videoID,isDownload: event.isDownload,videoUrl: event.videoUrl));

  }

  FutureOr<void> ukgInsideBackNavigateButtonEvent(UkgInsideBackNavigateButtonEvent event, Emitter<UkgInsideState> emit) {
    emit(UkgInsideBackActionButtonState());
  }
}
