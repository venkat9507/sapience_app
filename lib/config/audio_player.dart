import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

final player = AudioPlayer();

bool isPlayerNeededToPlay = true;
Rx<bool> isBackgroundMuted = false.obs;

void musicStart(){
  player.play(AssetSource('kids.mp3'),); // debugPrint('checking whether it is android tv ${CheckingTv.checkingTheTv()}');
}

void musicStop(){
  player.dispose();
}
