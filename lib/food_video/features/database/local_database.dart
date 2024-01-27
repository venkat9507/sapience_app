
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video/features/database/item_data.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/shared_preference.dart';
import '../../models/food_video_models.dart';
import 'item_data.dart';





class LocalFoodVideoDatabase {
  LocalFoodVideoDatabase._privateConstructor();
  static final  LocalFoodVideoDatabase instance = LocalFoodVideoDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodVideo(FoodVideoModel videoModel,) async {
    // gets new id
    // deleteUKG();

    String id = db.collection('FoodVideos').doc().id;
    print('creating the Food video  category with id $id video message ${videoModel.message} check the video success ${videoModel.success}');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('FoodVideo_ID', id);

// save the item
    return await db.collection('FoodVideos').doc(id).set({
      'videoModel': videoModel,
    }).then((value) => getFoodVideo());
  }

  deleteFoodVideo() async {
    SharedPreferences preferences = await sharedPref();

    String? id = preferences.getString('FoodVideo_ID',);
    print('deleting  the ukg Inside category with id $id');
    await db.collection('FoodVideos').doc(id).delete();
    return await db.collection('FoodVideos').delete();

  }


  getFoodVideo() async {
    return await  db.collection('FoodVideos').get().then((value) {
         value!.forEach((key, value) {
           print('getting the videoModel url  from the database ${value['videoModel']} ');
           foodVideoModelList!.add(
               FoodVideoModel.fromJson(
                 value['videoModel'],
               )
           );
           print('items from the collection get videoModelList data ${videoModelList!.length}');
         });
    });

  }

}