import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/login_screen/models/login_model.dart';
import 'package:nimu_tv/features/login_screen/models/qrModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../api/login_api.dart';
import '../database/local_database.dart';
import '../models/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginWithEmailIdAndPasswordEvent>(loginWithEmailIdAndPasswordEvent);
    on<GetOtpEvent>(getOtpEvent);
    on<BarCodeAddingEvent>(barCodeAddingEvent);
    on<SapienceParentsDialogEvent>(sapienceParentsDialogEvent);
    on<LoginQRChangingTheColorEvent>(loginQRChangingTheColorEvent);
    on<QRCodeScanningEvent>(qrCodeScanningEvent);

    on<SignUpWithEmailIdAndPasswordEvent>(signUpWithEmailIdAndPasswordEvent);
  }

  FutureOr<void> sapienceParentsDialogEvent(SapienceParentsDialogEvent event, Emitter<LoginState> emit) {

    emit(SapienceParentDialogButtonLoadedSuccessState());

    // var error;
    //
    // emit(LoginButtonLoadingState());
    // try {
    //
    //   Response   response = await MobileApi.loginWithOtp(mobileNo: event.mobileNo,otp: event.otp);
    //
    //   error = json.decode(response.body);
    //
    //   print('error value $error');
    //
    //   if(response.statusCode == 200){
    //     emit(LoginButtonLoadedSuccessState());
    //   }
    //   else
    //   {
    //     emit(LoginButtonErrorState(error: error['data']['error']));
    //   }
    //
    //
    //   // print('isLoggedIn $isLoggedIn');
    // } catch (e) {
    //   emit(LoginButtonErrorState(error: e.toString()));
    // }


  }






  FutureOr<void> loginQRChangingTheColorEvent(LoginQRChangingTheColorEvent event, Emitter<LoginState> emit) {

    int? index;

    if(event.isDownButton!=null && event.isDownButton== true){
      index = 4;

    }
    else  if(event.isUpButton!=null && event.isUpButton== true){
      index = 3;

    }
    else  if(event.isRightButton!=null && event.isRightButton== true){
      index = 2;

    }
    else  if(event.isLeftButton!=null && event.isLeftButton== true){
      print('left button pressed');
      index = 1;

    }

    switch(index){
      case 1 :
        sapienceParentsModelList[1].isSelected = false;
        sapienceParentsModelList[0].isSelected = true;
        try {
          emit(LoginLoadedSuccessState(
            // sapienceParentsModelList: sapienceParentsModelList
          ));
        } catch (e) {
          emit(LoginErrorState());
        }
        break;
      case 2 :
        sapienceParentsModelList[0].isSelected = false;
        sapienceParentsModelList[1].isSelected = true;

        for(var item in sapienceParentsModelList){
          print('title ${item.title} isSelected ${item.isSelected} index ${item.index}');
        }

        try {
          emit(LoginLoadedSuccessState());
        } catch (e) {
          emit(LoginErrorState());
        }
        break;
      case 3:
        sapienceParentsModelList[1].isSelected = false;
        sapienceParentsModelList[0].isSelected = false;
        try {
          emit(LoginLoadedSuccessState());
        } catch (e) {
          emit(LoginErrorState());
        }
        break;
      case 4:
        sapienceParentsModelList[1].isSelected = false;
        sapienceParentsModelList[0].isSelected = true;
        try {
          emit(LoginLoadedSuccessState());
        } catch (e) {
          emit(LoginErrorState());
        }
        break;
      default:
        break;

    }

    if(event.isRightButton!){

    }
    else
    {

    }

  }


  Future<FutureOr<void>> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    // emit(LoginLoadingState());
    // await Future.delayed(const Duration(seconds: 1));
    try {
      final List<SapienceParentModel> QRList ;

      sapienceParentsModelList.clear();
      for( var item in SapienceParentsData.parentList){
        sapienceParentsModelList.add(SapienceParentModel(
          title: item['title'],
          index: item['index'],
          isSelected: item['isSelected'],
        ));
      }

      await Future.delayed(const Duration(milliseconds: 100));

      emit(LoginLoadedSuccessState(
        sapienceParentsModelList: sapienceParentsModelList,
      ));
    } catch (e) {
      emit(LoginErrorState());
    }
  }

  Future<FutureOr<void>> loginWithEmailIdAndPasswordEvent(
      LoginWithEmailIdAndPasswordEvent event, Emitter<LoginState> emit) async {

    var error;

    emit(LoginButtonLoadingState());
    try {
      print('starting login api call ');

      Response   response = await MobileApi.loginWithOtp(mobileNo: event.mobileNo,otp: event.otp);
      LocalUserDatabase.instance.createUser(userModelFromJson(response.body));
// userData = userModelFromJson(response.body);
      await   Future.delayed(Duration(seconds: 1),() async {
        SharedPreferences preferences = await sharedPref();
        preferences.setInt('mobileNo', event.mobileNo);
        preferences.setString('token', userData!.data.token);
        preferences.setString('created_at', userData!.data.createdAt.toIso8601String());
        preferences.setString('updated_at', userData!.data.updatedAt.toIso8601String());
        preferences.setString('role', userData!.data.role);
        preferences.setInt('otp', event.otp);
        preferences.setBool('isLoggedIn', true);
        preferences.setBool('user_subscription',  userData!.data.userSubscription);

        print('checking the user subscription length ${userData!.data.subscriptionList.length}');

        for (var e in userData!.data.subscriptionList) {
          print('checking inside the subscription list map part ');
          var isLKGAvailable =  e.name.contains('LKG');
          var isUKGAvailable =  e.name.contains('UKG');
          var isKidsFoodVideoAvailable =  e.name.contains('KIDS FOOD VIDEO');

          print('checking the lkg contains ${ e.name.contains('LKG')} isLKGAvailable $isLKGAvailable');
          print('checking the ukg contains ${ e.name.contains('UKG')} isUKGAvailable $isUKGAvailable');

          if(isLKGAvailable == true){
            preferences.setBool('isLKGAvailable',  true);
            print('checking the lkg available ${preferences.getBool('isLKGAvailable',)}');
          }

          if(isUKGAvailable == true){
            preferences.setBool('isUKGAvailable',  true);
            print('checking the ukg available ${preferences.getBool('isUKGAvailable',)}');
          }
          if(isKidsFoodVideoAvailable == true){
            preferences.setBool('isKidsFoodVideoAvailable',  true);
            print('checking the kids food video available ${preferences.getBool('isKidsFoodVideoAvailable',)}');
          }
        }
      });

      error = json.decode(response.body);

      print('error value $error');
      print('login api status code  ${response.statusCode}');
      print('userData!.success  ${userData!.success}');

      if(response.statusCode == 200){
        emit(LoginButtonLoadedSuccessState(
          sapienceParentsModelList: sapienceParentsModelList
        ));
      }
      else
        {
          if(userData!.success == true) {
            emit(LoginButtonLoadedSuccessState(
                sapienceParentsModelList: sapienceParentsModelList
            ));
          } else
            {
              emit(LoginButtonErrorState(error: error['data']['error']));
            }
        }


      // print('isLoggedIn $isLoggedIn');
    } catch (e) {
      print('catch error from login api  $e');
      emit(LoginButtonErrorState(error: e.toString()));
    }

  }

  Future<FutureOr<void>> signUpWithEmailIdAndPasswordEvent(
      SignUpWithEmailIdAndPasswordEvent event, Emitter<LoginState> emit) async {
    bool isLoggedIn = false;
    String? status = '';
    String? databaseStatus = '';

    emit(SignUpButtonLoadingState());
    try {
      // isLoggedIn = LoginApi.signUpWithEmailAndPassword(
      //   email: event.email,
      //   password: event.password,
      // );
      if (isLoggedIn) {
        try {
          // CreateUserDocument.createUserDoc(
          //     userEmail: event.email, userName: 'venkat');
        } catch (e) {
          databaseStatus = e.toString();
        }
      }

      print('isLoggedIn $isLoggedIn');
    } catch (e) {
      status = e.toString();
    }

    if (isLoggedIn) {
      emit(SignUpButtonLoadedSuccessState());
    } else {
      emit(SignUpButtonErrorState(
          error: status, databaseError: databaseStatus!));
    }
  }

  Future<FutureOr<void>> barCodeAddingEvent(BarCodeAddingEvent event, Emitter<LoginState> emit) async {

    var responseValue;

    emit(BarCodeAddingButtonLoadingState());
    try {
      SharedPreferences preferences = await sharedPref();
      final String? token = preferences.getString('token');
      debugPrint(' checking the token value $token');

      Response   response = await MobileApi.getPromoCodeStatus(qrCode: event.qrCode,token: token);

      responseValue = json.decode(response.body);
      qrModel = QrModel.fromJson(responseValue);

      print('error value $responseValue');

      if(response.statusCode == 200){
        emit(BarCodeAddingButtonLoadedSuccessState(
          // message: responseValue['message']
        ));
      }
      else
      {
        emit(GetOtpButtonErrorState(error: qrModel!.message));
      }


      // print('isLoggedIn $isLoggedIn');
    } catch (e) {
      emit(GetOtpButtonErrorState(error: e.toString()));
    }
  }
  Future<FutureOr<void>> getOtpEvent(GetOtpEvent event, Emitter<LoginState> emit) async {

    var responseValue;

    emit(GetOtpButtonLoadingState());
    try {

      Response   response = await MobileApi.getOtp(mobileNo: event.mobileNo,);

      responseValue = json.decode(response.body);

      print('error value $responseValue');

      if(response.statusCode == 200){
        emit(GetOtpButtonLoadedSuccessState(
          message: responseValue['message']
        ));
      }
      else
      {
        emit(GetOtpButtonErrorState(error: responseValue['data']['error']));
      }


      // print('isLoggedIn $isLoggedIn');
    } catch (e) {
      emit(GetOtpButtonErrorState(error: e.toString()));
    }
  }

  Future<FutureOr<void>> qrCodeScanningEvent(QRCodeScanningEvent event, Emitter<LoginState> emit) async {

    emit(QRCodeButtonLoadingState());

    try {
      print('checking the scanner open true or false ${event.isScannerOpen}');
     if( event.isScannerOpen == true ){
       emit(QRCodeState(storingQRCode: event.storingQRCode,isScannerOpen: event.isScannerOpen ));
     }
     else
       {
         emit(QRCodeButtonSuccessState(isScannerOpen: event.isScannerOpen));
       }
      // await Future.delayed(const Duration(milliseconds: 500));
      // Navigator.pop(context);

    }
    catch (e){
      emit(QRCodeButtonErrorState(error: '${e.toString()}', databaseError: 'DatabaseError'));
    }

  }
}

