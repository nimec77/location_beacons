package ru.elocont.location_beacons.location_beacons

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import ru.elocont.location_beacons.location_beacons.interfaces.LocationBeaconsHandler
import ru.elocont.location_beacons.location_beacons.objects.LocationBeaconsObject

class MethodCallHandlerImpl : MethodChannel.MethodCallHandler, LocationBeaconsHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var apiKey: String? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "init") {
            setApiToken(call, result)
        } else {
            result.notImplemented()
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

    fun setApiToken(call: MethodCall, result: Result) {
        apiKey = call.argument("apiKey")
        result.success(null)
    }

    companion object {
        private val TAG = MethodCallHandlerImpl::class.java.simpleName
    }

}