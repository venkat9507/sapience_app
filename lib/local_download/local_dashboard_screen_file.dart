import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/food_days_screen/api/food_days_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nimu_tv/features/food_days_screen/models/food_days_models.dart';
import 'package:nimu_tv/features/food_days_screen/database_items/items_data.dart';
import '../config/color_const.dart';
import '../config/shared_preference.dart';
import '../data/user_data_api/user_data_api.dart';
import '../features/dashboard_screen/api/dashboard_api.dart';
import '../features/dashboard_screen/dashboard_model/dashboard_model.dart';
import '../features/dashboard_screen/database_items/local_database.dart';
import '../features/food_categories/api/food_category_api.dart';
import '../features/food_categories/database/item_data.dart';
import '../features/food_categories/database/lkg_local_database.dart';
import '../features/food_categories/database/ukg_local_database.dart';
import '../features/food_categories/models/food_category_models.dart';
import '../features/food_types_screen/api/food_types_api.dart';
import '../features/food_types_screen/database_items/items_data.dart';
import '../features/food_types_screen/database_items/local_database.dart';
import '../features/food_types_screen/models/food_types_models.dart';
import '../features/lkg_inside_screen/api/lkg_inside_api.dart';
import '../features/lkg_inside_screen/database_items/items_data.dart';
import '../features/lkg_inside_screen/database_items/local_database.dart';
import '../features/lkg_inside_screen/models/lkg_inside_models.dart';
import '../features/lkg_screen/database_items/items_data.dart';
import '../features/lkg_screen/database_items/local_database.dart';
import '../features/ukg_inside_screen/api/ukg_inside_api.dart';
import '../features/ukg_inside_screen/database_items/items_data.dart';
import '../features/ukg_inside_screen/database_items/local_database.dart';
import '../features/ukg_inside_screen/models/ukg_inside_models.dart';
import '../features/ukg_screen/database_items/items_data.dart';
import '../features/ukg_screen/database_items/local_database.dart';
import '../features/video_categories/api/video_category_api.dart';
import '../features/video_categories/model/video_category_model.dart';
import 'package:nimu_tv/features/food_days_screen/database_items/local_database.dart';

import '../food_inside_screen/api/food_inside_api.dart';
import '../food_inside_screen/database_items/items_data.dart';
import '../food_inside_screen/database_items/local_database.dart';
import '../food_inside_screen/models/food_inside_models.dart';

class LocalDatabaseDownloading {
  LocalDatabaseDownloading._privateConstructor();
  static final  LocalDatabaseDownloading instance = LocalDatabaseDownloading._privateConstructor();
  final db = Localstore.instance;

  dashboardScreen() async {
    // BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    await db.collection('LKG').delete();
    await db.collection('LKGInside').delete();
    await db.collection('FoodLKGCategory').delete();

    await db.collection('UKG').delete();
    await db.collection('UKGInside').delete();
    await db.collection('FoodUKGCategory').delete();


    await db.collection('FT').delete();
    await db.collection('FoodDays').delete();
    await db.collection('FoodInside').delete();
   Response response;
    SharedPreferences preferences = await sharedPref();
    if(dashboardModel != null){

      final String? token = preferences.getString('token');

      debugPrint(' checking the token value local ds $token');

       response = await DashboardApi.getDashboardSections(token: token);
      debugPrint(' response local ds ${response.statusCode}');
      await UserDataApi.getUserApi(token: token);

      LocalDashboardDatabase.instance.createDashboard(dashboardModelFromJson(response.body));

      debugPrint('dashboardModel local ${dashboardModel?.data.length}');

      dashboardModel?.data.forEach((element) {
        debugPrint('dashboardModel local name ${element.name}');

       if(element.name == "LKG"){
        try
            {
              print("checking the dashboard is lkg ");
              _lkgScreen(element.index);
            }
            catch  (e,s){

          throw 'error value $e , stack trace $s';
            }
       } else  if(element.name == "UKG"){
        try
            {
              print("checking the dashboard is ukg ");
              _ukgScreen(element.index);
            }
            catch  (e,s){

          throw 'error value $e , stack trace $s';
            }
       }



      });

    }
    // sendPort.send('successfully downloaded');
  }

