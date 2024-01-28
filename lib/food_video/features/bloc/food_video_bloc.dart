import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/video/features/download/download.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/shared_preference.dart';
import '../../api/food_api.dart';
import '../../models/food_video_models.dart';
import '../database/item_data.dart';
import '../database/local_database.dart';
import '../download/download.dart';

part 'food_video_event.dart';
part 'food_video_state.dart';

class FoodVideoBloc extends Bloc<FoodVideoEvent, FoodVideoState> {
  late VideoPlayerController controller;

  FoodVideoBloc() : super(FoodVideoInitial()) {
    on<FoodVideoInitialEvent>(foodVideoInitialEvent);
    on<FoodChangingTheVideoEvent>(foodChangingTheVideoEvent);
    on<FoodVideoBackNavigateButtonEvent>(foodVideoBackNavigateButtonEvent);
    on<FoodVideoPauseButtonEvent>(foodVideoPauseButtonEvent);

  }

  FutureOr<void> foodVideoBackNavigateButtonEvent(FoodVideoBackNavigateButtonEvent event, Emitter<FoodVideoState> emit) {
    emit(FoodVideoBackButtonPressedState());
  }
  Future<FutureOr<void>> foodVideoInitialEvent(
      FoodVideoInitialEvent event, Emitter<FoodVideoState> emit) async {
    downloadPercentage.value = 0;
    var responseValue;
    bool? checkDownload;
    foodVideoModel= null;
    emit(FoodVideoInitialLoadingState());
    // dashboardList.clear();
    // for( var item in DashboardData.dashboardList){
    //   dashboardList.add(DashboardModel(
    //     title: item['title'],
    //     index: item['index'],
    //     isSelected: item['isSelected'],
    //   ));
    // }

    print('checking the video model length ${foodVideoModelList?.length}');

    for(int i=0; i<foodVideoModelList!.length; i++){
      print('checking the foodVideoModelList local database   ${foodVideoModelList![i].data.videoUrl } '
          'event.video url ${event.videoUrl}');
      if(foodVideoModelList![i].data.videoUrl.contains(event.videoUrl!)){
        foodVideoModel = foodVideoModelList![i];
      }
    }

    if(foodVideoModel != null){
      if(foodVideoModel!.data.videoUrl.contains('/data/user/0/com.sapience.students/app_flutter/video-url/')){
        var lastVideoUrl =  foodVideoModel!.data.videoUrl.split('/data/user/0/com.sapience.students/app_flutter/video-url/').last;
        foodVideoModel!.data.videoUrl = lastVideoUrl;
        print('lastVideoUrl $lastVideoUrl');
      }

      var isFileExists = await File(
          '/data/user/0/com.sapience.students/app_flutter/video-url/${foodVideoModel!
              .data.videoUrl}').exists();

      if (isFileExists) {
        foodVideoModel!.data.videoUrl =
        '/data/user/0/com.sapience.students/app_flutter/video-url/${foodVideoModel!
            .data.videoUrl}';
        checkDownload = true;
        await Future.delayed(const Duration(milliseconds: 300));
        // emit(VideoDownloadActionButtonSuccessState(
        //     successState: 'Playing From Downloaded Video...'
        // ));

        if (event.isDownload == true && isFileExists == false) {
          // emit(VideoDownloadActionButtonLoadingState());
          var path = await downloadFile(
              url: foodVideoModel!.data.videoUrl,
              title: foodVideoModel!.data.title);

          foodVideoModel!.data.videoUrl = '$path/${foodVideoModel!.data.videoUrl}';
          debugPrint('checking the path of the downloaded file '
              'path $path'
              'video url ${foodVideoModel!.data
              .videoUrl} checking file exists ${File(
              foodVideoModel!.data.videoUrl).exists()}');
          await Future.delayed(const Duration(milliseconds: 300));
          // emit(VideoDownloadActionButtonSuccessState(
          //   successState: 'Downloaded Successfully...'
          // ),);
          // emit(VideoInitialLoadedSuccessState(
          //   videoData: videoModel!.data,
          // ));
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));
      emit(FoodVideoInitialLoadedSuccessState(
        videoData: foodVideoModel!.data,
        isDownload: checkDownload,
      ));
    }
    else {
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the  video token value $token');
      Response response = await FoodVideoApi.getFoodVideoSections(
          token: token, videoNumber: event.videoNumber, );

      responseValue = json.decode(response.body);
      foodVideoModel = FoodVideoModel.fromJson(responseValue,);

      debugPrint(' checking the video category response  value ${response
          .statusCode}');
      debugPrint(' foodVideoModel!.data.title! ${foodVideoModel!.data
          .title} video number ${event.videoNumber}');

      await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          var isFileExists = await File(
              '/data/user/0/com.sapience.students/app_flutter/video-url/${foodVideoModel!
                  .data.videoUrl}').exists();
          debugPrint(' checking file exists ${foodVideoModel!.data
              .videoUrl} is file exists $isFileExists');

          if (isFileExists) {
            foodVideoModel!.data.videoUrl =
            '/data/user/0/com.sapience.students/app_flutter/video-url/${foodVideoModel!
                .data.videoUrl}';
            checkDownload = true;
            await Future.delayed(const Duration(milliseconds: 300));
            // emit(VideoDownloadActionButtonSuccessState(
            //     successState: 'Playing From Downloaded Video...'
            // ));
          }
          debugPrint('event.isDownload ${event.isDownload} ');

