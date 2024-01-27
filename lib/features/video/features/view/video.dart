import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/color_const.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:nimu_tv/features/lkg_inside_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/lkg_screen/bloc/bloc/lkg_bloc.dart';
import 'package:nimu_tv/features/video/features/bloc/video_bloc.dart';
import 'package:nimu_tv/features/video/features/view/video_player.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/audio_player.dart';
import '../../../../config/check_internet_connection.dart';
import '../../../../config/circular_progressindicator.dart';
import '../../../lkg_inside_screen/view/lkg_inside_screen.dart';
import '../../../ukg_inside_screen/view/ukg_inside_screen.dart';
import '../database/item_data.dart';
import '../download/download.dart';


class VideoScreenView extends StatefulWidget {
  final int? videoNumber;
  final List<dynamic>? videosList;
  final bool? isDTTC;
  final bool isDownload;
  final String? videoUrl;

  const VideoScreenView({Key? key,
    required this.isDownload,
    this.videoNumber, this.videosList, this.isDTTC,this.videoUrl}) : super(key: key);

  @override
  State<VideoScreenView> createState() => _VideoScreenViewState();
}

class _VideoScreenViewState extends State<VideoScreenView> {
  // late VideoPlayerController _controller;
  final VideoBloc videoBloc = VideoBloc();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey = GlobalKey<
      ScaffoldState>();
  // double percent = 0.0;

  @override
  void initState() {
    super.initState();
    // musicStop();
    // Timer? timer;
    // timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
    //   setState(() {
    //     percent += 10;
    //     if (percent >= 100) {
    //       timer?.cancel();
    //       // percent=0;
    //     }
    //   });
    // });
    debugPrint('checking the video number ${widget.videoNumber} ${widget.videoUrl}');


    videoBloc.add(VideoInitialEvent(
      videoNumber: widget.videoNumber,
      videosList: widget.videosList,
      isDTTC: widget.isDTTC,
      isDownload: widget.isDownload,
      videoUrl: widget.videoUrl??'null',
    ));


    // _controller = VideoPlayerController.network('https://sapiencepublications.co.in/storage/uploads/XKUXnPEeKqCYayoKr5Vb02aanBqdfKgQrBBvaNdJ.mp4');
    // // _controller = VideoPlayerController.asset('assets/viduthalai.mp4');
    //
    // _controller.addListener(() {
    //   setState(() {});
    // });
    // _controller.setLooping(true);
    // _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
    //
    // videoBloc.add(VideoInitialEvent(
    //     videoNumber: widget.videoNumber
    //   // lkgProducts: lkgDataItems,
    // ));


  }

  @override
  void dispose() {
    // controller!.dispose();
    super.dispose();
  }

