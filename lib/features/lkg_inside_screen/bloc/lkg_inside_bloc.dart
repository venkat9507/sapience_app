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
import '../api/lkg_inside_api.dart';
import '../database_items/items_data.dart';
import '../database_items/local_database.dart';
import '../models/lkg_inside_models.dart';

part 'lkg_inside_event.dart';
part 'lkg_inside_state.dart';

class LkgInsideBloc extends Bloc<LkgInsideEvent, LkgInsideState> {
  LkgInsideBloc() : super(LkgInsideInitial()) {
    on<LkgInsideInitialEvent>(lkgInitialEvent);
    on<LkgInsideChangingTheColorEvent>(lkgInsideChangingTheColorEvent);
    on<LkgInsideNavigateButtonEvent>(lkgInsideNavigateButtonEvent);
    on<LkgInsideWatchOnlineNavigateButtonEvent>(lkgInsideWatchOnlineNavigateButtonEvent);
    on<LkgInsideBackNavigateButtonEvent>(lkgInsideBackNavigateButtonEvent);
    on<LkgInsideUpdatingRatingStarEvent>(lkgInsideUpdatingRatingStarEvent);
    // on<LkgInsideDownloadNavigateButtonEvent>(lkgInsideDownloadNavigateButtonEvent);
  }

