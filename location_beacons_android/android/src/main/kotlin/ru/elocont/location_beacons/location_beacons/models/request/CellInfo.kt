package ru.elocont.location_beacons.location_beacons.models.request

import ru.elocont.location_beacons.location_beacons.BuildConfig

data class CellInfo(
    val token: String = BuildConfig.OPENCELLID_API_KEY,
    val radio: String,
    val mcc: Int,
    val mnc: Int,
    val cells: List<Cell> = emptyList(),
    val address: Int = 1
)
