import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:nimu_tv/features/video/features/bloc/video_bloc.dart';
import 'package:nimu_tv/features/video/features/download/download.dart';
import 'package:nimu_tv/features/video/models/video_models.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/utils.dart';
import '../../models/food_video_models.dart';
import '../bloc/food_video_bloc.dart';
import '../database/item_data.dart';

bool? isOnTap = false;

class FoodVideoInsideScreenView extends StatefulWidget {
  final String? videoUrl;
  final FoodVideoBloc videoBloc;
  final List<dynamic>? videosList;
  final int? videoNumber;
  final FoodVideoData? videoData;
  final bool isDownload;

  const FoodVideoInsideScreenView({Key? key,
    this.videoUrl,
    this.videoNumber,
    required this.isDownload,
    required this.videoBloc,
    this.videosList,
    this.videoData})
      : super(key: key);

  @override
  FoodVideoInsideScreenViewState createState() => FoodVideoInsideScreenViewState();
}

class FoodVideoInsideScreenViewState extends State<FoodVideoInsideScreenView> {
  // late VideoPlayerController _controller;
  Rx<bool> isBuffering = false.obs;
  Rx<int> defaultSeconds = 0.obs;
  Rx<int> staticSeconds = 0.obs;
  Rx<int> s1 = 0.obs;
  Rx<int> s2 = 0.obs;
  Rx<int> s3 = 0.obs;
  Rx<int> p1 = 0.obs;
  Rx<int> p2 = 0.obs;
  Rx<int> p3 = 0.obs;

  // controller!.value.position.inSeconds

  @override
  void initState() {
    var snackBar = const SnackBar(
      duration: Duration(seconds: 90),
      content: Text(
          'The Given time for playing this video is ended please subscribe for viewing more content'),
    );

    // Future.delayed(Duration(seconds: 2),(){
    //   showCustomDialog(context);
    // });
    // Future.delayed(const Duration(seconds: 30), () {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     snackBar,
    //   );
    // });

    super.initState();

    // downloadFile(widget.videoUrl!);

    if (widget.isDownload) {
      debugPrint(' checking video player url  ${widget.videoUrl}');
      foodController = VideoPlayerController.file(File('${widget.videoUrl}'));
    } else {
      foodController = VideoPlayerController.network('${widget.videoUrl}');
    }

    // _controller = VideoPlayerController.file(File('/data/user/0/com.example.nimu_tv/app_flutter/https://www.sapiencepublications.co.in/storage/uploads/v2d8OaCSfzleDWlwuZbXEEBA7pmfCDvaYEkRJ1cP.mp4'));

    foodController?.addListener(() {
      setState(() {
        print('isBufferingValue ${foodController?.value.buffered}');

        defaultSeconds.value = foodController!.value.position.inSeconds;
        staticSeconds.value = foodController!.value.duration.inSeconds;


        s1.value = staticSeconds.value % 60;
        s2.value = staticSeconds.value ~/ 60;
        s3.value = s2.value ~/ 60;

        p1.value = defaultSeconds.value % 60;
        p2.value = defaultSeconds.value ~/ 60;
        p3.value = p2.value ~/ 60;

        if (foodController!.value.buffered.isNotEmpty) {
          isBuffering.value = true;
        } else {
          isBuffering.value = false;
        }
      });
    });

    foodController?.setLooping(true);
    foodController?.initialize().then((_) => setState(() {}));
    foodController?.play();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void showCustomDialog(BuildContext context) {
    print('checking the value');
    showGeneralDialog(
        context: context,
        // barrierDismissible: true,
        barrierLabel:
        MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
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
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
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
                          border: Border.all(color: Colors.deepOrange),
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
    double baseWidth = 800.0000610352;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    // debugPrint('aspect ratio ${MediaQuery.of(context).size.aspectRatio}');
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned(
                // videooverlayozZ (39:1619)
                left: 0 * fem,
                top: 0 * fem,
                child: Container(
                  width: 800 * fem,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                  ),
                  child: VideoPlayer(
                    foodController!,
                  ),
                ),
              ),
              isOnTap == false
                  ? const SizedBox.shrink()
                  : Positioned(
                // gradientWPB (39:1785)
                left: 0 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 806 * fem,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(-0, -0),
                            radius: 0.34,
                            colors: <Color>[
                              Color(0x99000000),
                              Color(0x99000000)
                            ],
                            stops: <double>[0, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: (){
              //     print('center button  pressed');
              //     // if (widget.controller.value.isPlaying) {
              //     //   widget.controller.pause();
              //     // } else {
              //     //   widget.controller.play();
              //     // }
              //   },
              //   child: Container(
              //     height: 200,
              //     width: 200,
              //     color: Colors.black26,
              //     child:  IconButton(
              //       onPressed: (){
              //         debugPrint('center button  pressed');
              //         if (_controller.value.isPlaying) {
              //           _controller.pause();
              //         } else {
              //           _controller.play();
              //         }
              //
              //       }, icon: const Icon(
              //       Icons.play_arrow,
              //       color: Colors.white,
              //       size: 50.0,
              //       semanticLabel: 'Play',
              //     ),),
              //   ),
              // ),
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    if (foodController!.value.isPlaying) {
                      foodController?.pause();
                    } else {
                      foodController?.play();
                    }
                  });
                },
                onTap: () {
                  setState(() {
                    // isOnTap = !isOnTap!;

                    widget.videoBloc.add(FoodVideoPauseButtonEvent());
                    // Future.delayed(Duration(milliseconds: 2000),(){
                    //   isOnTap = !isOnTap!;
                    //   print('checking the mount ${mounted}');
                    // });
                  });
                },
                // child: Container(
                //   color: Colors.white60,
                // ),
              ),
              // Positioned(
              //   top: 20,
              //   left: 15,
              //   right: 15,
              //   child:  Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         widget.videoData!.title!,
              //         textAlign: TextAlign.center,
              //         style: GoogleFonts.poppins(
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white),
              //         overflow: TextOverflow.ellipsis,
              //       ),