  void showCustomDialog(BuildContext context) {
    print('checking the value');
    showGeneralDialog(
        context: context,
        // barrierDismissible: true,
        barrierLabel: MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
              // padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.15,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'SUBSCRIBE',
                          style: GoogleFonts.abel(
                              color: Colors.white,
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  10.ph,
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"s standard dummy text ever since the 1500s, ',
                        style: GoogleFonts.abel(
                            color: Colors.black,
                            fontSize: 24, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: 100,
                        height: 44,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(12),
                          gradient: const RadialGradient(
                            radius: 2,
                            // focalRadius: 5,
                            colors: [Color(0xFFE77817), Color(0xFFF8B57B)],

                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'CONFIRM',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: 100,
                        height: 44,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.deepOrange
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
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
    return BlocConsumer<VideoBloc, VideoState>(
      bloc: videoBloc,
      listenWhen: (previous, current) => current is VideoActionState,
      buildWhen: (previous, current) => current is! VideoActionState,
      listener: (context, state) {
        if (state is VideoPrevOrNextState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: VideoScreenView(videoNumber: state.videoNumber,
                    videosList: state.videosList, isDownload: false,)), (
                  Route<dynamic> route) => true);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }
        else if (state is VideoDownloadActionButtonLoadingState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
              const SnackBar(content: Text('Please wait downloading...'),
                duration: Duration(seconds: 60),
              ));
        }
        else if (state is VideoDownloadActionButtonSuccessState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(content: Text(state.successState!.toString()),
                // duration: Duration(milliseconds: 1000),
              ));
        }
        else if (state is VideoPrevOrNextErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.error}')));
        }
        // else if (state is LkgDrawerActionButtonState) {
        //
        //   switchingBetweenDifferentWidget(index: state.index,context: context,sectionID: state.sectionID);
        //
        // }
        else if (state is VideoPrevOrNextLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please Wait Loading...'),
                duration: Duration(milliseconds: 1000),));
        }
        else if (state is VideoPauseButtonState) {
          setState(() {
            isOnTap = !isOnTap!;
            if (isOnTap == true) {
              Future.delayed(Duration(seconds: 2), () {
                isOnTap = !isOnTap!;
              });
            }
          });
        }
        else if (state is VideoBackButtonPressedState) {
          // Navigator.of(cxt!).pop();
          // Navigator.pop(context);

          print('checking the storingInsideScreenNo value $storingInsideScreenNo');


          if (storingInsideScreenNo == 0) {
            Navigator.pushAndRemoveUntil(context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: LkgInsideScreenView(
                      videoCatID: storingVideoCloseModel?.videoCat,
                      sectionID: storingVideoCloseModel?.sectionID,
                      title: storingVideoCloseModel?.title,)), (
                    Route<dynamic> route) => true);
          }
          else  if (storingInsideScreenNo == 1) {
            Navigator.pushAndRemoveUntil(context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    child: UkgInsideScreenView(
                      videoCatID: storingVideoCloseModel?.videoCat,
                      sectionID: storingVideoCloseModel?.sectionID,
                      title: storingVideoCloseModel?.title,)), (
                    Route<dynamic> route) => true);
          }
        }
        // else if (state is LkgLogoutButtonLoadedSuccessState) {
        //   Navigator.pushAndRemoveUntil(context,
        //       PageTransition(
        //           type: PageTransitionType.bottomToTop,
        //           duration: const Duration(seconds: 1),
        //           child: const SplashScreenView()),(Route<dynamic> route) => false);
        //
        // }
        // else if (state is LkgLogoutButtonErrorState) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(state.error)));
        //
        //
        // }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case VideoInitialLoadingState:
            return Scaffold(
              body: Obx(() {
                return Center(
                  child:
                  downloadPercentage.value.toDouble() != 0.0 ?
                  SizedBox(
                    height: 200,width: 200,
                    child: CircularProgress(
                      percentage: (downloadPercentage.value.toDouble() ) ,
                      color: primaryBlue,
                      backColor: Colors.grey,
                      // gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                      showPercentage: true,
                      textStyle:TextStyle(color: primaryOrange,fontSize: 20),
                      stroke: 10,
                      round: true,
                    ),
                  )
                  // CircularPercentIndicator(
                  //   radius: 50.0,
                  //   lineWidth: 10.0,
                  //   animation: true,
                  //   percent: (downloadPercentage.value.toDouble() / 100) ,
                  //   center: Text(
                  //     '${downloadPercentage.value
                  //         .toDouble() } %',
                  //     style: TextStyle(
                  //         fontSize: 20.0,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.black),
                  //   ),
                  //   backgroundColor: Colors.grey[300]!,
                  //   circularStrokeCap: CircularStrokeCap.round,
                  //   progressColor: Colors.redAccent,
                  // )
                  : Text(
                    'Loading Please Wait ...',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                );
              }),
            );
            return circularProg!;

          case VideoInitialLoadedSuccessState:
            final successState = state as VideoInitialLoadedSuccessState;

            print('video number--> ${widget.videoNumber} state.isDownload ${state.isDownload} widget.isDownload ${widget.isDownload} '
            );

            double baseWidth = 800.0000610352;
            double fem = MediaQuery
                .of(context)
                .size
                .width / baseWidth;
            double ffem = fem * 0.97;

            return WillPopScope(
              onWillPop: () async {
                controller!.pause();
                videoBloc.add(VideoBackNavigateButtonEvent());
                return await true;
              },
              child: VideoInsideScreenView(
                videoUrl: successState.videoData!.videoUrl,
                videoBloc: videoBloc,
                videosList: widget.videosList,
                videoNumber: widget.videoNumber,
                videoData: successState.videoData,
                // controller: _controller,
                isDownload: state.isDownload ?? widget.isDownload,

              ),
            );
          case VideoInitialErrorState:
            final errorState = state as VideoInitialErrorState;

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
                  controller!.pause();
                  videoBloc.add(VideoBackNavigateButtonEvent());
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




