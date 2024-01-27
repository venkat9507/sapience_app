

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData? iconData;
  final bool? isBackButton;

  const CircleButton({Key? key, this.onTap, this.iconData,this.isBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return  ClipOval(
      child: Material(
        elevation: 10,
        color: Colors.white, // Button color
        child: InkWell(
          splashColor: Colors.red, // Splash color
          onTap:onTap,
          child: SizedBox(width: 35, height: 35, child: SvgPicture.asset(
           isBackButton == null ? 'assets/menu.svg':  'assets/back_button.svg',
            semanticsLabel: 'Back Button',
            // width: 10,height: 5,
            fit: BoxFit.scaleDown,
          ),),
        ),
      ),
    );
  }
}