
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
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../config/check_internet_connection.dart';
import '../../../config/circle_back_button.dart';
import '../../../config/custom_drawer.dart';
import '../../../config/download_prompt.dart';
import '../../dashboard_screen/view/dashboard_screen.dart';
import '../../splash_screen/view/splash_screen_view.dart';
import '../../video/features/view/video.dart';
import '../bloc/kids_food_video_inside_bloc.dart';
import '../database_items/items_data.dart';
import '../models/kids_food_video_inside_models.dart';

class KidsFoodVideoInsideScreenView extends StatefulWidget {
  final int? sectionID;
  final int? videoCatID;
  final String? title;
  const KidsFoodVideoInsideScreenView({Key? key,this.sectionID,this.title,this.videoCatID}) : super(key: key);
  @override
  State<KidsFoodVideoInsideScreenView> createState() => _KidsFoodVideoInsideScreenViewState();
}

class _KidsFoodVideoInsideScreenViewState extends State<KidsFoodVideoInsideScreenView> {
  final KidsFoodVideoInsideBloc kidsFoodVideoInsideBloc = KidsFoodVideoInsideBloc();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState



    kidsFoodVideoInsideBloc.add(KidsFoodVideoInsideInitialEvent(
      // kidsFoodVideoInsideProducts: KidsFoodVideoInsideDataItems,
      sectionID: widget.sectionID,
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
    return BlocConsumer<KidsFoodVideoInsideBloc, KidsFoodVideoInsideState>(
      bloc: kidsFoodVideoInsideBloc,
      listenWhen: (previous, current) => current is KidsFoodVideoInsideActionState,
      buildWhen: (previous, current) => current is! KidsFoodVideoInsideActionState,
      listener: (context, state) {
        if (state is KidsFoodVideoInsideActionButtonState) {


         if(width > 900){
           Navigator.push(context,
             PageTransition(
                 type: PageTransitionType.scale,
                 alignment: Alignment.center,
                 duration: const Duration(milliseconds: 100),
                 child:  VideoScreenView(
                   videoNumber: state.videoID,
                   videosList: kfvInsideModel!.data,
                   isDownload: false,
                 )),);
         }
         else
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
                           videosList: kfvInsideModel!.data,
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
                           videosList: kfvInsideModel!.data,
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
          //         videosList: kfvInsideModel!.data,
          //         isDownload: false,
          //       )),);

          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('Navigate Button Inside Clicked')));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        }
        else if(state is KFVInsideUpdatingRatingStarButtonLoadingState){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Star rating updating...'),duration: Duration(milliseconds: 1000),));
        }
        else if(state is KFVInsideUpdatingRatingStarButtonLoadedSuccessState){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Star rating updated successfully'),duration: Duration(milliseconds: 1000),));
        }
        else if(state is KFVInsideUpdatingRatingStarButtonErrorState){
          ScaffoldMessenger.of(context)
              .showSnackBar( SnackBar(content: Text(state.error)));
        }
        else if (state is KidsFoodVideoInsideBackActionButtonState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const DashboardScreenView()),(Route<dynamic> route) => false);
        }
        else if (state is KFVDrawerActionButtonState) {

          switchingBetweenDifferentWidget(index: state.index,context: context,sectionID: state.sectionID);

        }
        else if (state is KFVLogoutButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging out please wait ....')));

        }
        else if (state is KFVLogoutButtonLoadedSuccessState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const SplashScreenView()),(Route<dynamic> route) => false);

        }
        else if (state is KFVLogoutButtonErrorState) {
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
          case KidsFoodVideoInsideInitialLoadingState:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          case KidsFoodVideoInsideInitialLoadedSuccessState:
            final successState = state as KidsFoodVideoInsideInitialLoadedSuccessState;

            return Scaffold(
              body: Center(
                child: Text(
                  'No Data Available!!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  // maxLines: 1,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,),
                ),
              ),
            );

            // return Scaffold(
            //     key: _drawerScaffoldKey,
            //     drawer: CustomDrawer(width: width,
            //       height: height,
            //       logOut: (){
            //         kidsFoodVideoInsideBloc.add(LogoutKFVEvent());
            //       },
            //       backButton: (){
            //         kidsFoodVideoInsideBloc.add(KidsFoodVideoInsideBackNavigateButtonEvent());
            //       },
            //       dashboardList:  successState.dashboardList!.map((e) =>
            //           ListTile(
            //             selectedTileColor: Colors.orangeAccent.shade100,
            //             selectedColor: Colors.orange,
            //             selected: e.isSelected!,
            //             title:  Text(e.name),
            //             onTap: () {
            //               // Navigator.pop(context);
            //               kidsFoodVideoInsideBloc.add(KFVChangingTheDrawerColorEvent(index: e.index,sectionID: e.index,
            //                   kidsFoodVideoInsideProducts: successState.kidsFoodVideoProducts,
            //                   dashboardList: successState.dashboardList));
            //             },
            //           ),).toList(),
            //     ),
            //     body: Stack(
            //   children: [
            //     // SizedBox(
            //     //   height: double.maxFinite,
            //     //   width: double.maxFinite,
            //     //   child:SvgPicture.asset(
            //     //     'assets/mushroom.svg',
            //     //     semanticsLabel: 'Acme Logo',
            //     //     fit: BoxFit.fill,
            //     //   )
            //     //       .animate(onPlay: (controller) => controller.repeat())
            //     //       .effect(
            //     //       duration:
            //     //       3000.ms) // this "pads out" the total duration
            //     //       .effect(delay: 750.ms, duration: 1500.ms)
            //     //       .shimmer(),
            //     // ),
            //     const Positioned(
            //       left: 20,
            //       right: 20,
            //       top: 10,
            //       bottom: 20,
            //       child: Card(
            //         elevation: 10,
            //         color: Colors.white70,
            //       ),
            //     ),
            //     Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             // implement GridView.builder
            //             child: HomePage(
            //               kidsFoodVideoInsideBloc: kidsFoodVideoInsideBloc,
            //               kidsFoodVideoInsideProducts: successState.kidsFoodVideoProducts,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Positioned(
            //       top: 20,
            //       left: 30,
            //       child: CircleButton(
            //           onTap: () {
            //             if(_drawerScaffoldKey.currentState!.isDrawerOpen){
            //               //if drawer is open, then close the drawer
            //               Navigator.pop(context);
            //             }else{
            //               _drawerScaffoldKey.currentState!.openDrawer();
            //               //if drawer is closed then open the drawer.
            //             }
            //
            //           }, iconData: Icons.menu),
            //     ),
            //     Positioned(
            //       top: 35,
            //       left: 100,
            //       child: Text(
            //         successState.title.toString(),
            //         style: GoogleFonts.abel(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.grey.shade500),
            //       ),
            //     ),
            //   ],
            // ));
          case KidsFoodVideoInsideInitialErrorState:
            final errorState = state as KidsFoodVideoInsideInitialErrorState;

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.kidsFoodVideoInsideProducts, this.kidsFoodVideoInsideBloc})
      : super(key: key);

  final List<KFVInsideModelList>? kidsFoodVideoInsideProducts;
  final KidsFoodVideoInsideBloc? kidsFoodVideoInsideBloc;

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
    if(widget.kidsFoodVideoInsideProducts!.isNotEmpty){
      widget.kidsFoodVideoInsideProducts![0].isSelected = true;
    }
    maxCount = widget.kidsFoodVideoInsideProducts!.length;
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
      List<KFVInsideModelList>? kidsFoodVideoInsideProducts,
      double height , double width
  ) {
    return _wrapScrollTag(
      index: i,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
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
                  widget.kidsFoodVideoInsideBloc!.add(KidsFoodVideoInsideNavigateButtonEvent(
                    videoID: widget.kidsFoodVideoInsideProducts![i].id,
                  ));
                }
              },
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color:
                            widget.kidsFoodVideoInsideProducts![i].isSelected == true
                        ? Colors.blue
                        : null,
                    child:  Center(child:  Padding(
                      padding:  const EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        imageUrl:
                        kidsFoodVideoInsideProducts![i].imageUrl,
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
              widget.kidsFoodVideoInsideProducts![i].title,
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
              '${widget.kidsFoodVideoInsideProducts![i].description}',
              style: GoogleFonts.abel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: RatingBar.builder(
              initialRating: widget.kidsFoodVideoInsideProducts![i].rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
                // size: 10,
              ),
              itemSize: 25,
              onRatingUpdate: (rating) {
                widget.kidsFoodVideoInsideBloc!.add(KFVInsideUpdatingRatingStarEvent(
                  videoID: widget.kidsFoodVideoInsideProducts![i].id,
                  rating: rating,
                ));
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
            '${widget.kidsFoodVideoInsideProducts![i].views} watching',
            style: GoogleFonts.abel(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500),
          ),
          ),
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
          content: Text('${widget.kidsFoodVideoInsideProducts![counter].title}'),
        );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          switch (event.logicalKey.debugName) {
            case 'Media Play Pause':
            case 'Select':
              setState(() {
                widget.kidsFoodVideoInsideBloc!.add(KidsFoodVideoInsideNavigateButtonEvent(
                  videoID: widget.kidsFoodVideoInsideProducts![counter].id,
                ));
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
              'arrowRight listViewValue $listViewValue widget.ukgProducts!.length ${widget.kidsFoodVideoInsideProducts!.length}');

          widget.kidsFoodVideoInsideBloc!.add(KidsFoodVideoInsideChangingTheColorEvent(
              index: counter,
              isRightButton: true,
              kidsFoodVideoInsideProducts: widget.kidsFoodVideoInsideProducts!));

          _nextCounter();
        } else if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          debugPrint(
              'arrowLeft listViewValue $listViewValue widget.ukgProducts!.length ${widget.kidsFoodVideoInsideProducts!.length}');

          widget.kidsFoodVideoInsideBloc!.add(KidsFoodVideoInsideChangingTheColorEvent(
              index: counter,
              isRightButton: false,
              kidsFoodVideoInsideProducts: widget.kidsFoodVideoInsideProducts!));
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
          widget.kidsFoodVideoInsideProducts!.isEmpty ?       Text(
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
                          widget.kidsFoodVideoInsideProducts,
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
