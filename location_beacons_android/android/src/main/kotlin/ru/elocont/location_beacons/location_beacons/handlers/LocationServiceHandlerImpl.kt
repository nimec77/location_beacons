package ru.elocont.location_beacons.location_beacons.handlers

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

import ru.elocont.location_beacons.location_beacons.interfaces.LocationBeaconsHandler
import ru.elocont.location_beacons.location_beacons.objects.LocationBeaconsObject
import ru.elocont.location_beacons.location_beacons.types.ServiceStatus

class LocationServiceHandlerImpl : LocationBeaconsHandler, EventChannel.StreamHandler {
    private var channel: EventChannel? = null
    private var context: Context? = null

    override fun startListening(context: Context, messenger: BinaryMessenger) {
        if (channel != null) {
            Log.w(TAG, "Setting a method call handler before the last was disposed.")
            stopListening()
        }

        channel = EventChannel(messenger, LocationBeaconsObject.EVENT_CHANNEL_NAME)
        channel?.setStreamHandler(this)
        this.context = context
    }

    override fun stopListening() {
        if (channel == null) {
            Log.w(TAG, "Tried to stop listening when no EventChannel had been initialized.")
            return
        }

        channel?.setStreamHandler(null)
        channel = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        events.success(ServiceStatus.enabled.ordinal)
    }

    override fun onCancel(arguments: Any?) {
        disposeListeners()
    }

    fun isLocationServiceEnabled(call: MethodCall, result: MethodChannel.Result) {
        result.success(true)
    }

    private fun disposeListeners() {

    }

    companion object {
        private val TAG = LocationServiceHandlerImpl::class.java.simpleName
    }
}