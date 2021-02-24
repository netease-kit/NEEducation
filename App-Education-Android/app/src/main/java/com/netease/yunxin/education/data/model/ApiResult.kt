package com.netease.yunxin.education.data.model

import com.google.gson.annotations.SerializedName

data class ApiResult<T>(
        val code: Int,
        @SerializedName("ret") val data: T?
) {
    val isSuccess
        get() = code == 200
}
