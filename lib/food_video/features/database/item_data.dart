
import 'package:flutter/cupertino.dart';
import 'package:nimu_tv/features/video/models/storingVideoCloseFunction.dart';
import 'package:nimu_tv/features/video/models/video_models.dart';
import 'package:video_player/video_player.dart';

import '../../models/food_video_models.dart';
import '../../models/storingVideoCloseFunction.dart';

FoodVideoModel? foodVideoModel;
List<FoodVideoModel>? foodVideoModelList = <FoodVideoModel>[];

int? storingFoodInsideScreenNo;

StoringFoodVideoCloseModel? storingFoodVideoCloseModel;

VideoPlayerController? foodController;