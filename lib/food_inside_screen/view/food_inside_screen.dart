import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' ;
import 'package:nimu_tv/features/food_days_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/food_days_screen/view/food_days_screen.dart';
import 'package:nimu_tv/food_video/features/database/item_data.dart';
import 'package:nimu_tv/food_video/models/storingVideoCloseFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../config/circle_back_button.dart';
import '../../../config/circular_progressindicator.dart';
import '../../../config/download_prompt.dart';
import '../../../config/mute_button_config.dart';
import '../../../config/utils.dart';
import '../../../main.dart';
import '../../config/check_internet_connection.dart';
import '../../food_video/features/view/food_video.dart';
import '../../food_video/features/view/food_video_player.dart';
import '../bloc/food_inside_bloc.dart';
import '../database_items/items_data.dart';
import '../models/food_inside_models.dart';


final foodInsideBucket = PageStorageBucket();
class FoodInsideScreenView extends StatefulWidget {
  final int? sectionID;
  final String? title;
  final int? foodCatID ;
  final int? foodTypeID ;
  final int? foodDayID ;

  const FoodInsideScreenView(
      {Key? key, this.title, this.foodCatID, this.foodTypeID,this.foodDayID,this.sectionID})
      : super(key: key);

  @override
  State<FoodInsideScreenView> createState() => _FoodInsideScreenViewState();
}

class _FoodInsideScreenViewState extends State<FoodInsideScreenView> {
  final FoodInsideBloc foodInsideBloc = FoodInsideBloc();

