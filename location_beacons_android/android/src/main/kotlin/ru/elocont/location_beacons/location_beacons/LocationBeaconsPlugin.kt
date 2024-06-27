package ru.elocont.location_beacons.location_beacons

import io.flutter.embedding.engine.plugins.FlutterPlugin
import ru.elocont.location_beacons.location_beacons.handlers.MethodCallHandlerImpl

/** LocationBeaconsPlugin */
class LocationBeaconsPlugin: FlutterPlugin {
  private lateinit var methodCallHandler: MethodCallHandlerImpl

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler = MethodCallHandlerImpl()
    methodCallHandler.startListening(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler.stopListening()
  }
}
