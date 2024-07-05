package ru.elocont.location_beacons.location_beacons.models.request

import com.squareup.moshi.Json
import ru.elocont.location_beacons.location_beacons.BuildConfig

data class CellInfo(
    @Json(name = "token")
    val token: String = BuildConfig.OPENCELLID_API_KEY,
    @Json(name = "radio")
    val radio: String,
    @Json(name = "mcc")
    val mcc: Int,
    @Json(name = "mnc")
    val mnc: Int,
    @Json(name = "cells")
    val cells: List<Cell> = emptyList(),
    @Json(name = "address")
    val address: Int = 1
)