  @override
  void initState() {
    // TODO: implement initState



    foodInsideBloc.add(FoodInsideInitialEvent(
      sectionID: widget.sectionID,
      foodDayID: widget.foodDayID,
      foodTypeID: widget.foodTypeID,
      foodCatID: widget.foodCatID,
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
    return BlocConsumer<FoodInsideBloc, FoodInsideState>(
      bloc: foodInsideBloc,
      listenWhen: (previous, current) => current is FoodInsideActionState,
      buildWhen: (previous, current) => current is! FoodInsideActionState,
      listener: (context, state) {
        if (state is FoodInsideActionButtonState) {

          storingFoodInsideScreenNo = 1;

          storingFoodVideoCloseModel = StoringFoodVideoCloseModel(
            sectionID: widget.sectionID,
            foodCatID: widget.foodCatID,
            foodDayID: widget.foodDayID,
            foodTypeID: widget.foodTypeID,
            title: widget.title,
          );

          if (PlatformType.isTv) {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: FoodVideoScreenView(
                    videoNumber: state.videoID,
                    videosList: foodInsideModel!.data,
                    isDownload: false,
                  )),
            );
          } else {
            isOnTap = false;
            print('checking the isdownload ${state.isDownload} video URL ${state.videoUrl}');

            if (state.isDownload == true) {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: FoodVideoScreenView(
                      videoNumber: state.videoID,
                      videosList: foodInsideModel!.data,
                      isDownload: true,
                      videoUrl: state.videoUrl,
                    )),
              );
            }
            else {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: FoodVideoScreenView(
                      videoNumber: state.videoID,
                      videosList: foodInsideModel!.data,
                      isDownload: false,
                      videoUrl: state.videoUrl,
                    )),
              );
            }
          }

        }
        else if (state is FoodInsideWatchOnlineActionButtonState) {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 100),
                child: FoodVideoScreenView(
                  videoNumber: state.videoID,
                  videosList: foodInsideModel!.data,
                  isDownload: false,
                )),
          );


          // ScaffoldMessenger.of(context)
          //     .showSnackBar( SnackBar(content: Text('${state.videoID}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }

        else if (state is FoodInsideUpdatingRatingStarButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Star rating updating...'),
            duration: Duration(milliseconds: 1000),
          ));
        } else if (state
        is FoodInsideUpdatingRatingStarButtonLoadedSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Star rating updated successfully'),
            duration: Duration(milliseconds: 1000),
          ));
        } else if (state is FoodInsideUpdatingRatingStarButtonErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is FoodInsideBackActionButtonState) {
          print('checking the food type back button ${foodDaysModel!.title}');
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: FoodDaysScreenView(
                    title: foodDaysString.value,
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
          case FoodInsideInitialLoadingState:
            return circularProg!;

          case FoodInsideInitialLoadedSuccessState:
            final successState = state as FoodInsideInitialLoadedSuccessState;
            double baseWidth = 800;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;

            return WillPopScope(
              onWillPop: () async {

                foodInsideBloc
                    .add(FoodInsideBackNavigateButtonEvent());
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
                            1 * fem, 10 * fem, 0 * fem, 0 ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/thumbnail.jpg',
                              // 'assets/BG.jpg',
                            ),
                          ),
                        ),
                    child: SingleChildScrollView(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // menusyb (41:749)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 60 * fem,
                                      5 * fem),
                                  child:  CircleButton(
                                    // splashColor: Colors.red,
                                    isBackButton: true,
                                    onTap: () {
                                      foodInsideBloc
                                          .add(FoodInsideBackNavigateButtonEvent());
                                    },
                                  ),
                                ),
                                Container(
                                  // group5AC1 (18:139)
                                  width: 197 * fem,
                                  height: 32 * fem,
                                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/4),
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
                                      successState.title.toString(),
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
                            foodInsideBloc: foodInsideBloc,
                            foodInsideProducts: successState.foodProducts,
                          ),
                          muteButtonConfig(),
                        ],
                      ),
                    ),
                  )),
            ));
          case FoodInsideInitialErrorState:
            final errorState = state as FoodInsideInitialErrorState;

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
              return WillPopScope(
                onWillPop: () async {
                  foodInsideBloc
                      .add(FoodInsideBackNavigateButtonEvent());
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
  const HomePage({Key? key, this.foodInsideProducts, this.foodInsideBloc})
      : super(key: key);

  final List<FoodInsideModelList>? foodInsideProducts;
  final FoodInsideBloc? foodInsideBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  static int maxCount = 0;
  final scrollDirection = Axis.horizontal;
  late AutoScrollController controller;
  var keyboardFocusNode = FocusNode();
  RxDouble storingOffset = 10.0.obs;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.foodInsideProducts!.isNotEmpty) {
      // widget.foodInsideProducts![0].isSelected = true;
    }
    maxCount = widget.foodInsideProducts!.length;
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery
                .of(context)
                .padding
                .bottom),
        axis: scrollDirection);

    controller.addListener(() {
      setState(() {
        var e = Scrollable.ensureVisible(context);
print('checking the scrollable ensure ${e}');
        if(controller.offset > 0){
          storingOffset.value = controller.offset ;
        }
      });
      print('_controller.offset ${storingOffset.value} '
          'controller.position.maxScrollExtent ${controller.position.maxScrollExtent}'
          '_controller.position.pixels ${controller.position.pixels}'
          ''); // <-- This is it.
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    keyboardFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  Future _nextCounter() {
    setState(() => counter = (counter + 1) % maxCount);
    return _scrollToCounter();
  }

  Future _lessCounter() {
    setState(() => counter = (counter - 1) % maxCount);
    return _scrollToCounter();
  }

  Future _scrollToCounter() async {
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );

  Widget _getRow(int i, List<FoodInsideModelList>? foodInsideProducts,
      double height, double width) {
    print(
        'checking the bool value in inside screen ${widget.foodInsideProducts![i]
            .isDownloaded.value}');


    var futStatus = checkingTheFoodDownloadFile(
        widget.foodInsideProducts![i].videoUrl);

    futStatus.then((value) {
      debugPrint(' checking file exists ${value} is file exists ');
      widget.foodInsideProducts![i].isDownloaded.value = value;
    });
    double baseWidth = 800.0000610352;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    return _wrapScrollTag(
      index: i,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // height: 160,
            // width: 400,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                print('checking the on pressed func for download ${widget
                    .foodInsideProducts![i].isDownloaded.value }');
                if (PlatformType.isTv == false) {




                  widget.foodInsideBloc!.add(FoodInsideNavigateButtonEvent(
                      videoID: widget.foodInsideProducts![i].id,
                      videoUrl: widget.foodInsideProducts![i].videoUrl,
                      isDownload:true),);
                }

              },
              child: SizedBox(
                height: 230,
                width: 118,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      // imageUrl: 'https://img.freepik.com/free-photo/shot-cute-baby-girl-looking-camera_329181-19580.jpg?size=626&ext=jpg&ga=GA1.1.819226140.1685039441&semt=ais',
                      imageUrl: foodInsideProducts![i].imageUrl,
                      fit: BoxFit.fill,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            height: 220,
                            width: 134,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color:
                                  Colors.transparent,
                                  width: 3),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                          ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                  value: downloadProgress.progress)),
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
                                foodInsideProducts[i].title,
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

                         Obx(() {
                      return
                      widget.foodInsideProducts![i].isDownloaded.value == false ? Container(
                        height: 220,
                        width: 134,
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
                      )
                          : SizedBox.shrink();
                    }),


                    Center(
                      child:

                      Obx(() {
                        return

                          widget.foodInsideProducts![i].isDownloaded.value ==
                              false ?
                          Icon(Icons.download_rounded,
                            color: Colors.white,) : SizedBox.shrink();
                      }),
                    ),

                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {

                widget.foodInsideBloc!.add(FoodInsideNavigateButtonEvent(
                    videoID: widget.foodInsideProducts![i].id,
                    isDownload: false,
                ));


                print('checking the downloaded file is available  ${widget.foodInsideProducts![i].isDownloaded.value}');



              },
              child:  Row(
                children: [
                  Icon(Icons.play_circle_fill,color: Colors.red,),
                  SizedBox(width: 5,),
                  Text(
                    'Watch Online',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              )
            ),
          ),

        ],
      ),
    );
  }

  int listViewValue = 0;

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
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.foodInsideProducts!.isEmpty
            ? Center(
          child: Text(
            'No Data Available',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.abel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                wordSpacing: 5),
          ),
        )
            : PageStorage(
          bucket: foodInsideBucket,
              child: AnimationLimiter(
          child: Container(
              // color: Colors.red,
              // padding: EdgeInsets.only(top: 60),
              // height: Get.height/1.47,
              height: Get.height/1.3,
              child: ListView.separated(
                key: const PageStorageKey<String>('Page5') ,
                physics: BouncingScrollPhysics(),
                // padding: EdgeInsets.only(top: Get.height * 0.1),
                separatorBuilder: (_,i)=> SizedBox(width: 1,),
                shrinkWrap: true,
                // gridDelegate:
                // const SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 4,
                //   // maxCrossAxisExtent: 200,
                //   // crossAxisSpacing: 10,
                //   mainAxisSpacing: 10,
                //   mainAxisExtent: 180,
                // ),
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: maxCount,
                itemBuilder: (_, i) {
                  return AnimationConfiguration.staggeredGrid(
                    position: i,
                    columnCount: 4,
                    child: ScaleAnimation(
                      duration: const Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        child: _getRow(
                            i, widget.foodInsideProducts, height, width),
                      ),
                    ),
                  );
                },
              ),
          ),
        ),
            ),

        // Container(
        //   // group11C5P (18:137)
        //   margin: EdgeInsets.fromLTRB(
        //       212 * fem, 20 * fem, 212 * fem, 0 * fem),
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
        //         width: storingOffset.value  *  0.7 ,
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
    );
  }
}
