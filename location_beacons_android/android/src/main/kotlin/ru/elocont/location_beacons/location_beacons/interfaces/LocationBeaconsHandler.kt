package ru.elocont.location_beacons.location_beacons.interfaces

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger

interface LocationBeaconsHandler {
    fun startListening(context: Context, messenger: BinaryMessenger)

    fun stopListening()
}