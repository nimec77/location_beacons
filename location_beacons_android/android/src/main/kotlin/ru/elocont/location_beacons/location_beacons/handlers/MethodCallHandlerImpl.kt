package ru.elocont.location_beacons.location_beacons.handlers

import android.content.Context
import android.util.Log
import android.util.Printer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import ru.elocont.location_beacons.location_beacons.interfaces.LocationBeaconsHandler
import ru.elocont.location_beacons.location_beacons.objects.LocationBeaconsObject

class MethodCallHandlerImpl(
    private val locationHandler: LocationHandler,
    private val locationServiceHandler: LocationServiceHandlerImpl
) : MethodChannel.MethodCallHandler, LocationBeaconsHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getLastKnownPosition" -> {
                onGetLastKnownPosition(call, result)
            }
            "isLocationServiceEnabled" -> {
                onIsLocationServiceEnabled(call, result)
            }
            else -> {
                Log.e(TAG, "Unknown method call: " + call.method)
                result.notImplemented()
            }
        }
    }

    override fun startListening(context: Context, messenger: BinaryMessenger) {
        if (channel != null) {
            Log.w(TAG, "Setting a method call handler before the last was disposed.")
            stopListening()
        }

        channel = MethodChannel(messenger, LocationBeaconsObject.CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
        this.context = context
    }

    override fun stopListening() {
        if (channel == null) {
            Log.w(TAG, "Tried to stop listening when no MethodChannel had been initialized.")
            return
        }

        channel?.setMethodCallHandler(null)
        channel = null
    }

   private  fun onGetLastKnownPosition(call: MethodCall, result: MethodChannel.Result) {
        locationHandler.onGetLastKnownPosition(call, result)
    }

    private fun onIsLocationServiceEnabled(call: MethodCall, result: MethodChannel.Result) {
        locationServiceHandler.isLocationServiceEnabled(call, result)
    }

    companion object {
        private val TAG = MethodCallHandlerImpl::class.java.simpleName
    }

}