  _lkgScreen(int? sectionID) async {




    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');
    debugPrint(' checking the token value l $token');
    Response response = await VideoCategoryApi.getVideoCategoriesSectionID(
        token: token, sectionID: sectionID);

    Response response2 = await FoodCategoryApi.getFoodCategoriesSectionID(
      token: token,sectionID: sectionID,
    );

   await LocalLKGDatabase.instance.createLKG(
        videoCategoryModelString(response.body));
    await LocalFoodLKGCategoryDatabase.instance.createFoodLKGCategory(
        foodCategoryModelFromJson(response2.body));

    print('event.title! ft ${foodLkgCategoryModel!.data.length}');




    for(var item in foodLkgCategoryModel!.data){
      lkgCategoryModel!.data.add(VideoCategoriesList(
          id: item.id,
          sectionId: item.sectionId,
          name: item.name,
          description: item.description,
          accessibility: null,
          order: 0, active: item.active,
          image: item.image,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          isSelected: false,
          borderColor: primaryBlue,
          isLkgFoodCategory: true));
    }
    for(var item in lkgCategoryModel!.data){
     if(item.isLkgFoodCategory == false){
       _lkgInsideScreen(item.name, item.sectionId, item.id );
     }

    }

Future.forEach(foodLkgCategoryModel!.data, <FoodCategoryList>(item1) => _foodTypesScreen(item1.name)).then((value) =>
Future.forEach(foodTypesModel!.data, <FoodTypesList>(item2) =>  _foodDaysScreen(item2.name)).then((value) {
  // print(object)
  for(var item1 in foodLkgCategoryModel!.data){



    for(var item2 in foodTypesModel!.data){



      for(var item3 in foodDaysModel!.data){

        _foodInsideScreen(sectionID, item1.id, item2.id, item3.id, item3.name);
      }
    }
  }
})
);


  }
  _ukgScreen(int? sectionID) async {




    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');
    debugPrint(' checking the token value l $token');
    Response response = await VideoCategoryApi.getVideoCategoriesSectionID(
        token: token, sectionID: sectionID);

    Response response2 = await FoodCategoryApi.getFoodCategoriesSectionID(
      token: token,sectionID: sectionID,
    );

    await LocalUKGDatabase.instance.createUKG(
        videoCategoryModelString(response.body));
  await  LocalFoodUKGCategoryDatabase.instance.createFoodUKGCategory(
        foodCategoryModelFromJson(response2.body));

    print('event.title! ft ${foodUkgCategoryModel!.data.length}');


    foodUkgCategoryModel!.data.forEach((element) {

    });

    for(var item in foodUkgCategoryModel!.data){
      ukgCategoryModel!.data.add(VideoCategoriesList(
          id: item.id,
          sectionId: item.sectionId,
          name: item.name,
          description: item.description,
          accessibility: null,
          order: 0, active: item.active,
          image: item.image,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          isSelected: false,
          borderColor: primaryBlue,
          isLkgFoodCategory: true));
    }
    for(var item in ukgCategoryModel!.data){
     if(item.isLkgFoodCategory == false){
       _ukgInsideScreen(item.name, item.sectionId, item.id );
     }

    }

Future.forEach(foodUkgCategoryModel!.data, <FoodCategoryList>(item1) => _foodTypesScreen(item1.name)).then((value) =>
Future.forEach(foodTypesModel!.data, <FoodTypesList>(item2) =>  _foodDaysScreen(item2.name)).then((value) {
  // print(object)
  for(var item1 in foodUkgCategoryModel!.data){



    for(var item2 in foodTypesModel!.data){



      for(var item3 in foodDaysModel!.data){

        _foodInsideScreen(sectionID, item1.id, item2.id, item3.id, item3.name);
      }
    }
  }
})
);


  }

  _lkgInsideScreen(String? title,int? sectionID,int? videoCatID ,) async {
    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');

    Response response = await LkgInsideApi.getLkgInsideVideosApi(
        token: token,
        sectionID: sectionID,
        videoCatID: videoCatID);

  var  responseValue = json.decode(response.body);
    lkgInsideModel = LkgInsideModel.fromJson(
        responseValue, title: title!,
        sectionID: sectionID!,
        catID: videoCatID!);

    LocalLKGInsideDatabase.instance.createLKGInside(
      lkgInsideModel!,
    );

  }
  _ukgInsideScreen(String? title,int? sectionID,int? videoCatID ,) async {
    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');

    Response response = await UkgInsideApi.getUkgInsideVideosApi(
        token: token,
        sectionID: sectionID,
        videoCatID: videoCatID);

  var  responseValue = json.decode(response.body);
    ukgInsideModel = UkgInsideModel.fromJson(
        responseValue, title: title!,
        sectionID: sectionID!,
        catID: videoCatID!);

    LocalUKGInsideDatabase.instance.createUKGInside(
      ukgInsideModel!,
    );

  }

  _foodTypesScreen(String? title) async {
    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');
    debugPrint(' event.title! ft ${title!}');
    Response response = await FoodTypesApi.getFoodTypesApi(
      token: token,);

   var  responseValue = json.decode(response.body);
    foodTypesModel = FoodTypesModel.fromJson(
      responseValue, title: title,
    );
    print(
        'updating locally for food types ');
     LocalFoodTypesDatabase.instance.createFoodTypes(
      foodTypesModel!,
    );
  }

  _foodDaysScreen(String? title) async {
    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');
    debugPrint(' event.title! ${title!}');
    Response response = await FoodDaysApi.getFoodDaysApi(
      token: token,);

   var responseValue = json. decode(response.body);
    foodDaysModel = FoodDaysModel.fromJson(
      responseValue, title: title,
    );
    print(
        'check the cat id coming from the ukg inside model api ');
    LocalFoodDaysDatabase.instance.createFoodDays(
      foodDaysModel!,
    );
  }

  _foodInsideScreen(int? sectionID,int? foodCatID,int? foodTypeID,int? foodDayID ,String? title) async {
    SharedPreferences preferences = await sharedPref();
    final String? token = preferences.getString('token');
    debugPrint(' food inside screen check the token $token '
        'food inside title : ${title!} sectionID : ${sectionID} foodCat : ${foodCatID} foodType : ${foodTypeID} foodDay : ${foodDayID}');
    Response response = await FoodInsideApi.getFoodInsideVideosApi(
      token: token,
      sectionID: sectionID,
      foodCatID: foodCatID,
      foodTypeID: foodTypeID,
      foodDayID: foodDayID,
    );

   var responseValue = json.decode(response.body);
    foodInsideModel = FoodInsideModel.fromJson(
        responseValue, title: title,
        sectionID: sectionID!,
        foodTypeID: foodTypeID,foodDayID: foodDayID,foodCatID: foodCatID);
    print(
        'check the cat id coming from the ukg inside model api ${foodInsideModel!
            .foodCatID}');
    LocalFoodInsideDatabase.instance.createFoodInside(
      foodInsideModel!,
    );
  }

}
