package ru.elocont.location_beacons.location_beacons.models.request

data class Cell(
    val lac: Int,
    val cid: Int,
    var psc: Int? = null
)
