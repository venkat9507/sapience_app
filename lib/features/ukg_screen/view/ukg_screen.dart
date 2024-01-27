import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/features/video_categories/model/video_category_model.dart';
import 'package:page_transition/page_transition.dart';

import '../../../config/check_internet_connection.dart';
import '../../../config/circle_back_button.dart';
import '../../../config/circular_progressindicator.dart';
import '../../../config/color_const.dart';
import '../../../config/custom_drawer.dart';
import '../../../config/mute_button_config.dart';
import '../../../config/utils.dart';
import '../../../main.dart';
import '../../dashboard_screen/view/dashboard_screen.dart';
import '../../food_categories/database/item_data.dart';
import '../../food_categories/models/storing_food_category_models.dart';
import '../../food_types_screen/view/food_types_screen.dart';
import '../../splash_screen/view/splash_screen_view.dart';
import '../../ukg_inside_screen/view/ukg_inside_screen.dart';
import '../../video/features/database/item_data.dart';
import '../../video/models/storingVideoCloseFunction.dart';
import '../../video_categories/data/items_data.dart';
import '../bloc/ukg_bloc.dart';

final ukgBucket = PageStorageBucket();
class UkgScreenView extends StatefulWidget {
  final int? sectionID;
  const UkgScreenView({Key? key,this.sectionID}) : super(key: key);

  @override
  State<UkgScreenView> createState() => _UkgScreenViewState();
}

class _UkgScreenViewState extends State<UkgScreenView> {
  final UkgBloc ukgBloc = UkgBloc();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey =  GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    // for(var item in GroceryData.lkgProducts){
    //   lkgDataItems!.add(LkgModel(
    //     id: item['id'],
    //     title: item['title'],
    //     borderColor: item['borderColor'],
    //     thumbNail: item['thumbNail'],
    //     isSelected: false,
    //   ));
    // }

