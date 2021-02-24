package com.netease.yunxin.education.ui.main

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.netease.yunxin.education.data.AccountRepository
import com.netease.yunxin.education.ui.NavigationEvent
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
        private val accountRepository: AccountRepository
) : ViewModel() {

    private val _navigationEvent = MutableLiveData<NavigationEvent>()
    val navigationEvent = _navigationEvent

    fun navigateTo(event: NavigationEvent) {
        _navigationEvent.value = event
    }

    fun requestLogin() {
        viewModelScope.launch {
            val result = accountRepository.login()
            Log.i("MainViewModel", "login=$result")
        }
    }

}