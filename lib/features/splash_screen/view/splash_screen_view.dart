import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nimu_tv/features/dashboard_screen/view/dashboard_screen.dart';
import 'package:nimu_tv/features/login_screen/view/login_screen_view.dart';
import 'package:nimu_tv/features/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final SplashScreenBloc splashScreenBloc = SplashScreenBloc();

  @override
  void initState() {
    // TODO: implement initState
    splashScreenBloc.add(SplashScreenInitialEvent());

    super.initState();
  }

  // @override
  // void dispose() {
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      bloc: splashScreenBloc,
      listenWhen: (previous, current) => current is SplashScreenActionState,
      buildWhen: (previous, current) => current is! SplashScreenActionState,
      listener: (context, state) {
        if (state is SplashScreenLoadedState) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('Splash Screen Loaded Success State')));

         if(state.isLogin == true){
           Navigator.pushAndRemoveUntil(context,
               PageTransition(
                   type: PageTransitionType.scale,
                   alignment: Alignment.center,
                   duration: const Duration(milliseconds: 100),
                   child: const LoginScreenView()),(Route<dynamic> route) => false);
         }
         else
           {
             Navigator.pushAndRemoveUntil(context,
                 PageTransition(
                     type: PageTransitionType.scale,
                     alignment: Alignment.center,
                     duration: const Duration(milliseconds: 100),
                     child: const DashboardScreenView()),(Route<dynamic> route) => false);
           }
        }
      },
      builder: (context, state) {

        switch (state.runtimeType) {
          case SplashScreenMainState:
            return Scaffold(
                body: Stack(
              children: [
                SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Image.asset(
                      'assets/Splash_Screen.jpg',
                      // 'assets/Splash.jpg',
                      fit: BoxFit.fill,
                    )
                        // .animate(onPlay: (controller) => controller.repeat())
                        // .effect(duration: 3000.ms) // this "pads out" the total duration
                        // .effect(delay: 750.ms, duration: 1500.ms).shimmer(),
                ),
                // Positioned(
                //   top: 200,
                //   left: 100,
                //   child: SizedBox(
                //     // color: Colors.red,
                //     height: height * 0.15,
                //     width: width * 0.32,
                //     child: Image.asset(
                //       'assets/logo.png',
                //       fit: BoxFit.fill,
                //     )
                //         // .animate()
                //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                //         // .effect(delay: 750.ms, duration: 1500.ms).slideX()
                //         // .animate(onPlay: (controller) => controller.repeat())
                //         // .effect( duration: 1500.ms).shimmer()
                //     ,
                //   ),
                // ),
                // Positioned(
                //   top: 80,
                //   right: 180,
                //   child: SizedBox(
                //     height: height * 0.8,
                //     width: width * 0.2,
                //       child: Image.asset(
                //         'assets/loading_baloon.png',
                //         fit: BoxFit.fill,
                //       )
                //           // .animate(onPlay: (controller) => controller.repeat())
                //           // .effect(duration: 3000.ms) // this "pads out" the total duration
                //           // .effect(delay: 750.ms, duration: 1500.ms).scale().shake().shimmer(),
                //   ),
                // ),
                // Positioned(
                //   top: 150,
                //   right: 350,
                //   child: SizedBox(
                //       height: height * 0.2,
                //       width: width * 0.2,
                //       child: Image.asset(
                //         'assets/cloud_1.png',
                //         fit: BoxFit.fill,
                //       )
                //           // .animate(onPlay: (controller) => controller.repeat())
                //           // .effect(duration: 3000.ms) // this "pads out" the total duration
                //           // .effect(delay: 750.ms, duration: 1500.ms).slideY().shake().shimmer(),
                //   ),
                // ),
                // Positioned(
                //   bottom: 200,
                //   right: 40,
                //   child: SizedBox(
                //     height: height * 0.2,
                //     width: width * 0.2,
                //       child: Image.asset(
                //         'assets/cloud_2.png',
                //         fit: BoxFit.fill,
                //       )
                //           // .animate(onPlay: (controller) => controller.repeat())
                //           // .effect(duration: 3000.ms) // this "pads out" the total duration
                //           // .effect(delay: 750.ms, duration: 1500.ms).slideX().shake().shimmer(),
                //   ),
                // ),
              ],
            ));
          // case LoginLoadedSuccessState:
          //   return Scaffold(
          //     appBar: AppBar(
          //       backgroundColor: Colors.orange,
          //       title: const Center(
          //           child: Text(
          //             'Login',
          //             style: TextStyle(color: Colors.white),
          //           )),
          //     ),
          //   );
          // case LoginErrorState:
          //   return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
