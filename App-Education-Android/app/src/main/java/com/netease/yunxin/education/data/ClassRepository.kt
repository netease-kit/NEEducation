package com.netease.yunxin.education.data

import android.content.Context
import javax.inject.Inject
import javax.inject.Scope
import javax.inject.Singleton

@Singleton
class ClassRepository @Inject constructor(private val apiService: SDKApiService) {

    suspend fun joinClass(context: Context, classId: String, nickname: String): Result<Nothing> =
            apiService.joinClass(context, classId, nickname)
}