          if (event.isDownload == true && isFileExists == false) {
            // emit(VideoDownloadActionButtonLoadingState());
            var path = await downloadFoodFile(
                url: foodVideoModel!.data.videoUrl,
                title: foodVideoModel!.data.title);

            foodVideoModel!.data.videoUrl = '$path/${foodVideoModel!.data.videoUrl}';
            LocalFoodVideoDatabase.instance.createFoodVideo(
              foodVideoModel!,
            );
            debugPrint('checking the path of the downloaded file '
                'path $path'
                'video url ${foodVideoModel!.data
                .videoUrl} checking file exists ${File(
                foodVideoModel!.data.videoUrl).exists()}');
            await Future.delayed(const Duration(milliseconds: 300));
            // emit(VideoDownloadActionButtonSuccessState(
            //   successState: 'Downloaded Successfully...'
            // ),);
            // emit(VideoInitialLoadedSuccessState(
            //   videoData: foodVideoModel!.data,
            // ));
          }



          await Future.delayed(const Duration(milliseconds: 500));
          emit(FoodVideoInitialLoadedSuccessState(
            videoData: foodVideoModel!.data,
            isDownload: checkDownload,
          ));
        }
        else {
          emit(FoodVideoInitialErrorState(error: foodVideoModel!.message));
        }
      });
    } catch (e) {
      emit(FoodVideoInitialErrorState(error: 'error ${e.toString()}'));
    }
  }
  }

  Future<FutureOr<void>> foodChangingTheVideoEvent(FoodChangingTheVideoEvent event, Emitter<FoodVideoState> emit) async {


  try
      {
        if(event.isPrevButtonPressed == true){
          debugPrint('checking on bloc page event isprev button pressed ${event.prevVideoID}');
          emit(FoodVideoPrevOrNextLoadingState());
          if(event.prevVideoID != null){
            await Future.delayed(const Duration(milliseconds: 300));
            emit(FoodVideoPrevOrNextState(
              videoNumber: event.prevVideoID,
              isPrevButtonPressed: event.isPrevButtonPressed,
              prevVideoID: event.prevVideoID,
              nextVideoID: event.nextVideoID,
              videosList: event.videosList,
            ));
          }
          else
          {
            emit(FoodVideoPrevOrNextErrorState(error: 'Sorry No Previous video Available'));
          }

        }
        else
        {
          emit(FoodVideoPrevOrNextLoadingState());
          if(event.nextVideoID != null){
            await Future.delayed(const Duration(milliseconds: 300));
            emit(FoodVideoPrevOrNextState(
              videoNumber: event.nextVideoID,
              isPrevButtonPressed: event.isPrevButtonPressed,
              prevVideoID: event.prevVideoID,
              nextVideoID: event.nextVideoID,
              videosList: event.videosList,
            ));
          }
          else
          {
            emit(FoodVideoPrevOrNextErrorState(error: 'Sorry No Next video Available'));
          }

        }
      }
      catch (e){
        emit(FoodVideoPrevOrNextErrorState(error: 'error ${e.toString()}'));
      }
  }

  void  foodVideoPauseButtonEvent(FoodVideoPauseButtonEvent event, Emitter<FoodVideoState> emit) {
    emit(FoodVideoPauseButtonState());

  }
}
