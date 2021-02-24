package com.netease.yunxin.education.ui

import com.netease.yunxin.education.base.Event

sealed class NavigationModel(val backStackTag: String? = null) {

    data class OpenWebPage(val url: String) : NavigationModel("web-page")

}

class NavigationEvent(navigationModel: NavigationModel): Event<NavigationModel>(navigationModel)