package ru.elocont.location_beacons.location_beacons

import io.flutter.embedding.engine.plugins.FlutterPlugin
import ru.elocont.location_beacons.location_beacons.handlers.LocationHandler
import ru.elocont.location_beacons.location_beacons.handlers.LocationServiceHandlerImpl
import ru.elocont.location_beacons.location_beacons.handlers.MethodCallHandlerImpl
import ru.elocont.location_beacons.location_beacons.providers.LocationProvider
import ru.elocont.location_beacons.location_beacons.repositories.LocationRepository
import ru.elocont.location_beacons.location_beacons.services.buildUnwiredLabsService

/** LocationBeaconsPlugin */
class LocationBeaconsPlugin : FlutterPlugin {
    private lateinit var methodCallHandler: MethodCallHandlerImpl
    private lateinit var locationHandler: LocationHandler
    private lateinit var locationServiceHandler: LocationServiceHandlerImpl

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val locationRepository = LocationRepository(LocationProvider(buildUnwiredLabsService()))
        locationHandler = LocationHandler(locationRepository)
        locationServiceHandler = LocationServiceHandlerImpl()
        methodCallHandler = MethodCallHandlerImpl(
            locationHandler = locationHandler,
            locationServiceHandler = locationServiceHandler
        )
        locationHandler.startListening(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        locationServiceHandler.startListening(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        methodCallHandler.startListening(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        locationHandler.stopListening()
        methodCallHandler.stopListening()
        locationServiceHandler.stopListening()
    }
}
