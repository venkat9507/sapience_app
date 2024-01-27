import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/features/dashboard_screen/bloc/dashboard_screen_bloc.dart';
import 'package:nimu_tv/features/dttc_screen/bloc/dttc_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../config/circle_back_button.dart';
import '../../../config/custom_drawer.dart';
import '../../dashboard_screen/view/dashboard_screen.dart';
import '../../dttc_inside_screen/view/dttc_inside_screenview.dart';


class DttcScreenView extends StatefulWidget {
  final int? sectionID;
  const DttcScreenView({Key? key,this.sectionID}) : super(key: key);

  @override
  State<DttcScreenView> createState() => _DttcScreenViewState();
}

class _DttcScreenViewState extends State<DttcScreenView> {
  final DttcBloc dttcBloc = DttcBloc();
  final GlobalKey<ScaffoldState> _drawerScaffoldKey =  GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState

    dttcBloc.add(DTTCInitialEvent(sectionID: widget.sectionID));
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
    return BlocConsumer<DttcBloc, DttcState>(
      bloc: dttcBloc,
      listenWhen: (previous, current) => current is DttcActionState,
      buildWhen: (previous, current) => current is! DttcActionState,
      listener: (context, state) {
        if (state is DTTCActionButtonState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child:  DTTCInsideScreenView(term: state.term,
                    sectionID: state.sectionID,title: state.title,)),(Route<dynamic> route) => true);
          // Navigator.pop(context);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        } else if (state is DTTCBackActionButtonState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const DashboardScreenView()),(Route<dynamic> route) => false);
        }
        else if (state is DTTCDrawerActionButtonState) {

          switchingBetweenDifferentWidget(index: state.index,context: context,sectionID: state.sectionID);

        }
        // if (state is LoginButtonLoadedSuccessState) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(const SnackBar(content: Text('Logged in Success')));
        //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        // } else if (state is LoginButtonLoadingState) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Loading please wait ....')));
        // } else if (state is LoginButtonErrorState) {
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
          case  DTTCLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case  DTTCLoadedSuccessState:
            final successState = state as DTTCLoadedSuccessState;

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

