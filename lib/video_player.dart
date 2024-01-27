import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    var snackBar = const SnackBar(
      duration: Duration(seconds: 90),
      content: Text(
          'The Given time for playing this video is ended please subscribe for viewing more content'),
    );

    Future.delayed(Duration(seconds: 2),(){
      showCustomDialog(context);
    });
    Future.delayed(const Duration(seconds: 30), () {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    });

    super.initState();
    _controller = VideoPlayerController.network('https://sapiencepublications.co.in/storage/uploads/XKUXnPEeKqCYayoKr5Vb02aanBqdfKgQrBBvaNdJ.mp4');
    // _controller = VideoPlayerController.asset('assets/viduthalai.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showCustomDialog(BuildContext context) {
    print('checking the value');
    showGeneralDialog(
        context: context,
        // barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              // padding: EdgeInsets.all(20),
             decoration: const BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(12)),
               color: Colors.white,
             ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width ,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'SUBSCRIBE',
                            style: GoogleFonts.abel(
                                color: Colors.white,
                                fontSize: 30,fontWeight: FontWeight.bold),
                          ),
                        ),
                    ),
                  ),
                  10.ph,
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"s standard dummy text ever since the 1500s, ',
                        style: GoogleFonts.abel(
                            color: Colors.black,
                            fontSize: 24,fontWeight: FontWeight.bold),
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
                          onPressed: () {  },
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
                        decoration:   BoxDecoration(
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
                            shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// bool isSelectButtonPressed = false;

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller});

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

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
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

        var currentPosition = widget.controller.position;

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
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                'LKG_SAPIENCE WAY OF LEARNING_VIDEO 1 ',
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
          ),
                IconButton(onPressed: (){}, icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                  semanticLabel: 'Play',
                ),),
              ],
            ),),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: widget.controller.value.isPlaying
                ? const SizedBox.shrink()
                : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.first_page,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          10.pw,
                          TextButton(     // <-- TextButton
                            onPressed: () {},
                            child:   Text(
                              'PREV',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.abel(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // color: Colors.black26,
                                child:  IconButton(onPressed: (){}, icon: const Icon(
                                  Icons.forward_5_outlined,
                                  color: Colors.white,
                                  size: 50.0,
                                  // semanticLabel: 'Play',
                                  weight: 0.5,
                                ),),
                              ),
                              Container(
                                // color: Colors.black26,
                                child:  IconButton(
                                  onPressed: (){}, icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50.0,
                                  semanticLabel: 'Play',
                                ),),
                              ),
                              Container(
                                // color: Colors.black26,
                                child:  IconButton(onPressed: (){}, icon: const Icon(
                                  Icons.forward_5,
                                  color: Colors.white,
                                  size: 50.0,
                                  semanticLabel: 'Play',
                                ),),
                              ),
                            ],
                          ),
                      ),
                      Row(
                        children: [
                          TextButton(     // <-- TextButton
                            onPressed: () {},
                            child:   Text(
                              'NEXT',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.abel(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                           10.pw,
                           const Icon(
                            Icons.last_page,
                            size: 24.0,
                             color: Colors.white,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
          ),
          GestureDetector(
            onTap: () {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            },
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: PopupMenuButton<Duration>(
          //     initialValue: controller.value.captionOffset,
          //     tooltip: 'Caption Offset',
          //     onSelected: (Duration delay) {
          //       controller.setCaptionOffset(delay);
          //     },
          //     itemBuilder: (BuildContext context) {
          //       return <PopupMenuItem<Duration>>[
          //         for (final Duration offsetDuration in _exampleCaptionOffsets)
          //           PopupMenuItem<Duration>(
          //             value: offsetDuration,
          //             child: Text('${offsetDuration.inMilliseconds}ms'),
          //           )
          //       ];
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         // Using less vertical padding as the text is also longer
          //         // horizontally, so it feels like it would need more spacing
          //         // horizontally (matching the aspect ratio of the video).
          //         vertical: 12,
          //         horizontal: 16,
          //       ),
          //       child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: PopupMenuButton<double>(
          //     initialValue: controller.value.playbackSpeed,
          //     tooltip: 'Playback speed',
          //     onSelected: (double speed) {
          //       // controller.setPlaybackSpeed(speed);
          //     },
          //     itemBuilder: (BuildContext context) {
          //       return <PopupMenuItem<double>>[
          //         for (final double speed in _examplePlaybackRates)
          //           PopupMenuItem<double>(
          //             value: speed,
          //             child: Text('${speed}x'),
          //           )
          //       ];
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         // Using less vertical padding as the text is also longer
          //         // horizontally, so it feels like it would need more spacing
          //         // horizontally (matching the aspect ratio of the video).
          //         vertical: 12,
          //         horizontal: 16,
          //       ),
          //       child: Text('${controller.value.playbackSpeed}x'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
