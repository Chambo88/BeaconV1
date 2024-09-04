package co.nz.beacon.beacon

import android.app.Application
import io.flutter.app.FlutterApplication

class Application : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        // No need for manual background message handling here anymore
    }
}