package ru.elocont.location_beacons.location_beacons.utils

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoWcdma
import android.telephony.TelephonyManager
import ru.elocont.location_beacons.location_beacons.models.request.Cell
import ru.elocont.location_beacons.location_beacons.models.request.CellInfo
import ru.elocont.location_beacons.location_beacons.models.request.RadioType

@SuppressLint("MissingPermission")
fun getCurrentCellInfo(context: Context, apiKey: String): List<CellInfo> {
    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    val accCellInfo = telephonyManager.allCellInfo

    return accCellInfo.mapNotNull { info ->
        when (info) {
            is CellInfoGsm -> getCellInfo(info, apiKey)
            is CellInfoWcdma -> getCellInfo(info, apiKey)
            is CellInfoLte -> getCellInfo(info, apiKey)
            else -> null
        }
    }
}

fun getCellInfo(info: CellInfoGsm, apiKey: String): CellInfo {
    val cellInfo: CellInfo

    info.cellIdentity.let {
        val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
        } else {
            Pair(it.mcc, it.mnc)
        }
        cellInfo = CellInfo(
            token = apiKey,
            radio = RadioType.GSM,
            mcc = mcc,
            mnc = mnc,
            cells = listOf(Cell(lac = it.lac, cid = it.cid))
        )
    }

    return cellInfo
}

fun getCellInfo(info: CellInfoWcdma, apiKey: String): CellInfo {
    val cellInfo: CellInfo

    info.cellIdentity.let {
        val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
        } else {
            Pair(it.mcc, it.mnc)
        }
        cellInfo = CellInfo(
            token = apiKey,
            radio = RadioType.UMTS,
            mcc = mcc,
            mnc = mnc,
            cells = listOf(Cell(lac = it.lac, cid = it.cid, it.psc))
        )
    }

    return cellInfo
}

fun getCellInfo(info: CellInfoLte, apiKey: String): CellInfo {
    val cellInfo: CellInfo

    info.cellIdentity.let {
        val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
        } else {
            Pair(it.mcc, it.mnc)
        }
        cellInfo = CellInfo(
            token = apiKey,
            radio = RadioType.LTE,
            mcc = mcc,
            mnc = mnc,
            cells = listOf(Cell(lac = it.tac, cid = it.ci, it.pci))
        )
    }

    return cellInfo
}