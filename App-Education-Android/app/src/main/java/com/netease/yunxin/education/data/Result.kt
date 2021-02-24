package com.netease.yunxin.education.data

/**
 * A generic class that holds a value with its loading status.
 * @param <T>
 */
sealed class Result<out T : Any> {

    data class Success<out T : Any>(val data: T? = null) : Result<T>()
    data class Loading(val msg: String? = null) : Result<Nothing>()
    data class Error(val code: Int? = null, val msg: String) : Result<Nothing>()

    override fun toString(): String {
        return when (this) {
            is Success<*> -> "Success[data=$data]"
            is Loading -> "Loading[msg=$msg]"
            is Error -> "Error[code=$code, msg=$msg]"
        }
    }
}