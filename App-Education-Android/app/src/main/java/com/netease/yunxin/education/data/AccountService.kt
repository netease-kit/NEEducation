package com.netease.yunxin.education.data

import com.netease.yunxin.education.data.model.AccountInfo
import com.netease.yunxin.education.data.model.ApiResult
import retrofit2.http.GET
import javax.inject.Singleton

interface AccountService {

    @GET("v1/sdk/account/anonymous")
    suspend fun getAccountInfo(): ApiResult<AccountInfo>

}