              //     ],
              //   ),),

              Obx(() {
                return isBuffering.value == false
                    ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Buffering please wait...',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 10 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * ffem / fem,
                      letterSpacing: 0.5 * fem,
                      color: Colors.black,
                    ),
                  ),)
                    : SizedBox.shrink();
              }),
              isOnTap == false
                  ? Container()
                  : Positioned(
                  left: 30 * fem,
                  top: 163 * fem,
                  child: _ControlsOverlay(
                    controller: foodController!,
                    videoBloc: widget.videoBloc,
                    videoNumber: widget.videoNumber,
                    videosList: widget.videosList,
                  )),
              isOnTap == false
                  ? Container()
                  : Align(
                alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 767 * fem,
                      height: 25.73 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // e81 (39:1794)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 11 * fem, 2.73 * fem),
                            child: Obx(() {
                              return Text(
                                ' ${('${p3.toString().padLeft(2, '0')} : ${p2
                                    .toString().padLeft(2, '0')} : ${p1.toString()
                                    .padLeft(2, '0')}')}',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 10 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: 0.5 * fem,
                                  color: Color(0xffffffff),
                                ),
                              );
                            }),
                          ),
                          Container(
                            // autogroupndhx8J5 (LLGGFGt5inabZ6ZatQNdHX)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 13.81 * fem, 0 * fem),
                            width: 630.19 * fem,
                            height: 25.73 * fem,
                            child: VideoProgressIndicator(
                              foodController!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          Container(
                            // RY5 (39:1780)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 2.73 * fem),
                            child: Obx(() {
                              return Text(
                                ' ${('${s3.toString().padLeft(2, '0')} : ${s2
                                    .toString().padLeft(2, '0')} : ${s1.toString()
                                    .padLeft(2, '0')}')}',

                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 10 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  letterSpacing: 0.5 * fem,
                                  color: Color(0xffffffff),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

              isOnTap == false
                  ? Container()
                  : Positioned(
                // lkgthesapiencewayoflearningvid (39:1786)
                left: 27 * fem,
                top: 29 * fem,
                child: Align(
                  child: SizedBox(
                    width: 274 * fem,
                    height: 16 * fem,
                    child: Text(
                      widget.videoData!.title!,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 0.6449999809 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
              isOnTap == false
                  ? Container()
                  : Positioned(
                // xcloser6u (39:1710)
                left: 752 * fem,
                top: 23 * fem,
                // right: 50,
                child: InkWell(
                  onTap: () {
                    foodController?.pause();
                    widget.videoBloc.add(FoodVideoBackNavigateButtonEvent());
                  },
                  child: SizedBox(
                    // color: Colors.red,
                    width: 50 * fem,
                    height: 50 * fem,
                    child: Center(
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        // size: 30,
                        semanticLabel: 'Close',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// bool isSelectButtonPressed = false;

class _ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final FoodVideoBloc videoBloc;
  final List<dynamic>? videosList;
  final int? videoNumber;

  const _ControlsOverlay({
    required this.controller,
    this.videoNumber,
    required this.videoBloc,
    this.videosList,
  });

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  var keyboardFocusNode = FocusNode();
  int? prevVideoID;
  int? nextVideoID;

  @override
  void dispose() {
    // TODO: implement dispose
    keyboardFocusNode.dispose();
    // widget.controller.pause();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    for (var item in widget.videosList!) {
      debugPrint(
          'checking the video list ${item.id} video number ${widget
              .videoNumber} video number list length${widget.videosList!
              .length}');

      if (item.id == widget.videoNumber) {
        int? indexNumber;
        debugPrint('index of ${widget.videosList!.indexOf(item)}'
          // 'checking the video list ${item.id} video number ${widget.videoNumber}'
        );
        indexNumber = widget.videosList!.indexOf(item);
        if (indexNumber > 0) {
          prevVideoID = widget.videosList![indexNumber - 1].id;
        }

        if (indexNumber != widget.videosList!.length - 1) {
          nextVideoID = widget.videosList![indexNumber + 1].id;
        }
      }
    }
    super.initState();
  }

  var currentPosition;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 800.0000610352;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    // changingTheTap();
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

        currentPosition = widget.controller.position;

        // if (LogicalKeyboardKey.enter.keyLabel == event.logicalKey.keyLabel) {
        //
        //   print("checking whether enter is pressed or not");
        //   controller.value.isPlaying ? controller.pause() : controller.play();
        //   // setState(() {
        //   //   print("_controller.value.isPlaying ${controller.value.isPlaying}");
        //   //
        //   // });
        // }

        var snackBar = SnackBar(
          content: Text('${event.physicalKey.debugName}'),
        );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                if (widget.controller.value.isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
              });
              break;
            case 'Enter':
              setState(() {
                if (widget.controller.value.isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
              });
              break;
          }
        }

        // if (LogicalKeyboardKey.enter.keyLabel == event.logicalKey.keyLabel) {
        //
        //   if(isSelectButtonPressed){
        //     isSelectButtonPressed =false;
        //     print('isSelectButtonPressed status 1 $isSelectButtonPressed');
        //
        //   }
        //   else if (isSelectButtonPressed == false){
        //     print('isSelectButtonPressed status 2 $isSelectButtonPressed');
        //
        //     isSelectButtonPressed = true;
        //   }
        //
        //
        //   var snackBar = SnackBar(
        //     content: Text('${isSelectButtonPressed}'),
        //   );
        //
        //   print("checking whether enter is pressed or not");
        //
        //  Future.delayed(Duration(seconds: 3),(){
        //    if(isSelectButtonPressed == true){
        //      print('pause');
        //      widget.controller.pause();
        //    }
        //    else
        //    {
        //      widget.controller.play();
        //    }
        //    ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        //  });
        // }

        else if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
          widget.controller
              .seekTo((await currentPosition)! + const Duration(seconds: 5));
        } else if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          widget.controller
              .seekTo((await currentPosition)! - const Duration(seconds: 5));
        }

        if (event is RawKeyDownEvent) {
          print('--> ${event.data.keyLabel}');
          // handle key down
        } else if (event is RawKeyUpEvent) {
          // handle key up
        }
      },
      child: isOnTap == false
          ? Container()
          : Container(
        width: 739 * fem,
        height: 70.01 * fem,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                widget.controller.pause();
                debugPrint('PREV pressed $prevVideoID');
                widget.videoBloc.add(FoodChangingTheVideoEvent(
                    videoNumber: widget.videoNumber,
                    prevVideoID: prevVideoID,
                    nextVideoID: nextVideoID,
                    isPrevButtonPressed: true,
                    videosList: widget.videosList));
              },
              child: Container(
                // group2RAh (39:1806)
                // color: Colors.red,
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 7 * fem, 124 * fem, 7.01 * fem),
                padding: EdgeInsets.fromLTRB(
                    4.17 * fem, 4 * fem, 0 * fem, 4 * fem),
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // skipforward857 (39:1808)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 8.17 * fem, 0 * fem),
                      width: 11.67 * fem,
                      height: 50,
                      child: Image.asset(
                        'assets/skip-forward-SFb.png',
                        width: 11.67 * fem,
                        height: 50,
                      ),
                    ),
                    // Text(
                    //   // prevdGm (39:1807)
                    //   'PREV',
                    //   style: SafeGoogleFont (
                    //     'Poppins',
                    //     fontSize: 14*ffem,
                    //     fontWeight: FontWeight.w600,
                    //     height: 0.8571428571*ffem/fem,
                    //     letterSpacing: -0.14*fem,
                    //     color: Color(0xffffffff),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                currentPosition = widget.controller.position;
                debugPrint('left arrow pressed $currentPosition');

                widget.controller.seekTo((await currentPosition)! -
                    const Duration(seconds: 5));
              },
              child: Container(
                // skipkMP (39:1747)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 123.99 * fem, 0 * fem),
                width: 34.01 * fem,
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      // refresh1GKj (39:1748)
                      left: 1.7715377808 * fem,
                      top: 1.771484375 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 32.47 * fem,
                          height: 50,
                          child: Image.asset(
                            'assets/refresh-1.png',
                            width: 30.47 * fem,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // kkh (39:1752)
                      left: 10.3930053711 * fem,
                      top: 18.337890625 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 20 * fem,
                          height: 12 * fem,
                          child: Text(
                            '05',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 12 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1 * ffem / fem,
                              letterSpacing: 0.24 * fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                debugPrint('center button  pressed');
                setState(() {
                  if (widget.controller.value.isPlaying) {
                    widget.controller.pause();
                  } else {
                    widget.controller.play();
                  }
                });
              },
              child: Container(
                // vector12CR (39:1740)
                // color: Colors.red,
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0.33 * fem, 123.55 * fem, 0 * fem),
                width: 80,
                height: 80,
                child: widget.controller.value.isPlaying == false
                    ? Align(
                  child: Image.asset(
                    'assets/vector-1-CH7.png',
                    width: 26.45 * fem,
                    height: 30,
                  ),
                )
                    : Icon(
                  Icons.pause,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                currentPosition = widget.controller.position;
                debugPrint('aright arrow pressed $currentPosition');

                widget.controller.seekTo((await currentPosition)! +
                    const Duration(seconds: 5));
              },
              child: Container(
                // skipLD7 (39:1741)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 117.99 * fem, 0 * fem),
                width: 34.01 * fem,
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      // refresh1TYd (39:1742)
                      left: 1.7746887207 * fem,
                      top: 1.771484375 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 32.47 * fem,
                          height: 50,
                          child: Image.asset(
                            'assets/refresh-1-bWh.png',
                            width: 30.47 * fem,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // MP7 (39:1746)
                      left: 10.3929748535 * fem,
                      top: 18.337890625 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 20 * fem,
                          height: 12 * fem,
                          child: Text(
                            '05',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 12 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1 * ffem / fem,
                              letterSpacing: 0.24 * fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.controller.pause();
                debugPrint('NEXT pressed $nextVideoID');
                debugPrint('widget.videosList ${widget.videosList}');
                widget.videoBloc.add(FoodChangingTheVideoEvent(
                    videoNumber: widget.videoNumber,
                    prevVideoID: prevVideoID,
                    nextVideoID: nextVideoID,
                    isPrevButtonPressed: false,
                    videosList: widget.videosList));
              },
              child: Container(
                // group1rKs (39:1803)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 7 * fem, 0 * fem, 7.01 * fem),
                padding: EdgeInsets.fromLTRB(
                    0 * fem, 4 * fem, 4.17 * fem, 4 * fem),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   // nextZEH (39:1804)
                    //   margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 7.17*fem, 0*fem),
                    //   child: Text(
                    //     'NEXT',
                    //     style: SafeGoogleFont (
                    //       'Poppins',
                    //       fontSize: 14*ffem,
                    //       fontWeight: FontWeight.w600,
                    //       height: 0.8571428571*ffem/fem,
                    //       letterSpacing: -0.14*fem,
                    //       color: Color(0xffffffff),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      // skipforward5Cd (39:1805)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 0 * fem),
                      width: 11.67 * fem,
                      height: 50,
                      child: Image.asset(
                        'assets/skip-forward-4HP.png',
                        width: 11.67 * fem,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
