package ru.elocont.location_beacons.location_beacons.models.request

data class CellInfo(
    val token: String,
    val radio: String,
    var mcc: Int? = null,
    var mnc: Int? = null,
    var cells: List<Cell> = emptyList(),
    var address: Int = 1
)
