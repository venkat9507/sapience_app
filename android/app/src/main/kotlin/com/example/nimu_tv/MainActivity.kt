package com.sapience.students

//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity() {
//}


import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "android.tv"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(!isLeanbackLauncherDevice()) {
                result.success(false)
            } else {
                result.success(true)
            }
        }
    }

    fun isLeanbackLauncherDevice(): Boolean {
        val pm = this.getPackageManager()
        if (pm.hasSystemFeature("android.software.leanback")) {
            return true
        } else {
            return false
        }
    }

}
