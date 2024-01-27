import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:nimu_tv/features/food_types_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/food_types_screen/models/food_types_models.dart';
import 'package:nimu_tv/features/food_types_screen/view/food_types_screen.dart';
import 'package:nimu_tv/features/lkg_screen/bloc/bloc/lkg_bloc.dart';
import 'package:nimu_tv/features/lkg_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/lkg_screen/view/lkg_screen.dart';
import 'package:nimu_tv/features/video/features/view/video.dart';
import 'package:nimu_tv/features/video/models/storingVideoCloseFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../config/check_internet_connection.dart';
import '../../../config/circle_back_button.dart';
import '../../../config/circular_progressindicator.dart';
import '../../../config/download_prompt.dart';
import '../../../config/mute_button_config.dart';
import '../../../config/utils.dart';
import '../../../food_inside_screen/view/food_inside_screen.dart';
import '../../../main.dart';
import '../../food_categories/database/item_data.dart';
import '../../video/features/database/item_data.dart';
import '../../video/features/view/video_player.dart';
import '../bloc/food_days_bloc.dart';
import '../database_items/items_data.dart';
import '../models/food_days_models.dart';


RxString foodDaysString = ''.obs;
class FoodDaysScreenView extends StatefulWidget {
  final String? title;

  const FoodDaysScreenView({Key? key, this.title,})
      : super(key: key);

  @override
  State<FoodDaysScreenView> createState() => _FoodDaysScreenViewState();
}

class _FoodDaysScreenViewState extends State<FoodDaysScreenView> {
  final FoodDaysBloc foodDaysBloc = FoodDaysBloc();

