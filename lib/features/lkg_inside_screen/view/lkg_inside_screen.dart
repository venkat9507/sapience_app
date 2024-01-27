import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../../../main.dart';
import '../../video/features/database/item_data.dart';
import '../../video/features/view/video_player.dart';
import '../bloc/lkg_inside_bloc.dart';
import '../database_items/items_data.dart';
import '../models/lkg_inside_models.dart';

final lkgInsideBucket = PageStorageBucket();

class LkgInsideScreenView extends StatefulWidget {
  final int? sectionID;
  final int? videoCatID;
  final String? title;

  const LkgInsideScreenView(
      {Key? key, this.title, this.videoCatID, this.sectionID})
      : super(key: key);

  @override
  State<LkgInsideScreenView> createState() => _LkgInsideScreenViewState();
}

class _LkgInsideScreenViewState extends State<LkgInsideScreenView> {
  final LkgInsideBloc lkgInsideBloc = LkgInsideBloc();

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

    lkgInsideBloc.add(LkgInsideInitialEvent(
      // lkgInsideProducts: lkgInsideDataItems,
      sectionID: widget.sectionID, videoCatID: widget.videoCatID,
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
    return BlocConsumer<LkgInsideBloc, LkgInsideState>(
      bloc: lkgInsideBloc,
      listenWhen: (previous, current) => current is LkgInsideActionState,
      buildWhen: (previous, current) => current is! LkgInsideActionState,
      listener: (context, state) {
        if (state is LkgInsideActionButtonState) {
          // Navigator.pushAndRemoveUntil(context,
          //     PageTransition(
          //         type: PageTransitionType.bottomToTop,
          //         duration: const Duration(seconds: 1),
          //         child:  LkgInsideScreenView(videoCatID: state.videoCatID,
          //           sectionID: state.sectionID,title: state.title,)),(Route<dynamic> route) => false);


          if (PlatformType.isTv) {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: VideoScreenView(
                    videoNumber: state.videoID,
                    videosList: lkgInsideModel!.data,
                    isDownload: false,
                  )),
            );
          } else {
            isOnTap = false;
            print('checking the isdownload ${state.isDownload} video URL ${state
                .videoUrl}');

            if (state.isDownload == true) {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: VideoScreenView(
                      videoNumber: state.videoID,
                      videosList: lkgInsideModel!.data,
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
                    child: VideoScreenView(
                      videoNumber: state.videoID,
                      videosList: lkgInsideModel!.data,
                      isDownload: false,
                      videoUrl: state.videoUrl,
                    )),
              );
            }

            // downloadVideoOrPlay(
            //     context: context,
            //     width: width,
            //     noButton: () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //         context,
            //         PageTransition(
            //             type: PageTransitionType.scale,
            //             alignment: Alignment.center,
            //             duration: const Duration(milliseconds: 100),
            //             child: VideoScreenView(
            //               videoNumber: state.videoID,
            //               videosList: lkgInsideModel!.data,
            //               isDownload: false,
            //             )),
            //       );
            //     },
            //     yesButton: () {
            //       Navigator.pop(context);
            //       // lkgInsideBloc.add(LkgInsideDownloadNavigateButtonEvent());
            //       Navigator.push(
            //         context,
            //         PageTransition(
            //             type: PageTransitionType.scale,
            //             alignment: Alignment.center,
            //             duration: const Duration(milliseconds: 100),
            //             child: VideoScreenView(
            //               videoNumber: state.videoID,
            //               videosList: lkgInsideModel!.data,
            //               isDownload: true,
            //             )),
            //       );
            //
            //
            //     });
          }

          // ScaffoldMessenger.of(context)
          //     .showSnackBar( SnackBar(content: Text('${state.videoID}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }
        else if (state is LkgInsideWatchOnlineActionButtonState) {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 100),
                child: VideoScreenView(
                  videoNumber: state.videoID,
                  videosList: lkgInsideModel!.data,
                  isDownload: false,
                )),
          );


          // ScaffoldMessenger.of(context)
          //     .showSnackBar( SnackBar(content: Text('${state.videoID}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }

