import 'dart:ffi';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/mute_button_config.dart';
import 'package:nimu_tv/features/dashboard_screen/bloc/dashboard_screen_bloc.dart';
import 'package:nimu_tv/features/lkg_screen/view/lkg_screen.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/splash_screen/view/splash_screen_view.dart';
import 'package:nimu_tv/local_download/local_dashboard_screen_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/audio_player.dart';
import '../../../config/check_internet_connection.dart';
import '../../../config/circle_back_button.dart';
import '../../../config/circular_progressindicator.dart';
import '../../../config/color_const.dart';
import '../../../config/custom_drawer.dart';
import '../../../config/image_picker_scanner.dart';
import '../../../config/shared_preference.dart';
import '../../../config/utils.dart';
import '../../../local_download/isolates_download.dart';
import '../../login_screen/view/qr_code.dart';


class DashboardScreenView extends StatefulWidget {
  const DashboardScreenView({Key? key}) : super(key: key);

  @override
  State<DashboardScreenView> createState() => _DashboardScreenViewState();
}

class _DashboardScreenViewState extends State<DashboardScreenView> {
  final DashboardScreenBloc dashboardScreenBloc = DashboardScreenBloc();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey = GlobalKey<
      ScaffoldState>();
  Rx<bool>? isLKGAvailable = false.obs;
  Rx<bool>? isUKGAvailable = false.obs;


  checkingIsLKGAvailable() async {
    SharedPreferences preferences = await sharedPref();

    print('subscriptionList checkingIsLKGAvailable ${preferences.getBool(
      'isLKGAvailable',)}');

