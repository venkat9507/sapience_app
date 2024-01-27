
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../video_categories/model/video_category_model.dart';
import '../models/lkg_inside_models.dart';
import 'items_data.dart';



class LocalLKGInsideDatabase {
  LocalLKGInsideDatabase._privateConstructor();
  static final  LocalLKGInsideDatabase instance = LocalLKGInsideDatabase._privateConstructor();
  final db = Localstore.instance;


  createLKGInside(LkgInsideModel insideModel) async {
    // gets new id
    // deleteLKGInside();

    String id = db.collection('LKGInside').doc().id;
    print('creating the Lkg inside category with id $id insidemodel title ${insideModel.title} check the cat id ${insideModel.catID}');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('UKGInside_ID', id);

// save the item
  return await db.collection('LKGInside').doc(id).set({
      'LKGInside': insideModel,
      'title'  :  insideModel.title,
      'sectionID'  :  insideModel.sectionID,
      'catID'  :  insideModel.catID,
    }).then((value) => getLKGInside());
  }

  deleteLKGInside() async {
    SharedPreferences preferences = await sharedPref();
  return  await db.collection('LKGInside').delete();

    // String? id = preferences.getString('LKGInside_ID',);
    // print('deleting  the lkg Inside category with id $id');
    // await db.collection('LKGInside').doc(id).delete();
    // await db.collection('LKGInside').doc().delete();

  }


  getLKGInside() async {
    return await db.collection('LKGInside').get().then((value) {
         value!.forEach((key, value) {
           print('getting the lkg inside from the database ${value['catID']}');
           lkgInsideModelList!.add(
               LkgInsideModel.fromJson(
                 value['LKGInside'],
                 title: value['title'],
                 sectionID: value['sectionID'],
                 catID: value['catID'],
               )
           );
           print('items from the collection get lkgInside data ${lkgInsideModelList!.length}');
         });
    });

  }

}