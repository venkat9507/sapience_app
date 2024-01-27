import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/subscribe_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/subscribe_screen/models/subscribe_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../api/subscribe_api.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc() : super(SubscribeInitial()) {
    on<SubscribeInitialEvent>(subscribeInitialEvent);
    on<SubscribeChangingTheColorEvent>(subscribeChangingTheColorEvent);
    on<SubscribeNavigateButtonEvent>(subscribeNavigateButtonEvent);
    on<SubscribeBackNavigateButtonEvent>(subscribeBackNavigateButtonEvent);
  }

  Future<FutureOr<void>> subscribeInitialEvent(
      SubscribeInitialEvent event, Emitter<SubscribeState> emit) async {
    var responseValue;
    emit(SubscribeInitialLoadingState());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the token subscription value $token');

      Response   response = await SubscribeApi.getSubscribeApi(token: token,sectionID: event.sectionID);

      responseValue = json.decode(response.body);
      subscriptionPlanModel = SubscriptionPlanModel.fromJson(responseValue);

      emit(SubscribeInitialLoadedSuccessState(
          subscribeModels: subscriptionPlanModel!.data));
    } catch (e) {
      emit(SubscribeInitialErrorState(error: 'error'));
    }
  }

  FutureOr<void> subscribeChangingTheColorEvent(
      SubscribeChangingTheColorEvent event, Emitter<SubscribeState> emit) {

    print('print the index ${event.index}');
    print('checking the selected subscription plan selected status'
        // ' ${subscribeDataItems![event.index!].isSelected}'
        // 'price ${subscribeDataItems![event.index!].price}'
        // 'title ${subscribeDataItems![event.index!].title}'
    );

    for(var item in subscriptionPlanModel!.data ){
      item.isSelected = false;
    }
    subscriptionPlanModel!.data[event.index!].isSelected = true;



    try {
      emit(SubscribeInitialLoadedSuccessState(
          subscribeModels: subscriptionPlanModel!.data
      ));
    } catch (e) {
      emit(SubscribeInitialErrorState(error: 'error $e'));
    }
  }

  FutureOr<void> subscribeNavigateButtonEvent(
      SubscribeNavigateButtonEvent event, Emitter<SubscribeState> emit) {
    emit(SubscribeActionButtonState(
      title: event.title,
      price: event.price,
    ));
  }

  FutureOr<void> subscribeBackNavigateButtonEvent(
      SubscribeBackNavigateButtonEvent event, Emitter<SubscribeState> emit) {
    emit(SubscribeBackActionButtonState());
  }
}
