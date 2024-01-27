import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_player.dart';

Align muteButtonConfig() {
  return Align(
    alignment: Alignment.bottomRight,
    child: InkWell(
      onTap: () {
        isBackgroundMuted.value = !isBackgroundMuted.value;

        if(player.state == PlayerState.stopped){
          isPlayerNeededToPlay = true;
          musicStart();
        }
        else
        {
          player.stop();
        }
      },
      child: Container(
        width: 30,
        height: 30,
        // color: Colors.red,
        margin: EdgeInsets.only(right: 10),
        child: Obx(() {
          return Icon(
            isBackgroundMuted.value == false ?
            Icons.volume_up : Icons.volume_off,
            color: Colors.black, size: 25,);
        }),
      ),
    ),
  );
}