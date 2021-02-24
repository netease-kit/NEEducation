package com.netease.yunxin.education.di

import android.content.Context
import androidx.datastore.preferences.createDataStore
import com.netease.yunxin.education.PREFERENCE_DATA_STORE_NAME
import com.netease.yunxin.education.data.AccountService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.*
import javax.inject.Singleton


@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    fun providePreferencesDataStore(@ApplicationContext context: Context) =
            context.createDataStore(PREFERENCE_DATA_STORE_NAME)

    @Singleton
    @Provides
    fun provideOkHttpClient(): OkHttpClient =
            OkHttpClient.Builder()
                    .addInterceptor { chain ->
                        chain.proceed(chain.request().newBuilder()
                                .addHeader("clientType", "3")
                                .addHeader("meetingSdkVersion", "1.0.0")
                                .addHeader("deviceId", UUID.randomUUID().toString())
                                .addHeader("appKey", SdkModule.APP_KEY)
                                .build()
                        )
                    }.addInterceptor(HttpLoggingInterceptor().apply {
                        level = HttpLoggingInterceptor.Level.BODY
                    })
                    .build()

    @Singleton
    @Provides
    fun provideAccountRetrofitService(okHttpClient: OkHttpClient): AccountService =
            Retrofit.Builder()
                    .baseUrl("https://meeting-api-test.netease.im/")
                    .client(okHttpClient)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build()
                    .create(AccountService::class.java)


}