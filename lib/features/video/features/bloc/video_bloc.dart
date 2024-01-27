import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/video/api/video_api.dart';
import 'package:nimu_tv/features/video/features/database/item_data.dart';
import 'package:nimu_tv/features/video/features/download/download.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/shared_preference.dart';
import '../../models/video_models.dart';
import '../database/local_database.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  late VideoPlayerController controller;

  VideoBloc() : super(VideoInitial()) {
    on<VideoInitialEvent>(videoInitialEvent);
    on<ChangingTheVideoEvent>(changingTheVideoEvent);
    on<VideoBackNavigateButtonEvent>(videoBackNavigateButtonEvent);
    on<VideoPauseButtonEvent>(videoPauseButtonEvent);

  }

  FutureOr<void> videoBackNavigateButtonEvent(VideoBackNavigateButtonEvent event, Emitter<VideoState> emit) {
    emit(VideoBackButtonPressedState());
  }
  Future<FutureOr<void>> videoInitialEvent(
      VideoInitialEvent event, Emitter<VideoState> emit) async {
    downloadPercentage.value = 0;
    var responseValue;
    bool? checkDownload;
    videoModel= null;
    emit(VideoInitialLoadingState());
    // dashboardList.clear();
    // for( var item in DashboardData.dashboardList){
    //   dashboardList.add(DashboardModel(
    //     title: item['title'],
    //     index: item['index'],
    //     isSelected: item['isSelected'],
    //   ));
    // }

    print('checking the video model length ${videoModelList?.length} event.video url ${event.videoUrl}');

    for(int i=0; i<videoModelList!.length; i++){
      print('checking the videoModelList local database   ${videoModelList![i].data.videoUrl } '
          'event.video url ${event.videoUrl}');
      if(videoModelList![i].data.videoUrl!.contains(event.videoUrl!)){
        videoModel = videoModelList![i];
        print('checking the videoModelList contains   ${videoModelList![i].data.videoUrl } '
            'event.video url ${event.videoUrl}');
      }
    }

    if(videoModel != null){
      if(videoModel!.data.videoUrl!.contains('/data/user/0/com.example.nimu_tv/app_flutter/video-url/')){
      var lastVideoUrl =  videoModel!.data.videoUrl!.split('/data/user/0/com.example.nimu_tv/app_flutter/video-url/').last;
      videoModel!.data.videoUrl = lastVideoUrl;
      print('lastVideoUrl $lastVideoUrl');
      }
      var isFileExists = await File(
          '/data/user/0/com.example.nimu_tv/app_flutter/video-url/${videoModel!
              .data.videoUrl!}').exists();

      print('checking the file exists are not ${isFileExists}');

      if (isFileExists) {
        videoModel!.data.videoUrl =
        '/data/user/0/com.example.nimu_tv/app_flutter/video-url/${videoModel!
            .data.videoUrl!}';
        checkDownload = true;
        await Future.delayed(const Duration(milliseconds: 300));

        print('checking the video url inside the isfileexist local database medium ${videoModel!.data.videoUrl}');
        // emit(VideoDownloadActionButtonSuccessState(
        //     successState: 'Playing From Downloaded Video...'
        // ));
      }

      if (event.isDownload == true && isFileExists == false) {
        // emit(VideoDownloadActionButtonLoadingState());
        var path = await downloadFile(
            url: videoModel!.data.videoUrl!,
            title: videoModel!.data.title!);

        videoModel!.data.videoUrl = '$path/${videoModel!.data.videoUrl!}';
        debugPrint('checking the path of the downloaded file '
            'path $path'
            'video url ${videoModel!.data
            .videoUrl} checking file exists ${File(
            '${videoModel!.data.videoUrl}').exists()}');
        await Future.delayed(const Duration(milliseconds: 300));
        // emit(VideoDownloadActionButtonSuccessState(
        //   successState: 'Downloaded Successfully...'
        // ),);
        // emit(VideoInitialLoadedSuccessState(
        //   videoData: videoModel!.data,
        // ));
      }

      print('checking the checkdownload value $checkDownload');

      await Future.delayed(const Duration(milliseconds: 500));
      emit(VideoInitialLoadedSuccessState(
        videoData: videoModel!.data,
        isDownload: checkDownload,
      ));
    }
    else {
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the  video token value $token');
      Response response = await VideoApi.getVideoSections(
          token: token, videoNumber: event.videoNumber, isDTTC: event.isDTTC);

      responseValue = json.decode(response.body);
      videoModel = VideoModel.fromJson(responseValue,);


      debugPrint(' checking the video category response  value ${response
          .statusCode}');
      debugPrint(' videoModel!.data.title! ${videoModel!.data
          .title!} video number ${event.videoNumber}');

      await Future.delayed(Duration(seconds: 1), () async {
        if (response.statusCode == 200) {
          // dashboardModel!.data.add(DashboardList(index: 3, name: 'DTTC', active: 1, isSelected: false,description: null,createdAt: null,updatedAt: null));
          // dashboardModel!.data.sort((a,b)=> a.index.compareTo(b.index));
          var isFileExists = await File(
              '/data/user/0/com.example.nimu_tv/app_flutter/video-url/${videoModel!
                  .data.videoUrl!}').exists();
          debugPrint(' checking file exists ${videoModel!.data
              .videoUrl!} is file exists $isFileExists');

          if (isFileExists) {
            videoModel!.data.videoUrl =
            '/data/user/0/com.example.nimu_tv/app_flutter/video-url/${videoModel!
                .data.videoUrl!}';
            checkDownload = true;
            await Future.delayed(const Duration(milliseconds: 300));
            // emit(VideoDownloadActionButtonSuccessState(
            //     successState: 'Playing From Downloaded Video...'
            // ));
          }
          debugPrint('event.isDownload ${event.isDownload} ');

          if (event.isDownload == true && isFileExists == false) {
            // emit(VideoDownloadActionButtonLoadingState());
            var path = await downloadFile(
                url: videoModel!.data.videoUrl!,
                title: videoModel!.data.title!);

            videoModel!.data.videoUrl = '$path/${videoModel!.data.videoUrl!}';
            LocalVideoDatabase.instance.createVideo(
              videoModel!,
            );
            debugPrint('checking the path of the downloaded file '
                'path $path'
                'video url ${videoModel!.data
                .videoUrl} checking file exists ${File(
                '${videoModel!.data.videoUrl}').exists()}');
            await Future.delayed(const Duration(milliseconds: 300));
            // emit(VideoDownloadActionButtonSuccessState(
            //   successState: 'Downloaded Successfully...'
            // ),);
            // emit(VideoInitialLoadedSuccessState(
            //   videoData: videoModel!.data,
            // ));
          }

          await Future.delayed(const Duration(milliseconds: 500));
          emit(VideoInitialLoadedSuccessState(
            videoData: videoModel!.data,
            isDownload: checkDownload,
          ));
        }
        else {
          emit(VideoInitialErrorState(error: videoModel!.message));
        }
      });
    } catch (e) {
      emit(VideoInitialErrorState(error: 'error ${e.toString()}'));
    }
  }
  }

  Future<FutureOr<void>> changingTheVideoEvent(ChangingTheVideoEvent event, Emitter<VideoState> emit) async {


  try
      {
        if(event.isPrevButtonPressed == true){
          debugPrint('checking on bloc page event isprev button pressed ${event.prevVideoID}');
          emit(VideoPrevOrNextLoadingState());
          if(event.prevVideoID != null){
            await Future.delayed(const Duration(milliseconds: 300));
            emit(VideoPrevOrNextState(
              videoNumber: event.prevVideoID,
              isPrevButtonPressed: event.isPrevButtonPressed,
              prevVideoID: event.prevVideoID,
              nextVideoID: event.nextVideoID,
              videosList: event.videosList,
            ));
          }
          else
          {
            emit(VideoPrevOrNextErrorState(error: 'Sorry No Previous video Available'));
          }

        }
        else
        {
          emit(VideoPrevOrNextLoadingState());
          if(event.nextVideoID != null){
            await Future.delayed(const Duration(milliseconds: 300));
            emit(VideoPrevOrNextState(
              videoNumber: event.nextVideoID,
              isPrevButtonPressed: event.isPrevButtonPressed,
              prevVideoID: event.prevVideoID,
              nextVideoID: event.nextVideoID,
              videosList: event.videosList,
            ));
          }
          else
          {
            emit(VideoPrevOrNextErrorState(error: 'Sorry No Next video Available'));
          }

        }
      }
      catch (e){
        emit(VideoPrevOrNextErrorState(error: 'error ${e.toString()}'));
      }
  }

  void  videoPauseButtonEvent(VideoPauseButtonEvent event, Emitter<VideoState> emit) {
    emit(VideoPauseButtonState());

  }
}
