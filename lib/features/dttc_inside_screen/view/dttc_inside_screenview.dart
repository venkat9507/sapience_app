
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/features/dttc_inside_screen/database_items/item_data.dart';
import 'package:nimu_tv/features/video/features/view/video.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../config/circle_back_button.dart';
import '../../../config/download_prompt.dart';
import '../../lkg_screen/view/lkg_screen.dart';
import '../bloc/dttc_inside_bloc.dart';
import '../dttc_inside_model/dttc_inside_model.dart';

class DTTCInsideScreenView extends StatefulWidget {
  final int? sectionID;
  final String? term;
  final String? title;
  const DTTCInsideScreenView({Key? key,this.title,
    this.term,this.sectionID}) : super(key: key);

  @override
  State<DTTCInsideScreenView> createState() => _DTTCInsideScreenViewState();
}

class _DTTCInsideScreenViewState extends State<DTTCInsideScreenView> {
  final DTTCInsideBloc dttcInsideBloc = DTTCInsideBloc();

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

    debugPrint('--> ${widget.sectionID} widget.term ${widget.term} widget.title ${widget.title}');

    dttcInsideBloc.add(DTTCInsideInitialEvent(
      // lkgInsideProducts: lkgInsideDataItems,
      sectionID: widget.sectionID,term: widget.term,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return BlocConsumer<DTTCInsideBloc, DTTCInsideState>(
      bloc: dttcInsideBloc,
      listenWhen: (previous, current) => current is DTTCInsideActionState,
      buildWhen: (previous, current) => current is! DTTCInsideActionState,
      listener: (context, state) {
        if (state is DTTCInsideActionButtonState) {
          // Navigator.pushAndRemoveUntil(context,
          //     PageTransition(
          //         type: PageTransitionType.bottomToTop,
          //         duration: const Duration(seconds: 1),
          //         child:  LkgInsideScreenView(videoCatID: state.videoCatID,
          //           sectionID: state.sectionID,title: state.title,)),(Route<dynamic> route) => false);


         if(width> 900){
           Navigator.push(context,
             PageTransition(
                 type: PageTransitionType.scale,
                 alignment: Alignment.center,
                 duration: const Duration(milliseconds: 100),
                 child:  VideoScreenView(
                   videoNumber: state.videoID,
                   videosList: dttcInsideModel!.data,
                   isDownload: false,
                 )),);
         }else
           {
             downloadVideoOrPlay(
                 context: context,
                 width: width,
                 noButton: (){
                   Navigator.pop(context);
                   Navigator.push(context,
                     PageTransition(
                         type: PageTransitionType.scale,
                         alignment: Alignment.center,
                         duration: const Duration(milliseconds: 100),
                         child:  VideoScreenView(
                           videoNumber: state.videoID,
                           videosList: dttcInsideModel!.data,
                           isDownload: false,
                         )),);
                 },
                 yesButton: (){
                   Navigator.pop(context);
                   // lkgInsideBloc.add(LkgInsideDownloadNavigateButtonEvent());

                   Navigator.push(context,
                     PageTransition(
                         type: PageTransitionType.scale,
                         alignment: Alignment.center,
                         duration: const Duration(milliseconds: 100),
                         child:  VideoScreenView(
                           videoNumber: state.videoID,
                           videosList: dttcInsideModel!.data,
                           isDownload: true,
                         )),);
                 }

             );
           }


          // Navigator.push(context,
          //   PageTransition(
          //       type: PageTransitionType.bottomToTop,
          //       duration: const Duration(seconds: 1),
          //       child:  VideoScreenView(
          //         videoNumber: state.videoID,
          //         videosList: dttcInsideModel!.data,
          //         isDTTC: true,
          //         isDownload: false,
          //       )),);



          // ScaffoldMessenger.of(context)
          //     .showSnackBar( SnackBar(content: Text('${state.videoID}')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }
        else if(state is DTTCInsideUpdatingRatingStarButtonLoadingState){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Star rating updating...'),duration: Duration(milliseconds: 1000),));
        }
        else if(state is DTTCInsideUpdatingRatingStarButtonLoadedSuccessState){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Star rating updated successfully'),duration: Duration(milliseconds: 1000),));
        }
        else if(state is DTTCInsideUpdatingRatingStarButtonErrorState){
          ScaffoldMessenger.of(context)
              .showSnackBar( SnackBar(content: Text(state.error)));
        }

        else if (state is DTTCInsideBackActionButtonState) {
          // Navigator.pushAndRemoveUntil(context,
          //     PageTransition(
          //         type: PageTransitionType.bottomToTop,
          //         duration: const Duration(seconds: 1),
          //         child:  LkgScreenView(sectionID: widget.sectionID,)),(Route<dynamic> route) => false);

          Navigator.pop(context);

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
          case DTTCInsideInitialLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case DTTCInsideInitialLoadedSuccessState:
            final successState = state as DTTCInsideInitialLoadedSuccessState;

            return Scaffold(
                body: Stack(
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
                    const Positioned(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 20,
                      child: Card(
                        elevation: 10,
                        color: Colors.white70,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // implement GridView.builder
                            child: HomePage(
                              dttcInsideBloc: dttcInsideBloc,
                              dttcInsideProducts: successState.dttcProducts,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 30,
                      child: CircleButton(
                          onTap: () {
                            dttcInsideBloc.add(DTTCInsideBackNavigateButtonEvent());
                          },
                          iconData: Icons.arrow_back),
                    ),
                    Positioned(
                      top: 35,
                      left: 100,
                      child: Text(
                        successState.title.toString(),
                        style: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ));
          case DTTCInsideInitialErrorState:
            final errorState = state as DTTCInsideInitialErrorState;

            return  Scaffold(body: Center(child: Text('Error ${errorState.error}')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.dttcInsideProducts, this.dttcInsideBloc})
      : super(key: key);

  final List<DTTCInsideModelList>? dttcInsideProducts;
  final DTTCInsideBloc? dttcInsideBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  static int maxCount = 0;
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  var keyboardFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    if(widget.dttcInsideProducts!.isNotEmpty){
      widget.dttcInsideProducts![0].isSelected = true;
    }
    maxCount = widget.dttcInsideProducts!.length;
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
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

  Widget _getRow(
      int i,
      List<DTTCInsideModelList>? dttcInsideProducts,
      double height , double width
      ) {
    return _wrapScrollTag(
      index: i,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: 400,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if(width < 900){
                  widget.dttcInsideBloc!.add(DTTCInsideNavigateButtonEvent(videoID: widget.dttcInsideProducts![i].id));
                }
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text('${widget.dttcProducts![i].title}'),
                // ));
              },
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color:
                    widget.dttcInsideProducts![i].isSelected == true
                        ? Colors.blue
                        : null,
                    child:  Center(child:  Padding(
                      padding:  const EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        imageUrl:
                        dttcInsideProducts![i].imageUrl,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            Center(
                                child: SizedBox(
                                  height:20,width:20,
                                  child: CircularProgressIndicator(
                                      value:
                                      downloadProgress.progress),
                                )),
                        errorWidget: (context, url, error) =>
                            FittedBox(
                              fit: BoxFit.contain,
                              child:
                              Image.asset('assets/logo.png'),
                            ),
                      ),
                    ),),
                  ),

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
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.dttcInsideProducts![i].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.abel(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${widget.dttcInsideProducts![i].description}',
              style: GoogleFonts.abel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500),
            ),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 14),
          //   child: RatingBar.builder(
          //     initialRating: double.parse(widget.dttcInsideProducts![i].rating.toString()),
          //     minRating: 1,
          //     direction: Axis.horizontal,
          //     allowHalfRating: true,
          //     itemCount: 5,
          //     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          //     itemBuilder: (context, _) => const Icon(
          //       Icons.star,
          //       color: Colors.amber,
          //       // size: 10,
          //     ),
          //     itemSize: 19,
          //     onRatingUpdate: (rating) {
          //       widget.dttcInsideBloc!.add(DTTCInsideUpdatingRatingStarEvent(
          //         videoID: widget.dttcInsideProducts![i].id,
          //         rating: rating,
          //       ));
          //       print('rating $rating');
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 5,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(
          //     '${widget.dttcInsideProducts![i].views} watching',
          //     overflow: TextOverflow.ellipsis,
          //     style: GoogleFonts.abel(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.grey.shade500),
          //   ),
          // ),
        ],
      ),
    );
  }

  int listViewValue = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          content: Text('${widget.dttcInsideProducts![counter].title}'),
        );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                widget.dttcInsideBloc!.add(DTTCInsideNavigateButtonEvent(videoID: widget.dttcInsideProducts![counter].id));
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
              'arrowRight listViewValue $listViewValue widget.dttcProducts!.length ${widget.dttcInsideProducts!.length}');

          widget.dttcInsideBloc!.add(DTTCInsideChangingTheColorEvent(
              index: counter,
              isRightButton: true,
              dttcInsideProducts: widget.dttcInsideProducts!));

          _nextCounter();
        } else if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          debugPrint(
              'arrowLeft listViewValue $listViewValue widget.dttcProducts!.length ${widget.dttcInsideProducts!.length}');

          widget.dttcInsideBloc!.add(DTTCInsideChangingTheColorEvent(
              index: counter,
              isRightButton: false,
              dttcInsideProducts: widget.dttcInsideProducts!));
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
        children: [
          widget.dttcInsideProducts!.isEmpty ?       Text(
            'No Data Available',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.abel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,wordSpacing: 5),
          )
              :
          SizedBox(
            height: height * 0.7,
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  // maxCrossAxisExtent: 200,
                  // crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 260,
                ),
                controller: controller,
                // scrollDirection: Axis.horizontal,
                itemCount: maxCount,
                itemBuilder: (_, i) {
                  return AnimationConfiguration.staggeredGrid(
                    position: i,
                    columnCount: 3,
                    child: ScaleAnimation(
                      duration: Duration(seconds: 3),
                      child: FadeInAnimation(
                        child: _getRow(
                            i,
                            widget.dttcInsideProducts,
                            height,
                            width
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
