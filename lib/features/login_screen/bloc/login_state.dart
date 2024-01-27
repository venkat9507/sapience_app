part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}
class QRCodeState extends LoginActionState {
   final String? storingQRCode;
  final bool? isScannerOpen;
  QRCodeState({this.storingQRCode,this.isScannerOpen});

}

class LoginLoadedSuccessState extends LoginState {
  final List<SapienceParentModel>? sapienceParentsModelList ;
  LoginLoadedSuccessState({this.sapienceParentsModelList});
}

class LoginErrorState extends LoginState {}

// class LoginButtonClickedState extends LoginState {}

class LoginButtonLoadingState extends LoginActionState {}

class LoginButtonLoadedSuccessState extends LoginActionState {
  final List<SapienceParentModel>? sapienceParentsModelList ;
  LoginButtonLoadedSuccessState({required this.sapienceParentsModelList});
}

class LoginButtonErrorState extends LoginActionState {
  final String error;
  LoginButtonErrorState({required this.error});
}

class SapienceParentDialogButtonLoadingState extends LoginActionState {}

class SapienceParentDialogButtonLoadedSuccessState extends LoginActionState {}

class SapienceParentDialogButtonErrorState extends LoginActionState {
  final String error;
  SapienceParentDialogButtonErrorState({required this.error});
}

class GetOtpButtonLoadingState extends LoginActionState {}

class GetOtpButtonLoadedSuccessState extends LoginActionState {
  final String message;
  GetOtpButtonLoadedSuccessState({required this.message});
}

class GetOtpButtonErrorState extends LoginActionState {
  final String error;
  GetOtpButtonErrorState({required this.error});
}

class BarCodeAddingButtonLoadingState extends LoginActionState {}

class BarCodeAddingButtonLoadedSuccessState extends LoginActionState {
  // final String qrCode;
  // BarCodeAddingButtonLoadedSuccessState({required this.qrCode});
}

class BarCodeAddingButtonErrorState extends LoginActionState {
  final String error;
  BarCodeAddingButtonErrorState({required this.error});
}

class SignUpButtonLoadingState extends LoginActionState {}

class SignUpButtonLoadedSuccessState extends LoginActionState {}

class QRCodeButtonLoadingState extends LoginActionState {}

class QRCodeButtonSuccessState extends LoginActionState {
  final bool? isScannerOpen;
  QRCodeButtonSuccessState({this.isScannerOpen});

}

class QRCodeButtonErrorState extends LoginActionState {
  final String error;
  final String databaseError;
  QRCodeButtonErrorState({required this.error, required this.databaseError});
}

class SignUpButtonErrorState extends LoginActionState {
  final String error;
  final String databaseError;
  SignUpButtonErrorState({required this.error, required this.databaseError});
}
