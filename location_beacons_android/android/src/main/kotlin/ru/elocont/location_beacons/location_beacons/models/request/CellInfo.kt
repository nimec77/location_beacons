package ru.elocont.location_beacons.location_beacons.model.request

data class CellInfo(
    val token: String,
    val radio: String? = null,
    var mcc: Int? = null,
    var mnc: Int? = null,
    var cells: List<Cell> = emptyList(),
    var address: Int = 1
)
