package ru.elocont.location_beacons.location_beacons.services

import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import ru.elocont.location_beacons.location_beacons.objects.LocationBeaconsObject

fun buildUnwiredLabsService() =
    Retrofit.Builder()
        .baseUrl(LocationBeaconsObject.BASE_URL)
        .addConverterFactory(
            MoshiConverterFactory.create(
                Moshi.Builder().add(KotlinJsonAdapterFactory()).build()
            )
        )
        .build()
        .create(UnwiredLabsService::class.java)