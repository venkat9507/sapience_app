
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../dashboard_model/dashboard_model.dart';


class LocalDashboardDatabase {
  LocalDashboardDatabase._privateConstructor();
  static final  LocalDashboardDatabase instance = LocalDashboardDatabase._privateConstructor();
  final db = Localstore.instance;


  createDashboard(DashboardModel dashboardModel) async {
    // gets new id
    // deleteDashboard();

    String id = db.collection('dashboard').doc().id;
    print('creating the dashboard category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('dashboard_ID', id);
// save the item
    return await db.collection('dashboard').doc(id).set({
      'dashboardModel': dashboardModel,
    }).then((value) => getDashboard());
  }

  deleteDashboard()async{
    print('deleting  the dashboard category is awaken');
    SharedPreferences preferences = await sharedPref();
    String? id = preferences.getString('dashboard_ID',);
    print('deleting  the dashboard category with id $id');
    return await db.collection('dashboard').doc(id).delete();

  }


  getDashboard() async {
    return await db.collection('dashboard').get().then((value) {
         value!.forEach((key, value) {
           dashboardModel = DashboardModel.fromJson(value['dashboardModel']);
           print('items from the collection get dashboard data ${dashboardModel!.message}');
         });
    });

  }

}