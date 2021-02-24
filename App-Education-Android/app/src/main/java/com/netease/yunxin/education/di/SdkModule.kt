package com.netease.yunxin.education.di

import android.content.Context
import com.netease.meetinglib.sdk.NEMeetingSDKConfig
import com.netease.meetinglib.sdk.config.NEForegroundServiceConfig
import com.netease.yunxin.education.R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
object SdkModule {

    const val APP_KEY = "Your_NEMeeting_APP_KEY"

    @Provides
    fun provideSdkConfig(@ApplicationContext context: Context) = NEMeetingSDKConfig().apply {
        appKey = APP_KEY
        appName = context.getString(R.string.app_name)
        foregroundServiceConfig = NEForegroundServiceConfig().apply {
            contentTitle = appName
        }
    }

}