  @override
  void initState() {
    // TODO: implement initState

    // for (var item in LkgInsideData.lkgInsideProducts) {
    //   lkgInsideDataItems!.add(LkgInsideModel(
    //     id: item['id'],
    //     title: item['title'],
    //     subTitle: item['subTitle'],
    //     borderColor: item['borderColor'],
    //     thumbNail: item['thumbNail'],
    //     isSelected: bool.parse(item['isSelected'].toString()),
    //     watchHistory: item['watch_history'],
    //     rating: double.parse(item['rating']),
    //   ));
    // }

    foodDaysBloc.add(FoodDaysInitialEvent(
      // lkgInsideProducts: lkgInsideDataItems,
      // sectionID: widget.sectionID, videoCatID: widget.videoCatID,
      title: widget.title,
    ));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return BlocConsumer<FoodDaysBloc, FoodDaysState>(
      bloc: foodDaysBloc,
      listenWhen: (previous, current) => current is FoodDaysActionState,
      buildWhen: (previous, current) => current is! FoodDaysActionState,
      listener: (context, state) {
        if (state is FoodDaysActionButtonState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(seconds: 1),
                  child: FoodInsideScreenView(
                    foodDayID: foodDaysModel!.data[foodDaysModelIndex!].id,
                    foodTypeID: foodTypesModel!.data[foodTypesModelIndex!].id,
                    sectionID: storingFoodCategoryCloseModel!.sectionID,
                    foodCatID: storingFoodCategoryCloseModel!.foodCat,
                    title: state.title,
                  )), (Route<dynamic> route) => false);


          if (PlatformType.isTv) {
            // Navigator.push(
            //   context,
            //   PageTransition(
            //       type: PageTransitionType.scale,
            //       alignment: Alignment.center,
            //       duration: const Duration(milliseconds: 100),
            //       child: VideoScreenView(
            //         videoNumber: state.videoID,
            //         videosList: foodTypesModel!.data,
            //         isDownload: false,
            //       )),
            // );
          } else {
            isOnTap = false;
          }
        }
        else if (state is FoodDaysWatchOnlineActionButtonState) {
          // Navigator.push(
          //   context,
          //   PageTransition(
          //       type: PageTransitionType.scale,
          //       alignment: Alignment.center,
          //       duration: const Duration(milliseconds: 100),
          //       child: VideoScreenView(
          //         videoNumber: state.videoID,
          //         videosList: lkgInsideModel!.data,
          //         isDownload: false,
          //       )),
          // );


          // ScaffoldMessenger.of(context)
          //     .showSnackBar( SnackBar(content: Text('${state.videoID}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }

        else if (state is FoodDaysBackActionButtonState) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: FoodTypesScreenView(
                    title: storingFoodCategoryCloseModel!.title,
                  )),
                  (Route<dynamic> route) => true);


          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('back  button clicked')));
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
          case FoodDaysInitialLoadingState:
            return circularProg!;

          case FoodDaysInitialLoadedSuccessState:
            final successState = state as FoodDaysInitialLoadedSuccessState;
            double baseWidth = 800;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;

            return WillPopScope(
                onWillPop: () async {
                  foodDaysBloc
                      .add(FoodDaysBackNavigateButtonEvent());
                  return await true;
                },
                child: Scaffold(
                  // backgroundColor: Colors.white,
                  body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      // color: Colors.redAccent,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            1 * fem, 10 * fem, 0 * fem, 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/thumbnail.jpg',
                              // 'assets/BG.jpg',
                              // 'assets/lkg_bc.png',
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
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
                                  // const Positioned(
                                  //   left: 20,
                                  //   right: 20,
                                  //   top: 10,
                                  //   bottom: 20,
                                  //   child: Card(
                                  //     elevation: 10,
                                  //     color: Colors.white70,
                                  //   ),
                                  // ),
                                  Container(
                                    // autogroup9famZT7 (LLGDGH21KgmkDcDSTH9faM)
                                    margin: EdgeInsets.fromLTRB(
                                        15 * fem, 0 * fem, 100 * fem, 10 * fem),
                                    width: double.infinity,
                                    // color: Colors.redAccent,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          // menusyb (41:749)
                                          margin: EdgeInsets.fromLTRB(
                                              0 * fem, 0 * fem, 60 * fem,
                                              5 * fem),
                                          child: CircleButton(
                                            // splashColor: Colors.red,
                                            isBackButton: true,
                                            onTap: () {
                                              foodDaysBloc
                                                  .add(
                                                  FoodDaysBackNavigateButtonEvent());
                                            },
                                          ),
                                        ),
                                        Container(
                                          // group5AC1 (18:139)
                                          width: 197 * fem,
                                          height: 32 * fem,
                                          margin: EdgeInsets.only(
                                              left: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                8 * fem),
                                            gradient: RadialGradient(
                                              center: Alignment(-1.563, -2.188),
                                              radius: 3.7,
                                              colors: <Color>[
                                                Color(0xff00588e),
                                                Color(0xff99b3d6)
                                              ],
                                              stops: <double>[0, 1],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                    0 * fem,
                                                    11.6827545166 * fem),
                                                blurRadius: 16 * fem,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Obx(() {
                                              return Text(
                                                // storingOffset.value.toString(),
                                                // successState.title.toString(),
                                                foodDaysString.value.toString(),
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1 * ffem / fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  HomePage(
                                    foodDaysBloc: foodDaysBloc,
                                    foodDaysList: successState.foodDaysModel!
                                        .data,
                                  ),
                                  // Positioned(
                                  //   top: 20,
                                  //   left: 30,
                                  //   child: CircleButton(
                                  //       onTap: () {
                                  //        lkgInsideBloc.add(LkgInsideBackNavigateButtonEvent());
                                  //       },
                                  //       iconData: Icons.arrow_back),
                                  // ),
                                  // Positioned(
                                  //   top: 35,
                                  //   left: 100,
                                  //   child: Text(
                                  //     successState.title.toString(),
                                  //     style: GoogleFonts.poppins(
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.bold,
                                  //         color: Colors.grey.shade500),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 0, right: 1,
                                child: muteButtonConfig()),
                          ],
                        ),
                      )),
                ));
          case FoodDaysInitialErrorState:
            final errorState = state as FoodDaysInitialErrorState;

            RxString? val = ''.obs;
            CheckInternetConnection.instance.checkInternet().then((value) {
              print('v--> ${value.toString()}');
              if (value.toString() == 'none') {
                val.value = 'No Internet Connection';
              }
              else {
                val.value = 'Error ${errorState.error}';
              }
            });

            return Obx(() {
              return WillPopScope(
                onWillPop: () async {
                  foodDaysBloc
                      .add(FoodDaysBackNavigateButtonEvent());
                  return await true;
                },
                child: Scaffold(
                    body: Center(
                        child: Text(val.value))),
              );
            });
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({Key? key, this.foodDaysList, this.foodDaysBloc,})
      : super(key: key);

  final List<FoodDaysList>? foodDaysList;

  final FoodDaysBloc? foodDaysBloc;


  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  var keyboardFocusNode = FocusNode();
  AutoScrollController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    keyboardFocusNode.dispose();
    super.dispose();
  }


  final double _height = 100.0;

  int listViewValue = 0;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    print('checking the context.widthSize ${context.widthSize}');
    super.didChangeDependencies();
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

    double baseWidth = 800.0000610352;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      children: [
        widget.foodDaysList!.isEmpty ?
        Text(
          'No Data Available',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: GoogleFonts.abel(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black, wordSpacing: 5),
        )
            : SizedBox(
          height: 220 * fem,
          child: ListView.separated(
            separatorBuilder:
                (BuildContext context, int index) =>
            const SizedBox(
              width: 20,
            ),
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: widget.foodDaysList!.length,
            itemBuilder: (_, i) {
              return
                Container(
                  // group427319493MGV (39:1082)
                  // margin: EdgeInsets.fromLTRB(
                  //     0 * fem, 0 * fem, 0 * fem, 33 * fem),
                  width: 150 * fem,
                  height: 250 * fem,
                  // color: Colors.red,
                  child: Stack(
                    children: [
                      Positioned(
                        // card6Sz5 (39:1058)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: TextButton(
                          onPressed: () {
                            if (PlatformType.isTv != true) {
                              foodDaysModelIndex = i;
                              widget.foodDaysBloc!.add(
                                  FoodDaysNavigateButtonEvent(
                                    foodTypeID: widget.foodDaysList![i].id,
                                    title: widget.foodDaysList![i].name,
                                  ));
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: 150 * fem,
                            height: 200 * fem,
                            // color: Colors.red,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10 * fem, top: 40 * fem),
                                  child: CachedNetworkImage(
                                    // imageUrl: 'https://img.freepik.com/free-photo/shot-cute-baby-girl-looking-camera_329181-19580.jpg?size=626&ext=jpg&ga=GA1.1.819226140.1685039441&semt=ais',
                                    imageUrl: widget.foodDaysList![i].image,
                                    // fit: BoxFit.contain,
                                    imageBuilder: (context,
                                        imageProvider) =>
                                        Container(
                                          width: 100 * fem,
                                          height: 100 * fem,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            // border: Border.all(
                                            //     color:
                                            //     PlatformType.isTv == false ?
                                            //     Colors.transparent :
                                            //     widget.lkgProducts![i]
                                            //         .isSelected == true
                                            //         ? widget.lkgProducts![i]
                                            //         .borderColor : Colors
                                            //         .transparent, width: 3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            // .circular(12),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    // progressIndicatorBuilder: (context, url,
                                    //     downloadProgress) =>
                                    //     Center(
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.only(top: 50),
                                    //           child: CircularProgressIndicator(
                                    //               value:
                                    //               downloadProgress.progress),
                                    //         )),
                                    errorWidget: (context, url, error) =>
                                     FittedBox(
                                      fit: BoxFit.cover,
                                      child:
                                      Image.asset('assets/logo1.png',
                                        height: 80,width: 80,fit: BoxFit.contain,cacheWidth: 280,),
                                      // Icon(Icons.error, color: Colors.red,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                SizedBox(
                                  width: 114 * fem,
                                  // height: 43 * fem,
                                  child: Text(
                                    widget.foodDaysList![i].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12 * ffem,
                                      wordSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5 * ffem / fem,

                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );


              // return SizedBox(
              //   // height: 250,
              //   width: 180,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.transparent,
              //       shadowColor: Colors.transparent,
              //       shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
              //     ),
              //     onPressed: () {
              //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       //   content: Text('${widget.lkgProducts![i].title}'),
              //       // ));
              //
              //
              //       // debugPrint('button pressed');
              //
              //    if(width < 900){
              //      widget.lkgBloc!.add(LkgNavigateButtonEvent(sectionID: widget.lkgProducts![i].sectionId,
              //        videoCatID: widget.lkgProducts![i].id,
              //        title: widget.lkgProducts![i].name,
              //      ));
              //    }
              //     },
              //     child: SizedBox(
              //       height:  185,
              //       width: 140,
              //       child: Stack(
              //         children: [
              //           Column(
              //             children: [
              //               CachedNetworkImage(
              //                 // imageUrl: 'https://img.freepik.com/free-photo/shot-cute-baby-girl-looking-camera_329181-19580.jpg?size=626&ext=jpg&ga=GA1.1.819226140.1685039441&semt=ais',
              //                 imageUrl: widget.lkgProducts![i].image!,
              //                 fit: BoxFit.fill,
              //                 imageBuilder:  (context, imageProvider) => Container(
              //                   height:  185,
              //                   width: 140,
              //                   decoration: BoxDecoration(
              //                     shape: BoxShape.rectangle,
              //                       border: Border.all(
              //                           color:
              //                               PlatformType.isTv == false ?
              //                                   Colors.transparent :
              //                           widget.lkgProducts![i].isSelected == true
              //                           ?  widget.lkgProducts![i].borderColor : Colors.transparent,width: 3),
              //                       borderRadius: BorderRadius.circular(12),
              //                     image: DecorationImage(
              //                         image: imageProvider, fit: BoxFit.cover),
              //                   ),
              //                 ),
              //                 progressIndicatorBuilder: (context, url,
              //                     downloadProgress) =>
              //                     Center(
              //                         child: CircularProgressIndicator(
              //                             value:
              //                             downloadProgress.progress)),
              //                 errorWidget: (context, url, error) =>
              //                 const FittedBox(
              //                   fit: BoxFit.contain,
              //                   child:
              //                   Icon(Icons.error,color: Colors.red,),
              //                 ),
              //               ),
              //               // Container(
              //               //   height:  height * 0.12,
              //               //   width: double.infinity ,
              //               //   child: Align(
              //               //     alignment: Alignment.topCenter,
              //               //     child: Padding(
              //               //       padding: const EdgeInsets.only(left: 10,right: 3),
              //               //       child: Text(
              //               //         widget.lkgProducts![i].name!,
              //               //         textAlign: TextAlign.center,
              //               //         overflow: TextOverflow.ellipsis,
              //               //         maxLines: 2,
              //               //         style: GoogleFonts.poppins(
              //               //             fontSize: 14,
              //               //             fontWeight: FontWeight.bold,
              //               //             color: Colors.black,),
              //               //       ),
              //               //     ),
              //               //   ),
              //               // ),
              //               // Container(
              //               //   color: Colors.white,
              //               //   height:  height * 0.12,
              //               //   width: double.infinity ,
              //               //   child: Align(
              //               //     alignment: Alignment.topCenter,
              //               //     child: Padding(
              //               //       padding: const EdgeInsets.only(left: 10,right: 3),
              //               //       child: Text(
              //               //         widget.lkgProducts![i].name!,
              //               //         textAlign: TextAlign.center,
              //               //         overflow: TextOverflow.ellipsis,
              //               //         maxLines: 2,
              //               //         style: GoogleFonts.poppins(
              //               //             fontSize: 14,
              //               //             fontWeight: FontWeight.bold,
              //               //             color: Colors.black,wordSpacing: 5),
              //               //       ),
              //               //     ),
              //               //   ),
              //               // ),
              //             ],
              //           ),
              //           Container(
              //             // color: Colors.white,
              //             decoration: BoxDecoration(
              //                 shape: BoxShape.rectangle,
              //                 border: Border.all(color:
              //                 PlatformType.isTv == false  ?
              //                 Colors.transparent :
              //                 widget.lkgProducts![i].isSelected == true
              //                     ?  widget.lkgProducts![i].borderColor : Colors.transparent,width: 3),
              //                 borderRadius: BorderRadius.circular(12),
              //                 // image: DecorationImage(
              //                 //     image: imageProvider, fit: BoxFit.cover),
              //                 gradient: LinearGradient(
              //                   begin: Alignment.topRight,
              //                   end: Alignment.bottomLeft,
              //                   colors: [
              //                     Colors.transparent,
              //                     Colors.black54,
              //                   ],
              //                 )
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Align(
              //               alignment: Alignment.bottomCenter,
              //               child:Text(
              //                 widget.lkgProducts![i].name!,
              //                 textAlign: TextAlign.center,
              //                 overflow: TextOverflow.ellipsis,
              //                 maxLines: 5,
              //                 style: GoogleFonts.poppins(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,),
              //               ),
              //             ),
              //           ),
              //
              //           // Padding(
              //           //   padding: const EdgeInsets.all(16.0),
              //           //   child: CachedNetworkImage(
              //           //     height:  height * 0.5,
              //           //     width: width * 0.2,
              //           //     imageUrl:
              //           //     "${widget.lkgProducts![i].thumbNail}",
              //           //     fit: BoxFit.fill,
              //           //     progressIndicatorBuilder: (context, url,
              //           //         downloadProgress) =>
              //           //         Center(
              //           //             child: SizedBox(
              //           //               height:20,width:20,
              //           //               child: CircularProgressIndicator(
              //           //                   value:
              //           //                   downloadProgress.progress),
              //           //             )),
              //           //     errorWidget: (context, url, error) =>
              //           //         FittedBox(
              //           //           fit: BoxFit.contain,
              //           //           child:
              //           //           Image.asset('assets/logo.png'),
              //           //         ),
              //           //   ),
              //           // ),
              //           // Padding(
              //           //   padding: const EdgeInsets.all(16.0),
              //           //   child: SvgPicture.asset(
              //           //     'assets/mushroom.svg',
              //           //     semanticsLabel: 'Acme Logo',
              //           //     fit: BoxFit.fill,
              //           //   ),
              //           // ),
              //         ],
              //       ),
              //     ),
              //   ),
              // );
            },
          ),
        ),
        // Center(
        //   child: SizedBox(
        //     width: width * 0.6,
        //     child: SliderTheme(
        //       child: Slider(
        //         value: listViewValue.toDouble(),
        //         max: double.parse( (widget.lkgProducts!.length -1).toString()),
        //         min: 0,
        //         activeColor: Colors.white,
        //         inactiveColor: Colors.blue,
        //         onChanged: (double value) {},
        //       ),
        //       data: SliderTheme.of(context).copyWith(
        //         trackHeight: 5,
        //         thumbShape: SliderComponentShape.noThumb,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