  FutureOr<void> lkgInsideChangingTheColorEvent(LkgInsideChangingTheColorEvent event, Emitter<LkgInsideState> emit) {

    debugPrint('event.index! ${event.index!} length ${event.lkgInsideProducts!.length}');

    if(event.isRightButton!){
      if(event.index! <= event.lkgInsideProducts!.length-2){
        lkgInsideModel!.data[event.index!].isSelected = false;
        lkgInsideModel!.data[event.index!+1].isSelected = true;
        try {
          emit(LkgInsideInitialLoadedSuccessState(
              lkgProducts: lkgInsideModel!.data,
            title: lkgInsideModel!.title!
          ));
        } catch (e) {
          emit(LkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
        {
          lkgInsideModel!.data[event.index!].isSelected = false;
          lkgInsideModel!.data[0].isSelected = true;
          try {
            emit(LkgInsideInitialLoadedSuccessState(
                lkgProducts: lkgInsideModel!.data,
                title: lkgInsideModel!.title!

            ));
          } catch (e) {
            emit(LkgInsideInitialErrorState(error: 'error ${e.toString()}'));
          }
        }
    }
    else
    {
      if(event.index == 0){
        lkgInsideModel!.data[event.index!].isSelected = false;
        lkgInsideModel!.data[event.lkgInsideProducts!.length-1].isSelected = true;
        try {
          emit(LkgInsideInitialLoadedSuccessState(
              lkgProducts: lkgInsideModel!.data,
              title: lkgInsideModel!.title!
          ));
        } catch (e) {
          emit(LkgInsideInitialErrorState(error: 'error ${e.toString()}'));
        }
      }
      else
        {
          lkgInsideModel!.data[event.index!].isSelected = false;
          lkgInsideModel!.data[event.index!-1].isSelected = true;
          try {
            emit(LkgInsideInitialLoadedSuccessState(
                lkgProducts: lkgInsideModel!.data,
                title: lkgInsideModel!.title!
            ));
          } catch (e) {
            emit(LkgInsideInitialErrorState(error: 'error ${e.toString()}'));
          }
        }
    }

  }


  Future<FutureOr<void>> lkgInitialEvent(
      LkgInsideInitialEvent event, Emitter<LkgInsideState> emit) async {
    print('checking lkg inside initial event section ID ${event.sectionID} and video cat id ${event.videoCatID}');
    lkgInsideModel= null;
    var responseValue;
    emit(LkgInsideInitialLoadingState());
    print('checking the lkg inside model ${lkgInsideModelList?.length}');

    for(int i=0; i<lkgInsideModelList!.length; i++){
      print('checking the lkg inside model local database cat ID  ${lkgInsideModelList![i].catID} event.videoCatID ${event.videoCatID}');
      if(lkgInsideModelList![i].catID == event.videoCatID){
        lkgInsideModel = lkgInsideModelList![i];
      }
    }

    if (lkgInsideModel != null) {
      print('checking the lkg inside value');
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LkgInsideInitialLoadedSuccessState(
        lkgProducts: lkgInsideModel!.data,
        title: lkgInsideModel!.title!,
      ));
    }
    else {
      try {
        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' event.  vzzz!   ${event.title!}');
        Response response = await LkgInsideApi.getLkgInsideVideosApi(
            token: token,
            sectionID: event.sectionID,
            videoCatID: event.videoCatID);

        responseValue = json.decode(response.body);
        lkgInsideModel = LkgInsideModel.fromJson(
            responseValue, title: event.title!,
            sectionID: event.sectionID!,
            catID: event.videoCatID!);
        print(
            'check the cat id coming from the ukg inside model api ${lkgInsideModel!
                .catID}');
        LocalLKGInsideDatabase.instance.createLKGInside(
          lkgInsideModel!,
        );

        await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          await Future.delayed(const Duration(milliseconds: 100));
          emit(LkgInsideInitialLoadedSuccessState(
            lkgProducts: lkgInsideModel!.data,
            title: lkgInsideModel!.title!,
          ));
        }
        else {
          emit(LkgInsideInitialErrorState(error: lkgInsideModel!.message));
        }
      });
      } catch (e) {
        emit(LkgInsideInitialErrorState(error: 'error ${e.toString()}'));
      }
    }
  }

  FutureOr<void> lkgInsideNavigateButtonEvent(LkgInsideNavigateButtonEvent event, Emitter<LkgInsideState> emit) {
    emit(LkgInsideActionButtonState(videoID: event.videoID,isDownload: event.isDownload,videoUrl: event.videoUrl));

  }

  FutureOr<void> lkgInsideBackNavigateButtonEvent(LkgInsideBackNavigateButtonEvent event, Emitter<LkgInsideState> emit) {
    emit(LkgInsideBackActionButtonState());
  }

  Future<FutureOr<void>> lkgInsideUpdatingRatingStarEvent(LkgInsideUpdatingRatingStarEvent event, Emitter<LkgInsideState> emit) async {
    var responseValue;
    emit(LkgInsideUpdatingRatingStarButtonLoadingState());
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
        emit(LkgInsideInitialLoadedSuccessState(
          lkgProducts: lkgInsideModel!.data,
          title: lkgInsideModel!.title!,
        ));
        emit(LkgInsideUpdatingRatingStarButtonLoadedSuccessState(rating: event.rating, videoID: event.videoID));

      }
      else
      {
        emit(LkgInsideUpdatingRatingStarButtonErrorState(error:lkgInsideModel!.message));
      }

    } catch (e) {
      emit(LkgInsideUpdatingRatingStarButtonErrorState(error: 'error ${e.toString()}'));
    }
  }

  // Future<FutureOr<void>> lkgInsideDownloadNavigateButtonEvent(LkgInsideDownloadNavigateButtonEvent event, Emitter<LkgInsideState> emit) async {
  //   emit(LkgInsideDownloadActionButtonLoadingState());
  // try
  // {
  //   await Future.delayed(const Duration(seconds: 15));
  // }
  // catch (e){
  //   emit(LkgInsideDownloadActionButtonErrorState(error: e.toString()));
  // }
  //   emit(LkgInsideDownloadActionButtonSuccessState());
  // }

  FutureOr<void> lkgInsideWatchOnlineNavigateButtonEvent(LkgInsideWatchOnlineNavigateButtonEvent event, Emitter<LkgInsideState> emit) {
    emit(LkgInsideWatchOnlineActionButtonState(videoID: event.videoID));

  }
}
