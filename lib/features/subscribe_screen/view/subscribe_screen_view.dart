import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/color_const.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:nimu_tv/config/method_channel.dart';
import 'package:nimu_tv/features/lkg_screen/bloc/bloc/lkg_bloc.dart';
import 'package:nimu_tv/features/lkg_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/razorpay/razorpay_widgets.dart';
import 'package:nimu_tv/features/subscribe_screen/bloc/subscribe_bloc.dart';
import 'package:nimu_tv/features/subscribe_screen/models/subscribe_models.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../config/circle_back_button.dart';
import '../../../config/circular_progressindicator.dart';
import '../../../config/custom_drawer.dart';
import '../../../config/utils.dart';
import '../../../main.dart';
import '../api/payment_status_api.dart';
import '../database_items/items_data.dart';

class SubscribeScreenView extends StatefulWidget {
  final int? sectionID;

  const SubscribeScreenView({Key? key,this.sectionID}) : super(key: key);

  @override
  State<SubscribeScreenView> createState() => _SubscribeScreenViewState();
}

class _SubscribeScreenViewState extends State<SubscribeScreenView> {
  final SubscribeBloc subscribeBloc = SubscribeBloc();
  bool isTv = false;
  SubscribeDatum? subscribeModel;

  @override
  void initState()  {
    // TODO: implement initState
    // print('checking the tv ${String.fromEnvironment('TV_MODE')}');



    print('checking the tv ${PlatformType.isTv}');
    // for(var item in SubscribeData.subscribeList){
    //   subscribeDataItems!.add(SubscribeModel(
    //     id: item['id'],
    //     title: item['title'],
    //     borderColor: item['borderColor'],
    //     price: double.parse(item['price']),
    //     isSelected: item['isSelected'] == true ? true : false,
    //   ));
    // }

    subscribeBloc.add(SubscribeInitialEvent(
      subscribeModels: subscribeDataItems,
      sectionID: widget.sectionID,
    ));
    super.initState();
  }




  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<SubscribeBloc, SubscribeState>(
      bloc: subscribeBloc,
      listenWhen: (previous, current) => current is SubscribeActionState,
      buildWhen: (previous, current) => current is! SubscribeActionState,
      listener: (context, state) {
        if (state is SubscribeActionButtonState) {
          ScaffoldMessenger.of(context)
              .showSnackBar( SnackBar(content: Text('${state.title}  : ${state.price}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        } else if (state is SubscribeBackActionButtonState) {

          print('checking the index ${widget.sectionID} sectionID ${widget.sectionID}');
          switchingBetweenDifferentWidget(index: widget.sectionID,context: context,sectionID: widget.sectionID);

          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('LKG Back Button Pressed')));
        }
        // else if (state is LoginButtonErrorState) {
        //   if (state.error.isNotEmpty) {
        //     ScaffoldMessenger.of(context)
        //         .showSnackBar(SnackBar(content: Text(state.error)));
        //   }
        // } else if (state is SignUpButtonLoadedSuccessState) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Account created successfully')));
        // } else if (state is SignUpButtonLoadingState) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Creating please wait ....')));
        // } else if (state is SignUpButtonErrorState) {
        //   if (state.error.isNotEmpty) {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         content: Text(
        //             '${state.error},databse error ${state.databaseError}')));
        //   }
        // }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case SubscribeInitialLoadingState:
            return  circularProg!;
          case SubscribeInitialLoadedSuccessState:
            final successState = state as SubscribeInitialLoadedSuccessState;

            double baseWidth = 800.0000610352;
            double fem = MediaQuery.of(context).size.width / baseWidth;
            double ffem = fem * 0.97;

            return Scaffold(
                body: Container(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(7*fem, 8*fem, 35*fem, 7*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                      image: DecorationImage (
                        fit: BoxFit.cover,
                        image: AssetImage (
                          'assets/lkg_bc.png',
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 38*fem, 0*fem),
                          padding: EdgeInsets.fromLTRB(8*fem, 7*fem, 8*fem, 74*fem),
                          width: 466*fem,
                          height: 345*fem,
                          decoration: BoxDecoration (
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(9*fem),
                          ),
                          child: Column(
                            children: [

                              // SizedBox(
                              //     height: double.maxFinite,
                              //     width: double.maxFinite,
                              //     child: Image.asset(
                              //       'assets/lkg_bc.png',
                              //       fit: BoxFit.fill,
                              //     )
                              //   // .animate(onPlay: (controller) => controller.repeat())
                              //   // .effect(duration: 3000.ms) // this "pads out" the total duration
                              //   // .effect(delay: 750.ms, duration: 1500.ms).slideY().shake().shimmer(),
                              // ),



                              // SizedBox(
                              //   height: double.maxFinite,
                              //   width: double.maxFinite,
                              //   child:SvgPicture.asset(
                              //     'assets/mushroom.svg',
                              //     semanticsLabel: 'Acme Logo',
                              //     fit: BoxFit.fill,
                              //   )
                              //       .animate(onPlay: (controller) => controller.repeat())
                              //       .effect(
                              //       duration:
                              //       3000.ms) // this "pads out" the total duration
                              //       .effect(delay: 750.ms, duration: 1500.ms)
                              //       .shimmer(),
                              // ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 300*fem, 41*fem),
                                width: double.infinity,
                                // child: Text('Damascus'),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleButton(
                                      // splashColor: Colors.red,
                                      isBackButton: true,
                                      onTap: () {
                                        subscribeBloc.add(SubscribeBackNavigateButtonEvent());
                                      },
                                    ),
                                    Container(
                                      // subscribeFJq (39:3163)
                                      margin: EdgeInsets.fromLTRB(0*fem, 1*fem, 0*fem, 0*fem),
                                      child: Text(
                                        'SUBSCRIBE',
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 0.6449999809*ffem/fem,
                                          color: Color(0xff787b7c),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // ifyourchildisstudyingsapiencec (39:3414)
                                margin: EdgeInsets.fromLTRB(6*fem, 0*fem, 0*fem, 17*fem),
                                constraints: BoxConstraints (
                                  maxWidth: 350*fem,
                                ),
                                child: Text(
                                  '"If your child is studying Sapience Curriculum in any of the schools, kindly approach the school management to collect your password to activate all the videos".',
                                  style: SafeGoogleFont (
                                    'Poppins',
                                    fontSize: 12*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xff787b7c),
                                  ),
                                ),
                              ),
                              Container(
                                // ifyouareanonsapienceparentwhos (41:459)
                                margin: EdgeInsets.fromLTRB(3*fem, 0*fem, 0*fem, 22*fem),
                                constraints: BoxConstraints (
                                  maxWidth: 347*fem,
                                ),
                                child: Text(
                                  'If you are a non-sapience parent whose child is not studying the sapience curriculum in any schools, you can pay for the app to avail the opportunity.',
                                  style: SafeGoogleFont (
                                    'Poppins',
                                    fontSize: 12*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xff787b7c),
                                  ),
                                ),
                              ),
                              Container(
                                // subscribingtolkgvideoscanavail (41:460)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 6*fem, 0*fem),
                                constraints: BoxConstraints (
                                  maxWidth: 338*fem,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: SafeGoogleFont (
                                      'Poppins',
                                      fontSize: 12*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5*ffem/fem,
                                      color: Color(0xff787b7c),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Subscribing to LKG videos can avail of KIDS FOOD VIDEOS\nfree of cost, worth ',
                                      ),
                                      TextSpan(
                                        text: 'Rs.350.',
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 12*ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff787b7c),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          // group427319502wWR (41:457)
                          width: 254*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // chooseplanG2u (41:388)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 11*fem),
                                child: Text(
                                  'Choose Plan',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont (
                                    'Poppins',
                                    fontSize: 14*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5*ffem/fem,
                                    letterSpacing: 1*fem,
                                    color: Color(0xff4b4b51),
                                  ),
                                ),
                              ),
                              SubscribeWidget1(height: height, width: width, title: '${successState.subscribeModels![0].title}',  price: '₹${successState.subscribeModels![0].price}',
                                isSelected: successState.subscribeModels![0].isSelected!, index: 0,
                                subscribeBloc: subscribeBloc,
                              ),
                              SubscribeWidget1(height: height, width: width, title: '${successState.subscribeModels![1].title}',  price: '₹${successState.subscribeModels![1].price}',
                                isSelected: successState.subscribeModels![1].isSelected!, index: 1,
                                subscribeBloc: subscribeBloc,
                              ),
                              SubscribeWidget1(height: height, width: width, title: '${successState.subscribeModels![2].title}',  price: '₹${successState.subscribeModels![2].price}',
                                isSelected: successState.subscribeModels![2].isSelected!, index: 2,
                                subscribeBloc: subscribeBloc,
                              ),
                              SubscribeWidget1(height: height, width: width, title: '${successState.subscribeModels![3].title}',  price: '₹${successState.subscribeModels![3].price}',
                                isSelected: successState.subscribeModels![3].isSelected!, index: 3,
                                subscribeBloc: subscribeBloc,
                              ),
                              TextButton(
                                // buttonK6y (41:473)
                                onPressed: () {
                                  for(var item in successState.subscribeModels!){
                                    if(item.isSelected == true){
                                      // print('test the selected price ${item.price}');
                                      // razorpayIntegration(item.price.toDouble());
                                      subscribeModel = item;
                                      Razorpay razorpay = Razorpay();
                                      var options = {
                                        'key': 'rzp_test_obd9d7YNR4H4JY',
                                        'amount': item.price.toDouble() * 100,
                                        'name': 'Acme Corp.',
                                        'description': 'Fine T-Shirt',
                                        'retry': {'enabled': true, 'max_count': 1},
                                        'send_sms_hash': true,
                                        'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                                        'external': {
                                          'wallets': ['paytm']
                                        }
                                      };
                                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                                      razorpay.open(options);

                                    }
                                  }
                                },
                                style: TextButton.styleFrom (
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 40*fem,
                                  decoration: BoxDecoration (
                                    borderRadius: BorderRadius.circular(20*fem),
                                    gradient: RadialGradient (
                                      center: Alignment(0.726, -0.425),
                                      radius: 1.12,
                                      colors: <Color>[Color(0xffe97d1e), Color(0xfff8b67b)],
                                      stops: <double>[0, 1],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3f000000),
                                        offset: Offset(0*fem, 4*fem),
                                        blurRadius: 17*fem,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'SUBSCRIBE',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Poppins',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          case LkgInitialErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
   handlePaymentErrorResponse(PaymentFailureResponse response,){




    SubscriptionStatus.sendingStatusToApi(subscriptionId: subscribeModel!.id,amount: subscribeModel!.price,log: response.message,status: 'failed' );

    showAlertDialog(context, 'Payment Failed', 'Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}');
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    SubscriptionStatus.sendingStatusToApi(subscriptionId: subscribeModel!.id,amount: subscribeModel!.price,log: 'payment ID : ${response.paymentId} order ID : ${response.orderId}',status: 'paid' );

    showAlertDialog(context, 'Payment Successful', 'Payment ID: ${response.paymentId}');
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){

    SubscriptionStatus.sendingStatusToApi(subscriptionId: subscribeModel!.id,amount: subscribeModel!.price,log: 'walletName : ${response.walletName}',status: 'paid' );


    showAlertDialog(context, 'External Wallet Selected', '${response.walletName}');
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = Container(
      margin: const EdgeInsets.all(12),
      height: MediaQuery.sizeOf(context).height * 0.08,
      width: MediaQuery.sizeOf(context).width * 0.24,
      decoration:   BoxDecoration(
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(12),
        gradient:  const RadialGradient(
          radius: 2,
          // focalRadius: 5,
          colors: [Color(0xFFE77817), Color(0xFFF8B57B)],

        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
        ),
        child: const Text('ok'),
        onPressed:  () {
          Navigator.pop(context);
        },
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}




class SubscribeScreenExtentWidget extends StatefulWidget {

  const SubscribeScreenExtentWidget({Key? key,this.subscribeModelsList,this.subscribeBloc}) : super(key: key);

  final List<SubscribeModel>? subscribeModelsList ;
  final SubscribeBloc? subscribeBloc ;

  @override
  State<SubscribeScreenExtentWidget> createState() => _SubscribeScreenExtentWidgetState();


}
class _SubscribeScreenExtentWidgetState extends State<SubscribeScreenExtentWidget> {


  @override
  void initState() {
    // TODO: implement initState
    // widget.subscribeModelsList![0].isSelected = true;
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  final double _height = 100.0;

  int listViewValue = 0;

  void _animateToIndex(int index,double width) {
    _controller.animateTo(
      index * width * 0.2,
      duration: const Duration(seconds: 3),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) async {
        print("1) ${event.data}");
        print("2) ${event.character.toString()}");
        print("3) ${event.toString()}");
        print("4) ${event.physicalKey.debugName}");
        print("5) ${event.logicalKey.keyId}");
        print("6) ${event.logicalKey}");
        print("7) ${event.isKeyPressed(LogicalKeyboardKey.enter)}");
        print("7) ${LogicalKeyboardKey.enter}");



        var snackBar = SnackBar(
          content: Text('${widget.subscribeModelsList![listViewValue].title}'),
        );


        // ScaffoldMessenger.of(context).showSnackBar(snackBar);


        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                widget.subscribeBloc!.add(SubscribeNavigateButtonEvent());
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // if (widget.controller.value.isPlaying) {
                //   widget.controller.pause();
                // } else {
                //   widget.controller.play();
                // }
              });
              break;
            case 'Enter':
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // if (widget.controller.value.isPlaying) {
                //   widget.controller.pause();
                // } else {
                //   widget.controller.play();
                // }
              });
              break;
          }
        }


        //
        // else  if (LogicalKeyboardKey.arrowDown == event.logicalKey) {
        //
        //   debugPrint('arrowDown listViewValue $listViewValue widget.lkgProducts!.length ${widget.subscribeModelsList!.length}');
        //
        //   if(listViewValue < widget.subscribeModelsList!.length-1){
        //     widget.subscribeBloc!.add(SubscribeChangingTheColorEvent(index: listViewValue,isDownButton: true));
        //
        //     _animateToIndex(listViewValue=listViewValue+1, height);
        //   }
        //
        // }
        // else  if (LogicalKeyboardKey.arrowUp == event.logicalKey) {
        //
        //   debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${widget.subscribeModelsList!.length}');
        //   if(listViewValue>0){
        //     widget.subscribeBloc!.add(SubscribeChangingTheColorEvent(index: listViewValue,isDownButton: false));
        //     _animateToIndex(listViewValue=listViewValue-1, height);
        //   }
        //
        // }

        if (event is RawKeyDownEvent) {

          print('--> ${event.data.keyLabel}');
          // handle key down
        } else if (event is RawKeyUpEvent) {
          // handle key up
        }
      },
      child:Column(
        children: [
        SizedBox(
        height: height * 0.1,
        width: width * 0.3,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(12)),
          ),
          onPressed: () {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('${widget.lkgProducts![i].title}'),
            // ));
          },
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(12)),
                color: widget.subscribeModelsList![0].borderColor != null
                    &&
                    widget.subscribeModelsList![0].isSelected == true
                    ? Colors.orange : null,
                child: const Center(child: Text('')),
              ),
              SizedBox(
                width: width * 0.25,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${widget.subscribeModelsList![0].title}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '₹ ${widget.subscribeModelsList![0].price}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        20.ph,
        Container(
        height: height * 0.1,
        width: width * 0.3,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(12)),
          ),
          onPressed: () {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('${widget.lkgProducts![i].title}'),
            // ));
          },
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(12)),
                color: widget.subscribeModelsList![1].borderColor != null
                    &&
                    widget.subscribeModelsList![1].isSelected == true
                    ? Colors.orange : null,
                child: const Center(child: Text('')),
              ),
              SizedBox(
                width: width * 0.25,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${widget.subscribeModelsList![1].title}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '₹ ${widget.subscribeModelsList![1].price}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

        ],
      ),
    );
  }
}


class SubscribeWidget1 extends StatelessWidget {
  const SubscribeWidget1({
    Key? key,
    required this.height,required this.price,
    required this.width, required this.title,
    required this.isSelected, required this.index,
    required this.subscribeBloc,
  }) : super(key: key);

  final double height;
  final double width;
  final String title;
  final String price;
  final bool isSelected;
  final int index;
  final SubscribeBloc? subscribeBloc ;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 800.0000610352;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    Color prim = Color(0xffe77817);
    Color sec = Color(0xff00588E);

return
    InkWell(
      onTap: (){
        subscribeBloc!.add(SubscribeChangingTheColorEvent(index: index,));
        subscribeBloc!.add(SubscribeNavigateButtonEvent(title: title,price: price));
      },
      child: Container(
        // group427319498Ae5 (41:430)
        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
        padding: EdgeInsets.fromLTRB(12*fem, 3*fem, 10*fem, 1*fem),
        width: double.infinity,
        height: 40*fem,
        decoration: BoxDecoration (
          // colors: [isSelected == true ? primaryOrange : Colors.white,
          color: isSelected == true ?prim : Colors.white,
          borderRadius: BorderRadius.circular(24.4318180084*fem),
          border: Border.all(color: sec)
        ),
        child: SizedBox(
          // group427319497TdB (41:429)
          width: double.infinity,
          height: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // freetrialCqf (41:410)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 20*fem, 0*fem),
                child: Text(
                  title,
                  // '90 Days Subscription',
                  style: SafeGoogleFont (
                    'Poppins',
                    fontSize: 12*ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.5*ffem/fem,
                    letterSpacing: 1*fem,
                    color:
                    isSelected == false ? sec : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                // 7Bw (41:413)
                '$price',
                style: SafeGoogleFont (
                  'Poppins',
                  fontSize: 24*ffem,
                  fontWeight: FontWeight.w600,
                  height: 1.5*ffem/fem,
                  letterSpacing: 1*fem,
                  color: isSelected == false ? Colors.black : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );


    // return Container(
    //   // margin: const EdgeInsets.all(1),
    //   height: 40,
    //   width: 200 * fem,
    //   decoration:   BoxDecoration(
    //     // shape: BoxShape.circle,
    //     border: Border.all(color: primaryBlue),
    //     borderRadius: BorderRadius.circular(12),
    //     gradient:   RadialGradient(
    //       radius: 2,
    //       // focalRadius: 5,
    //       colors: [isSelected == true ? primaryOrange : Colors.white,
    //         isSelected == true ? primaryOrange :  Colors.white,],
    //
    //     ),
    //   ),
    //   child:
    //
    //
    //   ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Colors.transparent,
    //       shadowColor: Colors.transparent,
    //       shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
    //     ),
    //     onPressed: () {
    //           subscribeBloc!.add(SubscribeChangingTheColorEvent(index: index,));
    //           subscribeBloc!.add(SubscribeNavigateButtonEvent(title: title,price: price));
    //
    //     },
    //     child:
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Text(
    //           title,
    //           textAlign: TextAlign.center,
    //           style: GoogleFonts.poppins(
    //               fontSize: 14,
    //               fontWeight: FontWeight.bold,
    //               color:
    //               isSelected == false ? primaryBlue : Colors.white,
    //               ),
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //         Text(
    //           price,
    //           textAlign: TextAlign.end,
    //           style: GoogleFonts.poppins(
    //               fontSize: 14,
    //               fontWeight: FontWeight.bold,
    //               color:
    //               isSelected == false ? primaryBlue : Colors.white,
    //           ),
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ],
    //     )
    //
    //
    //   ),
    // );
  }
}