        else if (state is LkgInsideUpdatingRatingStarButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Star rating updating...'),
            duration: Duration(milliseconds: 1000),
          ));
        } else if (state
        is LkgInsideUpdatingRatingStarButtonLoadedSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Star rating updated successfully'),
            duration: Duration(milliseconds: 1000),
          ));
        } else if (state is LkgInsideUpdatingRatingStarButtonErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is LkgInsideBackActionButtonState) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: LkgScreenView(
                    sectionID: widget.sectionID,
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
          case LkgInsideInitialLoadingState:
            return circularProg!;

          case LkgInsideInitialLoadedSuccessState:
            final successState = state as LkgInsideInitialLoadedSuccessState;
            double baseWidth = 800;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;

            return WillPopScope(
                onWillPop: () async {
                  lkgInsideBloc
                      .add(LkgInsideBackNavigateButtonEvent());
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
                                      child: CircleButton(
                                        // splashColor: Colors.red,
                                        isBackButton: true,
                                        onTap: () {
                                          lkgInsideBloc
                                              .add(
                                              LkgInsideBackNavigateButtonEvent());
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        // storingOffset.value.toString(),
                                        successState.title.toString(),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1 * ffem / fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              HomePage(
                                lkgInsideBloc: lkgInsideBloc,
                                lkgInsideProducts: successState.lkgProducts,
                              ),
                              muteButtonConfig(),
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
                      )),
                ));
          case LkgInsideInitialErrorState:
            final errorState = state as LkgInsideInitialErrorState;
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
                  lkgInsideBloc
                      .add(LkgInsideBackNavigateButtonEvent());
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
  const HomePage({Key? key, this.lkgInsideProducts, this.lkgInsideBloc})
      : super(key: key);

  final List<LkgInsideModelList>? lkgInsideProducts;
  final LkgInsideBloc? lkgInsideBloc;

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
    if (widget.lkgInsideProducts!.isNotEmpty) {
      widget.lkgInsideProducts![0].isSelected = true;
    }
    maxCount = widget.lkgInsideProducts!.length;
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
        if (controller.offset > 0) {
          storingOffset.value = controller.offset;
        }
      });
      print('_controller.offset ${storingOffset.value} '
          'controller.position.maxScrollExtent ${controller.position
          .maxScrollExtent}'
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

  Widget _getRow(int i, List<LkgInsideModelList>? lkgInsideProducts,
      double height, double width) {
    print(
        'checking the bool value in inside screen ${widget.lkgInsideProducts![i]
            .isDownloaded.value}');


    var futStatus = checkingTheDownloadFile(
        widget.lkgInsideProducts![i].videoUrl);

    futStatus.then((value) {
      debugPrint(' checking file exists ${value} is file exists ');
      widget.lkgInsideProducts![i].isDownloaded.value = value;
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
                    .lkgInsideProducts![i].isDownloaded.value }');
                if (PlatformType.isTv == false) {
                  // widget.lkgInsideBloc!.add(
                  //     LkgInsideWatchOnlineNavigateButtonEvent(
                  //         videoID: widget.lkgInsideProducts![i].id));


                  widget.lkgInsideBloc!.add(LkgInsideNavigateButtonEvent(
                      videoID: widget.lkgInsideProducts![i].id,
                      videoUrl: widget.lkgInsideProducts![i].videoUrl,
                      isDownload: true),);
                }
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text('${widget.lkgProducts![i].title}'),
                // ));
              },
              child: SizedBox(
                height: 230,
                width: 118,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      // imageUrl: 'https://img.freepik.com/free-photo/shot-cute-baby-girl-looking-camera_329181-19580.jpg?size=626&ext=jpg&ga=GA1.1.819226140.1685039441&semt=ais',
                      imageUrl: lkgInsideProducts![i].imageUrl,
                      fit: BoxFit.fill,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            height: 220,
                            width: 134,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color:
                                  PlatformType.isTv == false ?
                                  Colors.transparent :
                                  widget.lkgInsideProducts![i].isSelected ==
                                      true
                                      ? widget.lkgInsideProducts![i].borderColor
                                      : Colors.transparent,
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
                                widget.lkgInsideProducts![i].title,
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
                        widget.lkgInsideProducts![i].isDownloaded.value == false
                            ? Container(
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

                          widget.lkgInsideProducts![i].isDownloaded.value ==
                              false ?
                          Icon(Icons.download_rounded,
                            color: Colors.white,) : SizedBox.shrink();
                      }),
                    ),


                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12)),
                    //   color:
                    //           widget.lkgInsideProducts![i].isSelected == true
                    //       ? Colors.blue
                    //       : null,
                    //   child:  Center(child:  Padding(
                    //     padding:  const EdgeInsets.all(10.0),
                    //     child: CachedNetworkImage(
                    //       height: double.maxFinite,
                    //       width: double.maxFinite,
                    //       imageUrl:
                    //       lkgInsideProducts![i].imageUrl,
                    //       fit: BoxFit.fill,
                    //       progressIndicatorBuilder: (context, url,
                    //           downloadProgress) =>
                    //           Center(
                    //               child: SizedBox(
                    //                 height:20,width:20,
                    //                 child: CircularProgressIndicator(
                    //                     value:
                    //                     downloadProgress.progress),
                    //               )),
                    //       errorWidget: (context, url, error) =>
                    //           FittedBox(
                    //             fit: BoxFit.contain,
                    //             child:
                    //             Image.asset('assets/logo.png'),
                    //           ),
                    //     ),
                    //   ),),
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
                  widget.lkgInsideBloc!.add(LkgInsideNavigateButtonEvent(
                    videoID: widget.lkgInsideProducts![i].id,
                    isDownload: false,
                    // isDownload: widget.lkgInsideProducts![i].isDownloaded.value,
                  ));


                  print('checking the downloaded file is available  ${widget
                      .lkgInsideProducts![i].isDownloaded.value}');


                  // widget.lkgInsideBloc!.add(
                  //     LkgInsideWatchOnlineNavigateButtonEvent(
                  //         videoID: widget.lkgInsideProducts![i].id));
                },
                child: Row(
                  children: [
                    Icon(Icons.play_circle_fill, color: Colors.red,),
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
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: SizedBox(
          //     width: 160,
          //     child: Text(
          //       widget.lkgInsideProducts![i].title,
          //       maxLines: 3,
          //       overflow: TextOverflow.ellipsis,
          //       style: GoogleFonts.poppins(
          //           fontSize: 12,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: SizedBox(
          //     width: 160,
          //     child: Text(
          //       '${widget.lkgInsideProducts![i].description}',
          //       style: GoogleFonts.poppins(
          //           fontSize: 10,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.grey.shade500),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 14),
          //   child: SizedBox(
          //     width: 160,
          //     child: Row(
          //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         RatingBar.builder(
          //           initialRating: double.parse(
          //               widget.lkgInsideProducts![i].rating.toString()),
          //           minRating: 1,
          //           direction: Axis.horizontal,
          //           allowHalfRating: true,
          //           itemCount: 5,
          //           itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
          //           itemBuilder: (context, _) =>
          //           const Icon(
          //             Icons.star,
          //             color: Colors.amber,
          //             // size: 10,
          //           ),
          //           itemSize: 12,
          //           onRatingUpdate: (rating) {
          //             widget.lkgInsideBloc!.add(
          //                 LkgInsideUpdatingRatingStarEvent(
          //                   videoID: widget.lkgInsideProducts![i].id,
          //                   rating: rating,
          //                 ));
          //             print('rating $rating');
          //           },
          //         ),
          //         Spacer(),
          //         // Text(
          //         //   '${widget.lkgInsideProducts![i].views} watching',
          //         //   overflow: TextOverflow.ellipsis,
          //         //   style: GoogleFonts.poppins(
          //         //       fontSize: 12,
          //         //       fontWeight: FontWeight.bold,
          //         //       color: Colors.grey.shade500),
          //         // ),
          //         InkWell(
          //           onTap: () {
          //
          //             widget.lkgInsideBloc!.add(LkgInsideNavigateButtonEvent(
          //                 videoID: widget.lkgInsideProducts![i].id,
          //                 isDownload: widget.lkgInsideProducts![i].isDownloaded
          //                     .value));
          //
          //
          //             // widget.lkgInsideBloc!.add(
          //             //     LkgInsideWatchOnlineNavigateButtonEvent(
          //             //         videoID: widget.lkgInsideProducts![i].id));
          //           },
          //           child:  Text(
          //             'Watch Online',
          //             overflow: TextOverflow.ellipsis,
          //             style: GoogleFonts.poppins(
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.green),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(
          //     '${widget.lkgInsideProducts![i].views} watching',
          //     overflow: TextOverflow.ellipsis,
          //     style: GoogleFonts.abel(
          //         fontSize: 12,
          //         fontWeight: FontWeight.normal,
          //         color: Colors.black),
          //   ),
          // ),
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
          content: Text('${widget.lkgInsideProducts![counter].title}'),
        );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                widget.lkgInsideBloc!.add(LkgInsideNavigateButtonEvent(
                  videoID: widget.lkgInsideProducts![counter].id,));
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              break;
            case 'Enter':
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              break;
          }
        } else if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
          debugPrint(
              'arrowRight listViewValue $listViewValue widget.lkgProducts!.length ${widget
                  .lkgInsideProducts!.length}');

          widget.lkgInsideBloc!.add(LkgInsideChangingTheColorEvent(
              index: counter,
              isRightButton: true,
              lkgInsideProducts: widget.lkgInsideProducts!));

          _nextCounter();
        } else if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          debugPrint(
              'arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${widget
                  .lkgInsideProducts!.length}');

          widget.lkgInsideBloc!.add(LkgInsideChangingTheColorEvent(
              index: counter,
              isRightButton: false,
              lkgInsideProducts: widget.lkgInsideProducts!));
          _lessCounter();
        }

        if (event is RawKeyDownEvent) {
          print('--> ${event.data.keyLabel}');
          // handle key down
        } else if (event is RawKeyUpEvent) {
          // handle key up
        }
      },
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.lkgInsideProducts!.isEmpty
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
            bucket: lkgInsideBucket,
            child: AnimationLimiter(
              child: Container(
                // color: Colors.red,
                // padding: EdgeInsets.only(top: 60),
                // height: Get.height/1.47,
                height: Get.height / 1.3,
                child: ListView.separated(
                  key: const PageStorageKey<String>('Page1'),
                  physics: BouncingScrollPhysics(),
                  // padding: EdgeInsets.only(top: Get.height * 0.1),
                  separatorBuilder: (_, i) => SizedBox(width: 1,),
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
                              i, widget.lkgInsideProducts, height, width),
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
      ),
    );
  }
}