    ukgBloc.add(UkgInitialEvent(
        sectionID: widget.sectionID
      // lkgProducts: lkgDataItems,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return BlocConsumer<UkgBloc, UkgState>(
      bloc: ukgBloc,
      listenWhen: (previous, current) => current is UkgActionState,
      buildWhen: (previous, current) => current is! UkgActionState,
      listener: (context, state) {
        if (state is UkgActionButtonState) {

          if(state.isLkgFoodCategory == false){
            storingInsideScreenNo = 1;

            storingVideoCloseModel = StoringVideoCloseModel(
                videoCat:state.videoCatID,
                sectionID: state.sectionID,
                title: state.title
            );

            Navigator.pushAndRemoveUntil(context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: UkgInsideScreenView(videoCatID: state.videoCatID,
                      sectionID: state.sectionID, title: state.title,)), (
                    Route<dynamic> route) => true);
          }
          else
          {
            storingFoodCategoryInsideScreenNo =1;
            storingFoodCategoryCloseModel = StoringFoodCategoryCloseModel(
                foodCat:state.videoCatID,
                sectionID: state.sectionID,
                title: state.title
            );

            Navigator.pushAndRemoveUntil(context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: FoodTypesScreenView( title: state.title,)), (
                    Route<dynamic> route) => true);
          }
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        } else if (state is UkgBackActionButtonState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const DashboardScreenView()),(Route<dynamic> route) => false);
        }
        else if (state is UkgDrawerActionButtonState) {

          switchingBetweenDifferentWidget(index: state.index,context: context,sectionID: state.sectionID,subscriptionReturnBackID: widget.sectionID);

        }
        else if (state is UkgLogoutButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging out please wait ....')));

        }
        else if (state is UkgLogoutButtonLoadedSuccessState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const SplashScreenView()),(Route<dynamic> route) => false);

        }
        else if (state is UkgLogoutButtonErrorState) {
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
          case UkgInitialLoadingState:
            return  circularProg!;

          case UkgInitialLoadedSuccessState:
            final successState = state as UkgInitialLoadedSuccessState;

            double baseWidth = 800.0000610352;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;
            print('checking the fem $fem basewidth $baseWidth ffem $ffem'
                '');

            // return Scaffold(
            //   body: Center(
            //     child: Text(
            //               'No Data Available!!',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               // maxLines: 1,
            //               style: GoogleFonts.poppins(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,),
            //             ),
            //   ),
            // );

            return Scaffold(
                key: _drawerScaffoldKey,
                drawer: CustomDrawer(width: width,
                  height: height,
                  logOut: (){
                    ukgBloc.add(LogoutUkgEvent());
                  },
                  backButton: (){
                    ukgBloc.add(UkgBackNavigateButtonEvent());
                  },
                  dashboardList:  successState.dashboardList!.map((e) =>
                      ListTile(
                        minVerticalPadding: 1,
                        selectedTileColor: Colors.orange.shade50,
                        selectedColor: primaryOrange,
                        selected: e.isSelected!,
                        title:  Text(e.name),
                        textColor: primaryBlue,
                        onTap: () {
                          // Navigator.pop(context);
                          ukgBloc.add(UkgChangingTheDrawerColorEvent(
                              index: e.index,
                              sectionID: e.index,
                              ukgProducts: videoCategoryModel!.data,
                              dashboardList: successState.dashboardList));
                        },
                      ),).toList(),
                ),
                body:
                WillPopScope(
                  onWillPop: () async {

                    ukgBloc
                        .add(UkgBackNavigateButtonEvent());
                    return await true;
                  },
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      // height: 200,
                      // color: Colors.redAccent,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            1 * fem, 15 * fem, 0 * fem, 0 * fem),
                        width: double.infinity,
                        height: double.infinity,
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // SizedBox(
                              //     height: double.maxFinite,
                              //     width: double.maxFinite,
                              //     child: Image.asset(
                              //       'assets/lkg_bc.png',
                              //       fit: BoxFit.fill,
                              //     )
                              //         // .animate().effect(duration: 3000.ms) // this "pads out" the total duration
                              //         // .effect( duration: 500.ms).scaleX()
                              //         // .animate(onPlay: (controller) => controller.repeat())
                              //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                              //         // .effect(delay: 750.ms, duration: 1500.ms).shimmer()
                              // ),
                              // SizedBox(
                              //   height: double.maxFinite,
                              //   width: double.maxFinite,
                              //   child:SvgPicture.asset(
                              //       'assets/mushroom.svg',
                              //       semanticsLabel: 'Acme Logo',
                              //     fit: BoxFit.fill,
                              //   )
                              //       .animate(onPlay: (controller) => controller.repeat())
                              //       .effect(
                              //           duration:
                              //               3000.ms) // this "pads out" the total duration
                              //       .effect(delay: 750.ms, duration: 1500.ms)
                              //       .shimmer(),
                              // ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // autogroup9famZT7 (LLGDGH21KgmkDcDSTH9faM)
                                    margin: EdgeInsets.fromLTRB(
                                        15 * fem, 0 * fem, 281 * fem, 35 * fem),
                                    width: double.infinity,
                                    // color: Colors.redAccent,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          // menusyb (41:749)
                                          margin: EdgeInsets.fromLTRB(
                                              0 * fem, 0 * fem, 246.98 * fem,
                                              16 * fem),
                                          child: CircleButton(
                                            // splashColor: Colors.red,
                                            isBackButton: true,
                                            onTap: () {
                                              ukgBloc
                                                  .add(UkgBackNavigateButtonEvent());
                                            },
                                          ),
                                        ),
                                        Container(
                                          // group5AC1 (18:139)
                                          width: 197 * fem,
                                          height: 32 * fem,
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
                                                    0 * fem, 11.6827545166 * fem),
                                                blurRadius: 16 * fem,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child:  Text(
                                              // storingOffset.value.toString(),
                                              'UKG SYLLABUS',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 16 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1 * ffem / fem,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  HomePage(
                                    ukgBloc: ukgBloc,
                                    ukgProducts: successState.ukgProducts,
                                    controller: _controller,
                                  ),
                                  // Container(
                                  //   // group11C5P (18:137)
                                  //   margin: EdgeInsets.fromLTRB(
                                  //       212 * fem, 0 * fem, 212 * fem, 0 * fem),
                                  //   // padding: EdgeInsets.fromLTRB(2*fem, 2*fem, 2*fem, 2*fem),
                                  //   width: double.infinity,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(color: Color(0xff5b84c2)),
                                  //     borderRadius: BorderRadius.circular(10 * fem),
                                  //     gradient: RadialGradient(
                                  //       center: Alignment(-1.781, -5.444),
                                  //       radius: 4.31,
                                  //       colors: <Color>[
                                  //         Color(0xff1c699c),
                                  //         Color(0xff6695be)
                                  //       ],
                                  //       stops: <double>[0, 1],
                                  //     ),
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //         color: Color(0x33000000),
                                  //         offset: Offset(
                                  //             0 * fem, 11.6827545166 * fem),
                                  //         blurRadius: 16 * fem,
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   child: Align(
                                  //     // rectangle1123zmw (18:136)
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Obx(() {
                                  //       return SizedBox(
                                  //         width: storingOffset.value  *  2 ,
                                  //         height: 5 * fem,
                                  //         child: Container(
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(
                                  //                 10 * fem),
                                  //             color: Color(0xffffffff),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),
                                  //   ),
                                  // ),
                                ],
                              ),
                              muteButtonConfig(),
                              // Positioned(
                              //   top: 1,
                              //   left: 30,
                              //   child: CircleButton(
                              //       onTap: () {
                              //         if(_drawerScaffoldKey.currentState!.isDrawerOpen){
                              //           //if drawer is open, then close the drawer
                              //           Navigator.pop(context);
                              //         }else{
                              //           _drawerScaffoldKey.currentState!.openDrawer();
                              //           //if drawer is closed then open the drawer.
                              //         }
                              //
                              //       }, ),
                              // ),
                              // Positioned(
                              //   top: 150,
                              //   right: 350,
                              //   child: SizedBox(
                              //     height: height * 0.2,
                              //     width: width * 0.2,
                              //     child: Image.asset(
                              //       'assets/cloud_1.png',
                              //       fit: BoxFit.fill,
                              //     ).animate(onPlay: (controller) => controller.repeat())
                              //         .effect(duration: 3000.ms) // this "pads out" the total duration
                              //         .effect(delay: 750.ms, duration: 1500.ms).slideY().shake().shimmer(),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            );
          case UkgInitialErrorState:
            final errorState = state as UkgInitialErrorState;

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
              return  WillPopScope(
                onWillPop: () async {

                  ukgBloc
                      .add(UkgBackNavigateButtonEvent());
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

  const HomePage({Key? key,this.ukgProducts,this.ukgBloc,this.controller}) : super(key: key);

  final List<VideoCategoriesList>? ukgProducts ;
  final UkgBloc? ukgBloc ;

  final ScrollController? controller;


  @override
  State<HomePage> createState() => _HomePageState();


}
class _HomePageState extends State<HomePage> {
  var keyboardFocusNode = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    widget.ukgProducts![0].isSelected = true;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    keyboardFocusNode.dispose();
    super.dispose();
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


    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;


    return RawKeyboardListener(
      focusNode: keyboardFocusNode,
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
          content: Text(widget.ukgProducts![listViewValue].name!),
        );


        // ScaffoldMessenger.of(context).showSnackBar(snackBar);


        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                widget.ukgBloc!.add(UkgNavigateButtonEvent(sectionID: widget.ukgProducts![listViewValue].sectionId,
                  videoCatID: widget.ukgProducts![listViewValue].id,
                  title: widget.ukgProducts![listViewValue].name,
                ));

              });
              break;
            case 'Enter':
              setState(() {
                // widget.lkgBloc!.add(LkgNavigateButtonEvent(sectionID: widget.lkgProducts![listViewValue].sectionId,
                //     videoCatID: widget.lkgProducts![listViewValue].id,
                //   title: widget.lkgProducts![listViewValue].name,
                // ));
              });
              break;
          }
        }



        else  if (LogicalKeyboardKey.arrowRight == event.logicalKey) {

          debugPrint('arrowRight listViewValue $listViewValue widget.ukgProducts!.length ${widget.ukgProducts!.length}');

          if(listViewValue < widget.ukgProducts!.length-1){
            widget.ukgBloc!.add(UkgChangingTheColorEvent(index: listViewValue,isRightButton: true));

            _animateToIndex(listViewValue=listViewValue+1, width);
          }

        }
        else  if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {

          debugPrint('arrowLeft listViewValue $listViewValue widget.ukgProducts!.length ${widget.ukgProducts!.length}');
          if(listViewValue>0){
            widget.ukgBloc!.add(UkgChangingTheColorEvent(index: listViewValue,isRightButton: false));
            _animateToIndex(listViewValue=listViewValue-1, width);
          }

        }

        if (event is RawKeyDownEvent) {

          print('--> ${event.data.keyLabel}');
          // handle key down
        } else if (event is RawKeyUpEvent) {
          // handle key up
        }
      },
      child:Column(
        children: [
          widget.ukgProducts!.isEmpty ?
          Text(
            'No Data Available',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.abel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,wordSpacing: 5),
          )
              :    PageStorage(
            bucket: ukgBucket,
                child: SizedBox(
            height: 220 * fem,
            child: ListView.separated(
                key: const PageStorageKey<String>('Page3') ,
                separatorBuilder:
                    (BuildContext context, int index) =>
                const SizedBox(
                  width: 20,
                ),
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.ukgProducts!.length,
                itemBuilder: (_, i) {
                  print( 'checking the image url ${widget.ukgProducts![i].image}');
                  return SizedBox(
                    width: 150 * fem,
                    height: 250 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // card6Sz5 (39:1058)
                          left: 0 * fem,
                          top: 0 * fem,
                          child: TextButton(
                            onPressed: () {
                              if (PlatformType.isTv != true) {
                                widget.ukgBloc!.add(
                                    UkgNavigateButtonEvent(
                                  sectionID: widget.ukgProducts![i].sectionId,
                                  videoCatID: widget.ukgProducts![i].id,
                                  title: widget.ukgProducts![i].name,
                                      isLkgFoodCategory: widget.ukgProducts![i].isLkgFoodCategory,
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
                              child: Stack(
                                children: [
                                  // Positioned(
                                  //   // containerMLM (39:1059)
                                  //   left: 15 * fem,
                                  //   top: 0 * fem,
                                  //   child: Align(
                                  //     child: SizedBox(
                                  //       width: 140.03 * fem,
                                  //       height: 200 * fem,
                                  //       child: Container(
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(
                                  //               8 * fem),
                                  //           color: Color(0xffe5e5ea),
                                  //           boxShadow: [
                                  //             BoxShadow(
                                  //               color: Color(0x3f000000),
                                  //               offset: Offset(
                                  //                   0 * fem, -1 * fem),
                                  //               blurRadius: 10.5 * fem,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Positioned(
                                    // image2dof (494:1140)
                                    left: 0 * fem,
                                    top: 0 * fem,
                                    child: Align(
                                      child:
                                      widget.ukgProducts![i].image!.isEmpty ?
                                          Image.asset('assets/BG.jpg') :
                                      CachedNetworkImage(
                                        // imageUrl: 'https://img.freepik.com/free-photo/shot-cute-baby-girl-looking-camera_329181-19580.jpg?size=626&ext=jpg&ga=GA1.1.819226140.1685039441&semt=ais',
                                        imageUrl: widget.ukgProducts![i].image! ??'' ,

                                        // fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                        Center(child: const CircularProgressIndicator()),
                                        imageBuilder: (context,
                                            imageProvider) =>
                                            Container(
                                              width: 150 * fem,
                                              height: 200 * fem,
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
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                            Container(
                                              height: 220,
                                              width: 134,
                                              margin: EdgeInsets.only(left: 5),
                                              // padding: const EdgeInsets.only(left: 30),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 3),
                                                gradient: RadialGradient(
                                                  center: Alignment(-0, -0),
                                                  radius: 0.34,
                                                  colors: <Color>[
                                                    Color(0x99000000),
                                                    Color(0x99000000)
                                                  ],
                                                  stops: <double>[0, 1],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              // decoration: BoxDecoration(
                                              //   color: Color(0xffffffff),
                                              //   image: DecorationImage(
                                              //     fit: BoxFit.cover,
                                              //     image: AssetImage(
                                              //       'assets/thumbnail.jpg',
                                              //       // 'assets/BG.jpg',
                                              //       // 'assets/lkg_bc.png',
                                              //     ),
                                              //   ),
                                              // ),
                                              // transformAlignment: Alignment.center,
                                              child: Center(
                                                child: Text(
                                                  widget.ukgProducts![i].name!,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 5,
                                                  softWrap: true,
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12 * ffem,wordSpacing: 1,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.5 * ffem / fem,

                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   // shadowkdP (39:1060)
                                  //   left: 0 * fem,
                                  //   top: 0 * fem,
                                  //   child: Align(
                                  //     child: Container(
                                  //       width: 150 * fem,
                                  //       height: 200 * fem,
                                  //       decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.all(Radius.circular(12)),
                                  //         gradient: LinearGradient(
                                  //           begin: Alignment(0, -1),
                                  //           end: Alignment(0,1),
                                  //           colors: <Color>[
                                  //             Color(0x00ffffff),
                                  //             Color(0xff000000)
                                  //           ],
                                  //           stops: <double>[0,1],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Align(
                                  //   alignment: Alignment.bottomCenter,
                                  //   child: SizedBox(
                                  //     width: 114 * fem,
                                  //     // height: 43 * fem,
                                  //     child: Text(
                                  //       widget.lkgProducts![i].name!,
                                  //       textAlign: TextAlign.center,
                                  //       maxLines: 5,
                                  //       softWrap: true,
                                  //       style: SafeGoogleFont(
                                  //         'Poppins',
                                  //         fontSize: 12 * ffem,wordSpacing: 1,
                                  //         fontWeight: FontWeight.w600,
                                  //         height: 1.5 * ffem / fem,
                                  //
                                  //         color: Color(0xffffffff),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Container(
                        //   height: height * 0.5,
                        //   width: width * 0.5,
                        //   margin: const EdgeInsets.all(15.0),
                        //   padding: const EdgeInsets.all(3.0),
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color:  widget.ukgProducts![i].isSelected == true
                        //           ?  widget.ukgProducts![i].borderColor : Colors.red,width: 10)
                        //   ),
                        //   // child: Text('My Awesome Border'),
                        // ),




                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: CachedNetworkImage(
                        //     height:  height * 0.5,
                        //     width: width * 0.2,
                        //     imageUrl:
                        //     "${widget.lkgProducts![i].thumbNail}",
                        //     fit: BoxFit.fill,
                        //     progressIndicatorBuilder: (context, url,
                        //         downloadProgress) =>
                        //         Center(
                        //             child: SizedBox(
                        //               height:20,width:20,
                        //               child: CircularProgressIndicator(
                        //                   value:
                        //                   downloadProgress.progress),
                        //             )),
                        //     errorWidget: (context, url, error) =>
                        //         FittedBox(
                        //           fit: BoxFit.contain,
                        //           child:
                        //           Image.asset('assets/logo.png'),
                        //         ),
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 22,
                        //   // top: 20,
                        //   right: 20,left: 20,
                        //   child: Container(
                        //     color: Colors.white,
                        //     height:  height * 0.25,
                        //     width: width * 0.15,
                        //     child: Align(
                        //       alignment: Alignment.bottomCenter,
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 10,right: 3),
                        //         child: Text(
                        //           widget.ukgProducts![i].name!,
                        //           textAlign: TextAlign.center,
                        //           overflow: TextOverflow.ellipsis,
                        //           maxLines: 2,
                        //           style: GoogleFonts.abel(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.black,wordSpacing: 5),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   top: 20,
                        //   right: 20,left: 20,
                        //   child: SizedBox(
                        //     height:  height * 0.25,
                        //     width: width * 0.15,
                        //     child: CachedNetworkImage(
                        //       imageUrl:
                        //       widget.ukgProducts![i].image!,
                        //       fit: BoxFit.fill,
                        //       progressIndicatorBuilder: (context, url,
                        //           downloadProgress) =>
                        //           Center(
                        //               child: CircularProgressIndicator(
                        //                   value:
                        //                   downloadProgress.progress)),
                        //       errorWidget: (context, url, error) =>
                        //       const FittedBox(
                        //         fit: BoxFit.contain,
                        //         child:
                        //         Icon(Icons.error,color: Colors.red,),
                        //       ),
                        //     ),
                        //   ),
                        // ),


                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: SvgPicture.asset(
                        //     'assets/mushroom.svg',
                        //     semanticsLabel: 'Acme Logo',
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
            ),
          ),
              ),


          // Center(
          //   child: SizedBox(
          //     width: width * 0.6,
          //     child: SliderTheme(
          //       child: Slider(
          //         value: listViewValue.toDouble(),
          //         max: double.parse( (widget.ukgProducts!.length -1).toString()),
          //         min: 0,
          //         activeColor: Colors.white,
          //         inactiveColor: Colors.blue,
          //         onChanged: (double value) {},
          //       ),
          //       data: SliderTheme.of(context).copyWith(
          //         trackHeight: 28,
          //         thumbShape: SliderComponentShape.noThumb,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