            // return  Scaffold(
            //     key: _drawerScaffoldKey,
            //     drawer: CustomDrawer(width: width,
            //       height: height,
            //       logOut: (){
            //         dttcBloc.add(LogoutDTTCEvent());
            //       },
            //       backButton: (){
            //         dttcBloc.add(DTTCBackNavigateButtonEvent());
            //       },
            //       dashboardList:  successState.dashboardList!.map((e) =>
            //           ListTile(
            //             selectedTileColor: Colors.orangeAccent.shade100,
            //             selectedColor: Colors.orange,
            //             selected: e.isSelected!,
            //             title:  Text(e.name),
            //             onTap: () {
            //               // Navigator.pop(context);
            //               dttcBloc.add(DTTCChangingTheDrawerColorEvent(index: e.index,sectionID: e.index,
            //                   // lkgProducts: lkgDataItems,
            //                   dashboardList: successState.dashboardList));
            //             },
            //           ),).toList(),
            //     ),
            //   // appBar: AppBar(
            //   //   backgroundColor: Colors.orange,
            //   //   title: const Center(
            //   //       child: Text(
            //   //         'Login',
            //   //         style: TextStyle(color: Colors.white),
            //   //       )),
            //   // ),
            //     body: Stack(
            //       children: [
            //         SizedBox(
            //             height: double.maxFinite,
            //             width: double.maxFinite,
            //             child: Image.asset(
            //               'assets/dashboard_bc.png',
            //               fit: BoxFit.fill,
            //             )
            //                 .animate().effect(duration: 3000.ms) // this "pads out" the total duration
            //                 .effect( duration: 500.ms).scaleX()
            //                 .animate(onPlay: (controller) => controller.repeat())
            //                 .effect(duration: 3000.ms) // this "pads out" the total duration
            //                 .effect(delay: 750.ms, duration: 1500.ms).shimmer()
            //         ),
            //         Positioned(
            //           top: 20,
            //           left: 30,
            //           child: CircleButton(
            //               onTap: () {
            //                 if(_drawerScaffoldKey.currentState!.isDrawerOpen){
            //                   //if drawer is open, then close the drawer
            //                   Navigator.pop(context);
            //                 }else{
            //                   _drawerScaffoldKey.currentState!.openDrawer();
            //                   //if drawer is closed then open the drawer.
            //                 }
            //
            //               }, iconData: Icons.menu),
            //         ),
            //         Align(
            //           alignment: Alignment.center,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SizedBox(
            //                 height: 300,
            //                 // width: double.infinity,
            //                 child: ListView.separated(
            //                   separatorBuilder: (context,int index)=> SizedBox(height: 30,),
            //                     itemCount: successState.dttcList!.length,
            //                     itemBuilder: (context,int index){
            //
            //                       return DTTCWidget1(
            //                         isTopic2Needed: true,
            //                         height: height,
            //                         width: width,
            //                         title: successState.dttcList![index].name,
            //                         topic1:  Container(
            //                           margin: const EdgeInsets.all(1),
            //                           width: 120,
            //                           height: 44,
            //                           decoration:   BoxDecoration(
            //                             // shape: BoxShape.circle,
            //                             borderRadius: BorderRadius.circular(12),
            //                             gradient:  const RadialGradient(
            //                               radius: 2,
            //                               // focalRadius: 5,
            //                               colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //
            //                             ),
            //                           ),
            //                           child: ElevatedButton(
            //                             style: ElevatedButton.styleFrom(
            //                               backgroundColor: Colors.transparent,
            //                               shadowColor: Colors.transparent,
            //                               shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //                             ),
            //                             onPressed: () {
            //                               debugPrint('sectionID ${successState.dttcList![index].id} term ${successState.dttcList![index].terms[0].term} title ${successState.dttcList![index].name}');
            //                               dttcBloc.add(DTTCNavigateButtonEvent(sectionID: successState.dttcList![index].id,
            //                                 term: successState.dttcList![index].terms[0].term,
            //                                 title: successState.dttcList![index].name,
            //                               ));
            //                             },
            //                             child:  Text(
            //                               successState.dttcList![index].terms[0].term,
            //                               style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //                             ),
            //                           ),
            //                         ),
            //                         topic2:  Container(
            //                           margin: const EdgeInsets.all(1),
            //                           width: 120,
            //                           height: 44,
            //                           decoration:   BoxDecoration(
            //                             // shape: BoxShape.circle,
            //                             borderRadius: BorderRadius.circular(12),
            //                             gradient:  const RadialGradient(
            //                               radius: 2,
            //                               // focalRadius: 5,
            //                               colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //
            //                             ),
            //                           ),
            //                           child: ElevatedButton(
            //                             style: ElevatedButton.styleFrom(
            //                               backgroundColor: Colors.transparent,
            //                               shadowColor: Colors.transparent,
            //                               shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //                             ),
            //                             onPressed: () {
            //                               dttcBloc.add(DTTCNavigateButtonEvent(sectionID: successState.dttcList![index].id,
            //                                 term: successState.dttcList![index].terms[1].term,
            //                                 title: successState.dttcList![index].name,
            //                               ));
            //                             },
            //                             child:  Text(
            //                               successState.dttcList![index].terms[1].term,
            //                               style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //                             ),
            //                           ),
            //                         ),
            //                         topic3:  Container(
            //                           margin: const EdgeInsets.all(1),
            //                           width: 120,
            //                           height: 44,
            //                           decoration:   BoxDecoration(
            //                             // shape: BoxShape.circle,
            //                             borderRadius: BorderRadius.circular(12),
            //                             gradient:  const RadialGradient(
            //                               radius: 2,
            //                               // focalRadius: 5,
            //                               colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //
            //                             ),
            //                           ),
            //                           child: ElevatedButton(
            //                             style: ElevatedButton.styleFrom(
            //                               backgroundColor: Colors.transparent,
            //                               shadowColor: Colors.transparent,
            //                               shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //                             ),
            //                             onPressed: () {
            //                               dttcBloc.add(DTTCNavigateButtonEvent(sectionID: successState.dttcList![index].id,
            //                                 term: successState.dttcList![index].terms[2].term,
            //                                 title: successState.dttcList![index].name,
            //                               ));
            //                             },
            //                             child:  Text(
            //                               successState.dttcList![index].terms[2].term,
            //                               style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //                             ),
            //                           ),
            //                         ),
            //                       );
            //
            //                 }),
            //               ),
            //               SizedBox(height: 30,),
            //               // DTTCWidget1(
            //               //   isTopic2Needed: true,
            //               //   height: height,
            //               //   width: width,
            //               //   title: 'ukg',
            //               //   topic1:  Container(
            //               //     margin: const EdgeInsets.all(1),
            //               //     width: 120,
            //               //     height: 44,
            //               //     decoration:   BoxDecoration(
            //               //       // shape: BoxShape.circle,
            //               //       borderRadius: BorderRadius.circular(12),
            //               //       gradient:  const RadialGradient(
            //               //         radius: 2,
            //               //         // focalRadius: 5,
            //               //         colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //               //
            //               //       ),
            //               //     ),
            //               //     child: ElevatedButton(
            //               //       style: ElevatedButton.styleFrom(
            //               //         backgroundColor: Colors.transparent,
            //               //         shadowColor: Colors.transparent,
            //               //         shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //               //       ),
            //               //       onPressed: () {  },
            //               //       child:  Text(
            //               //         'TERM 1',
            //               //         style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //               //       ),
            //               //     ),
            //               //   ),
            //               //   topic2:  Container(
            //               //     margin: const EdgeInsets.all(1),
            //               //     width: 120,
            //               //     height: 44,
            //               //     decoration:   BoxDecoration(
            //               //       // shape: BoxShape.circle,
            //               //       borderRadius: BorderRadius.circular(12),
            //               //       gradient:  const RadialGradient(
            //               //         radius: 2,
            //               //         // focalRadius: 5,
            //               //         colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //               //
            //               //       ),
            //               //     ),
            //               //     child: ElevatedButton(
            //               //       style: ElevatedButton.styleFrom(
            //               //         backgroundColor: Colors.transparent,
            //               //         shadowColor: Colors.transparent,
            //               //         shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //               //       ),
            //               //       onPressed: () {  },
            //               //       child:  Text(
            //               //         'TERM 2',
            //               //         style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //               //       ),
            //               //     ),
            //               //   ),
            //               //   topic3:  Container(
            //               //     margin: const EdgeInsets.all(1),
            //               //     width: 120,
            //               //     height: 44,
            //               //     decoration:   BoxDecoration(
            //               //       // shape: BoxShape.circle,
            //               //       borderRadius: BorderRadius.circular(12),
            //               //       gradient:  const RadialGradient(
            //               //         radius: 2,
            //               //         // focalRadius: 5,
            //               //         colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //               //
            //               //       ),
            //               //     ),
            //               //     child: ElevatedButton(
            //               //       style: ElevatedButton.styleFrom(
            //               //         backgroundColor: Colors.transparent,
            //               //         shadowColor: Colors.transparent,
            //               //         shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //               //       ),
            //               //       onPressed: () {  },
            //               //       child:  Text(
            //               //         'TERM 3',
            //               //         style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //               //       ),
            //               //     ),
            //               //   ),
            //               // ),
            //              // SizedBox(
            //              //   height:  200,
            //              //   width: width * 0.5,
            //              //   child: ListView.builder(
            //              //     scrollDirection: Axis.horizontal,
            //              //     itemCount: 3,
            //              //       itemBuilder: (context,index){
            //              //     return
            //              //       Container(
            //              //         margin: const EdgeInsets.all(1),
            //              //         width: 120,
            //              //         height: 44,
            //              //         decoration:   BoxDecoration(
            //              //           // shape: BoxShape.circle,
            //              //           borderRadius: BorderRadius.circular(12),
            //              //           gradient:  const RadialGradient(
            //              //             radius: 2,
            //              //             // focalRadius: 5,
            //              //             colors: [Color(0xFFE77817), Color(0xFFF8B57B)],
            //              //
            //              //           ),
            //              //         ),
            //              //         child: ElevatedButton(
            //              //           style: ElevatedButton.styleFrom(
            //              //             backgroundColor: Colors.transparent,
            //              //             shadowColor: Colors.transparent,
            //              //             shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
            //              //           ),
            //              //           onPressed: () {  },
            //              //           child:  Text(
            //              //             'TERM 1',
            //              //             style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),
            //              //           ),
            //              //         ),
            //              //       );
            //              //   })
            //              // ),
            //
            //               // SizedBox(height: 20,),
            //
            //             ],
            //           ),
            //         ),
            //
            //       ],
            //     )
            // );
          case  DTTCErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class DTTCWidget1 extends StatelessWidget {
  const DTTCWidget1({
    Key? key,
    required this.height,
    required this.width, required this.title, required this.topic1,required  this.topic2, required this.isTopic2Needed, required this.topic3,
  }) : super(key: key);

  final double height;
  final double width;
  final String title;
  final Widget topic1;
  final Widget topic2;
  final Widget topic3;
  final bool isTopic2Needed;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title
          ,style: GoogleFonts.abel(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
        SizedBox(
          // color: Colors.green,
          height: height * 0.13,
          width: width * 0.7,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              topic1,
              topic2 ,
              topic3,
            ],
          ),
        ),
      ],
    );
  }
}
