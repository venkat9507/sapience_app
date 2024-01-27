
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../video_categories/model/video_category_model.dart';
import '../models/ukg_inside_models.dart';
import 'items_data.dart';



class LocalUKGInsideDatabase {
  LocalUKGInsideDatabase._privateConstructor();
  static final  LocalUKGInsideDatabase instance = LocalUKGInsideDatabase._privateConstructor();
  final db = Localstore.instance;


  createUKGInside(UkgInsideModel insideModel) async {
    // gets new id
    // deleteUKG();

    String id = db.collection('UKGInside').doc().id;
    print('creating the ukg inside category with id $id insidemodel title ${insideModel.title} check the cat id ${insideModel.catID}');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('UKGInside_ID', id);

// save the item
    return await db.collection('UKGInside').doc(id).set({
      'UKGInside': insideModel,
      'title'  :  insideModel.title,
      'sectionID'  :  insideModel.sectionID,
      'catID'  :  insideModel.catID,
    }).then((value) => getUKGInside());
  }

  deleteUKGInside() async {
    SharedPreferences preferences = await sharedPref();

    String? id = preferences.getString('UKGInside_ID',);
    print('deleting  the ukg Inside category with id $id');
    await db.collection('UKGInside').doc(id).delete();
    return  await db.collection('UKGInside').delete();

  }


  getUKGInside() async {
    return await   db.collection('UKGInside').get().then((value) {
         value!.forEach((key, value) {
           print('getting the ukg inside from the database ${value['catID']}');
           ukgInsideModelList!.add(
               UkgInsideModel.fromJson(
                 value['UKGInside'],
                 title: value['title'],
                 sectionID: value['sectionID'],
                 catID: value['catID'],
               )
           );
           print('items from the collection get ukgInside data ${ukgInsideModelList!.length}');
         });
    });

  }

}