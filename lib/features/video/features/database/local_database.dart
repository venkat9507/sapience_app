
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video/features/database/item_data.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/shared_preference.dart';
import '../../models/video_models.dart';





class LocalVideoDatabase {
  LocalVideoDatabase._privateConstructor();
  static final  LocalVideoDatabase instance = LocalVideoDatabase._privateConstructor();
  final db = Localstore.instance;


  createVideo(VideoModel videoModel,) async {
    // gets new id
    // deleteUKG();

    String id = db.collection('videos').doc().id;
    print('creating the video  category with id $id video message ${videoModel.message} check the video success ${videoModel.success}');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('video_ID', id);

// save the item
    return await db.collection('videos').doc(id).set({
      'videoModel': videoModel,
    }).then((value) => getVideo());
  }

  deleteVideo() async {
    SharedPreferences preferences = await sharedPref();

    String? id = preferences.getString('video_ID',);
    print('deleting  the ukg Inside category with id $id');
    await db.collection('videos').doc(id).delete();
    return await db.collection('videos').delete();

  }


  getVideo() async {
    return await db.collection('videos').get().then((value) {
         value!.forEach((key, value) {
           print('getting the videoModel url  from the database ${value['videoUrl']} ');
           videoModelList!.add(
               VideoModel.fromJson(
                 value['videoModel'],
               )
           );
           print('items from the collection get videoModelList data ${videoModelList!.length}');
         });
    });

  }

}