    isLKGAvailable!.value = preferences.getBool('isLKGAvailable',)!;
  }

  checkingIsUKGAvailable() async {
    SharedPreferences preferences = await sharedPref();

    print('subscriptionList checkingIsUKGAvailable ${preferences.getBool(
      'isUKGAvailable',)}');

    isUKGAvailable?.value = preferences.getBool('isUKGAvailable',)!;
  }

  @override
  void initState() {
    // TODO: implement initState



    checkingIsLKGAvailable();
    checkingIsUKGAvailable();

    dashboardScreenBloc.add(DashboardInitialScreenEvent());
    methodFunction(
        'proving the string value of B', A: 'providing the value of A');
    final receiverPort = ReceivePort();
    final token = RootIsolateToken.instance;


    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }

  methodFunction(String B, {String? A}) {
    print('value of A $A');
    print('value of B $B');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return BlocConsumer<DashboardScreenBloc, DashboardScreenState>(
      bloc: dashboardScreenBloc,
      listenWhen: (previous, current) => current is DashboardScreenActionState,
      buildWhen: (previous, current) => current is! DashboardScreenActionState,
      listener: (context, state) {
        if (state is DashboardBackActionButtonState) {
          Navigator.pop(context);
        }
        else if (state is DashboardActionButtonState) {
          print('dashboard action state section id ${state.sectionID}');
          switchingBetweenDifferentWidget(
              index: state.index, context: context, sectionID: state.sectionID);
        }
        else if (state is DashboardLogoutButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging out please wait ....')));
        }
        else if (state is DashboardLogoutButtonLoadedSuccessState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const SplashScreenView()), (
                  Route<dynamic> route) => false);
        }
        else if (state is DashboardLogoutButtonErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)));
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
          case DashboardLoadingState:
            return circularProg!;
          case DashboardLoadedSuccessState:
            final successState = state as DashboardLoadedSuccessState;
            double baseWidth = 800.0000610352;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;

            checkingIsLKGAvailable();
            checkingIsUKGAvailable();

            for (var element in successState.dashboardList) {
              if (element.name.contains('subscription')) {
                int i = successState.dashboardList.indexOf(element);
                successState.dashboardList.removeAt(i);
              }
            }

            return Scaffold(
                key: _drawerScaffoldKey,
                // appBar: AppBar(
                //   backgroundColor: Colors.orange,
                //   title: const Center(
                //       child: Text(
                //         'Login',
                //         style: TextStyle(color: Colors.white),
                //       )),
                // ),
                drawer: CustomDrawer(
                  width: width,
                  height: height,
                  logOut: () {
                    dashboardScreenBloc.add(LogoutEvent());
                  },
                  backButton: () {
                    dashboardScreenBloc.add(DashboardBackNavigateButtonEvent());
                  },
                  scanQR: () {
                    Navigator.pushAndRemoveUntil(context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 100),
                            child: QRViewPage()), (
                            Route<dynamic> route) => true);
                  },
                  dashboardList: successState.dashboardList.map((e) =>
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          minVerticalPadding: 1,
                          // tileColor: Colors.orange.shade50,
                          selectedTileColor: Colors.orange.shade50,
                          selectedColor: primaryOrange,
                          selected: e.isSelected!,
                          title: Text(e.name,
                            style: GoogleFonts.poppins(fontWeight: FontWeight
                                .bold),),
                          textColor: primaryBlue,
                          onTap: () {
                            // Navigator.pop(context);
                            debugPrint('checking the index on onTap ${e
                                .index} Name ${e.name}');
                            int i = successState.dashboardList.indexOf(e);

                            dashboardScreenBloc.add(
                                DashboardChangingTheColorEvent(index: e.index,
                                    dashboardList: successState.dashboardList,
                                    sectionID: e.index));
                          },
                        ),
                      ),).toList(),
                ),
                body: Container(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        // homepage1GXT (12:15)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 800 * fem,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            child: Image.asset(
                              'assets/dashboard(1).jpg',
                              fit: BoxFit.cover,
                            ).animate().effect(duration: 3000
                                .ms) // this "pads out" the total duration
                                .effect(duration: 500.ms).scaleX()
                                .animate(
                                onPlay: (controller) => controller.repeat())
                                .effect(duration: 3000
                                .ms) // this "pads out" the total duration
                                .effect(delay: 750.ms, duration: 1500.ms)
                                .shimmer(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16 * fem,
                        top: 15 * fem,
                        child: CircleButton(
                            onTap: () {
                              if (_drawerScaffoldKey.currentState!
                                  .isDrawerOpen) {
                                //if drawer is open, then close the drawer
                                Navigator.pop(context);
                              } else {
                                _drawerScaffoldKey.currentState!.openDrawer();
                                //if drawer is closed then open the drawer.
                              }
                            }, iconData: Icons.menu),
                      ),
                      Obx(() {
                        return Positioned(
                          left: 234 * fem,
                          top: 139 * fem,
                          child: Container(
                            width: Get.width / 1.5,
                            height: 170 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  97.3562927246 * fem),
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DashboardWidget1(
                                  topic1:
                                  isLKGAvailable == true ?
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem,
                                        20 * fem, 0 * fem),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        print(
                                            'checking the event index ${successState
                                                .dashboardList[0].index}');
                                        dashboardScreenBloc.add(
                                            DashboardChangingTheColorEvent(
                                              index: successState
                                                  .dashboardList[0].index,
                                              dashboardList: successState
                                                  .dashboardList,
                                              sectionID: successState
                                                  .dashboardList[0].index,));
                                      },
                                      child: Container(
                                        width: 131 * fem,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              97.3562927246 * fem),
                                          gradient: RadialGradient(
                                            center: Alignment(0.66, -0.463),
                                            radius: 1.01,
                                            colors: const <Color>[
                                              Color(0xffe77817),
                                              Color(0xfff7b57a)
                                            ],
                                            stops: const <double>[0, 1],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x33000000),
                                              offset: Offset(
                                                  0 * fem, 11.6827545166 * fem),
                                              blurRadius: 16 * fem,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'LKG',
                                            // successState.dashboardList[0].name,
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 18 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink(),
                                  topic2:
                                  isUKGAvailable == true ?
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 70 * fem, 0 * fem),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        dashboardScreenBloc.add(
                                            DashboardChangingTheColorEvent(
                                              index: 2,
                                              dashboardList: successState
                                                  .dashboardList,
                                              sectionID:  successState
                                                  .dashboardList[1].index,));
                                        print('checking the section id ${ successState.dashboardList[1].index}');
                                      },
                                      child: Container(
                                        width: 131 * fem,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              97.3562927246 * fem),
                                          gradient: RadialGradient(
                                            center: Alignment(0.66, -0.463),
                                            radius: 1.01,
                                            colors: const <Color>[
                                              Color(0xffe77817),
                                              Color(0xfff7b57a)
                                            ],
                                            stops: const <double>[0, 1],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x33000000),
                                              offset: Offset(
                                                  0 * fem, 11.6827545166 * fem),
                                              blurRadius: 16 * fem,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'UKG',
                                            // successState.dashboardList[1].name,
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 18 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5 * ffem / fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink(),
                                ),
                                // DashboardWidget1(
                                //   topic1:  Container(
                                //     margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 70*fem, 0*fem),
                                //     child: TextButton(
                                //       style:  TextButton.styleFrom (
                                //         padding:  EdgeInsets.zero,
                                //       ),
                                //       onPressed: () {
                                //         dashboardScreenBloc.add(DashboardChangingTheColorEvent(index: successState.dashboardList[2].index,
                                //             dashboardList: successState.dashboardList,sectionID: successState.dashboardList[2].index,));
                                //       },
                                //       child:  Container(
                                //         width:  131*fem,
                                //         height:  double.infinity,
                                //         decoration:  BoxDecoration (
                                //           borderRadius:  BorderRadius.circular(97.3562927246*fem),
                                //           gradient:  RadialGradient (
                                //             center:  Alignment(0.66, -0.463),
                                //             radius:  1.01,
                                //             colors:  const <Color>[Color(0xffe77817), Color(0xfff7b57a)],
                                //             stops:  const <double>[0, 1],
                                //           ),
                                //           boxShadow:  [
                                //             BoxShadow(
                                //               color:  Color(0x33000000),
                                //               offset:  Offset(0*fem, 11.6827545166*fem),
                                //               blurRadius:  16*fem,
                                //             ),
                                //           ],
                                //         ),
                                //         child: Center(
                                //           child: Text(
                                //             successState.dashboardList[2].name,
                                //             textAlign:  TextAlign.center,
                                //             style:  SafeGoogleFont (
                                //               'Poppins',
                                //               fontSize:  18*ffem,
                                //               fontWeight:  FontWeight.w600,
                                //               height:  1.5*ffem/fem,
                                //               color:  Color(0xffffffff),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                //   topic2:  Container(
                                //     margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 70*fem, 0*fem),
                                //     child: TextButton(
                                //       style:  TextButton.styleFrom (
                                //         padding:  EdgeInsets.zero,
                                //       ),
                                //       onPressed: () {
                                //         dashboardScreenBloc.add(DashboardChangingTheColorEvent(index:successState.dashboardList[3].index,
                                //           dashboardList: successState.dashboardList,sectionID: successState.dashboardList[3].index,));
                                //       },
                                //       child:  Container(
                                //         width:  131*fem,
                                //         height:  double.infinity,
                                //         decoration:  BoxDecoration (
                                //           borderRadius:  BorderRadius.circular(97.3562927246*fem),
                                //           gradient:  RadialGradient (
                                //             center:  Alignment(0.66, -0.463),
                                //             radius:  1.01,
                                //             colors:  const <Color>[Color(0xffe77817), Color(0xfff7b57a)],
                                //             stops:  const <double>[0, 1],
                                //           ),
                                //           boxShadow:  [
                                //             BoxShadow(
                                //               color:  Color(0x33000000),
                                //               offset:  Offset(0*fem, 11.6827545166*fem),
                                //               blurRadius:  16*fem,
                                //             ),
                                //           ],
                                //         ),
                                //         child: Center(
                                //           child: Text(
                                //             successState.dashboardList[3].name,
                                //             textAlign:  TextAlign.center,
                                //             style:  SafeGoogleFont (
                                //               'Poppins',
                                //               fontSize:  13 *ffem,
                                //               fontWeight:  FontWeight.w600,
                                //               height:  1.5*ffem/fem,
                                //               color:  Color(0xffffffff),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      }),
                      muteButtonConfig(),
                    ],
                  ),
                )
            );
          case DashboardErrorState:
            final errorState = state as DashboardErrorState;
            RxString? val = ''.obs;
            CheckInternetConnection.instance.checkInternet().then((value) {
              print('v--> ${value.toString()}');
              if (value.toString() == 'none') {
                val.value = 'No Internet Connection';
              }
              else {
                val.value =  'Error ${errorState.error}';
              }
            });

            return Obx(() {
              return Scaffold(
                  body: Center(
                      child: Text(val.value)));
            });
          default:
            return const SizedBox();
        }
      },
    );
  }


}


class DashboardWidget1 extends StatelessWidget {
  const DashboardWidget1({
    Key? key,
    required this.topic1,
    required this.topic2,
  }) : super(key: key);


  final Widget topic1;
  final Widget topic2;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 800.0000610352;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // color: Colors.green,
          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 42 * fem),
          width: double.infinity,
          height: 39 * fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              topic1,
              topic2 == SizedBox.shrink() ? SizedBox.shrink() : SizedBox(
                width: 10,),
              topic2,
            ],
          ),
        ),
      ],
    );
  }
}
