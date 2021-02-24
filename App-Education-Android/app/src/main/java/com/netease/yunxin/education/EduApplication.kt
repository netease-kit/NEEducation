package com.netease.yunxin.education

import android.app.Application
import com.netease.yunxin.education.data.SDKApiService
import dagger.hilt.android.HiltAndroidApp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import javax.inject.Inject

@HiltAndroidApp
class EduApplication : Application() {

    @Inject lateinit var sdkApiService: SDKApiService

    override fun onCreate() {
        super.onCreate()
        sdkApiService.ensureInitialized(CoroutineScope(Dispatchers.Main.immediate))
    }
}
