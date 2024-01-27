part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}
 class LoginInitialEvent  extends LoginEvent{}


class LoginWithEmailIdAndPasswordEvent  extends LoginEvent{
final int mobileNo;
final int otp;
 LoginWithEmailIdAndPasswordEvent({required this.mobileNo,required this.otp});

}

class LoginQRChangingTheColorEvent extends LoginEvent {
 final int? index ;
 final bool? isRightButton ;
 final bool? isDownButton ;
 final bool? isUpButton ;
 final bool? isLeftButton ;
 LoginQRChangingTheColorEvent({this.index,
  this.isRightButton,
  this.isDownButton,this.isLeftButton,this.isUpButton});
}

class GetOtpEvent  extends LoginEvent{
 final int mobileNo;
 GetOtpEvent({required this.mobileNo,});

}

class BarCodeAddingEvent  extends LoginEvent{
 final String qrCode;
 BarCodeAddingEvent({required this.qrCode,});

}


class QRCodeScanningEvent  extends LoginEvent{
 final String? storingQRCode;
 final bool? isScannerOpen;
 QRCodeScanningEvent({this.storingQRCode,this.isScannerOpen});

}

class SapienceParentsDialogEvent  extends LoginEvent{
 // final int mobileNo;
 // SapienceParentsDialogEvent({required this.mobileNo,});

}


class SignUpWithEmailIdAndPasswordEvent  extends LoginEvent{
 final String email;
 final String password;
 SignUpWithEmailIdAndPasswordEvent({required this.email,required this.password});

}

