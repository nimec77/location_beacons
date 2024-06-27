package ru.elocont.location_beacons.location_beacons.utils

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.telephony.CellInfoGsm
import android.telephony.TelephonyManager
import ru.elocont.location_beacons.location_beacons.models.request.CellInfo
import ru.elocont.location_beacons.location_beacons.models.request.RadioType

@SuppressLint("MissingPermission")
fun getCurrentCellInfo(context: Context, apiKey: String): List<CellInfo> {
    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    val accCellInfo = telephonyManager.allCellInfo

    return emptyList()
}

fun getCellInfo(info: CellInfoGsm, apiKey: String): CellInfo {
    val cellInfo = CellInfo(token = apiKey, radio = RadioType.GSM)

    info.cellIdentity.let {
        val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
        } else {
            Pair(it.mcc, it.mnc)
        }
        cellInfo.mcc = mcc
        cellInfo.mnc = mnc
    }

    return cellInfo
}