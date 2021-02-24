package com.netease.yunxin.education.ui.join

/**
 * Data validation state of the login form.
 */
data class ClassFormState(val classIdError: Int? = null,
                          val nicknameError: Int? = null,
                          val isDataValid: Boolean = false)