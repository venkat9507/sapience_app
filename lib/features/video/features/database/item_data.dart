
import 'package:flutter/cupertino.dart';
import 'package:nimu_tv/features/video/models/storingVideoCloseFunction.dart';
import 'package:nimu_tv/features/video/models/video_models.dart';
import 'package:video_player/video_player.dart';

VideoModel? videoModel;
List<VideoModel>? videoModelList = <VideoModel>[];

int? storingInsideScreenNo;
int? storingFoodCategoryInsideScreenNo;

StoringVideoCloseModel? storingVideoCloseModel;

VideoPlayerController? controller;