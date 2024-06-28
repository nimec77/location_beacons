package ru.elocont.location_beacons.location_beacons

import io.flutter.embedding.engine.plugins.FlutterPlugin
import ru.elocont.location_beacons.location_beacons.handlers.LocationHandler
import ru.elocont.location_beacons.location_beacons.handlers.LocationServiceHandlerImpl
import ru.elocont.location_beacons.location_beacons.handlers.MethodCallHandlerImpl

/** LocationBeaconsPlugin */
class LocationBeaconsPlugin: FlutterPlugin {
  private lateinit var methodCallHandler: MethodCallHandlerImpl
  private lateinit var locationHandler: LocationHandler
  private lateinit var locationServiceHandler: LocationServiceHandlerImpl

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    locationHandler = LocationHandler()
    locationServiceHandler = LocationServiceHandlerImpl()
    methodCallHandler = MethodCallHandlerImpl(
      locationHandler = locationHandler,
      locationServiceHandler = locationServiceHandler
    )
    locationServiceHandler.startListening(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
    methodCallHandler.startListening(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler.stopListening()
    locationServiceHandler.stopListening()
  }
}
