package com.netease.yunxin.education.ui.join

import android.content.Context
import androidx.lifecycle.*
import com.netease.yunxin.education.R
import com.netease.yunxin.education.base.SingleLiveEvent
import com.netease.yunxin.education.data.AccountRepository
import com.netease.yunxin.education.data.ClassRepository
import com.netease.yunxin.education.data.Result
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeout
import javax.inject.Inject

@HiltViewModel
class JoinClassViewModel @Inject constructor(
    private val classRepository: ClassRepository,
    private val accountRepository: AccountRepository
) : ViewModel() {

    val nicknameLiveData = accountRepository.nicknameFlow
        .catch { emit("") }
        .asLiveData()

    private val _classForm = MutableLiveData<ClassFormState>()
    val classFormState: LiveData<ClassFormState> = _classForm

    private val _joinClassResult = SingleLiveEvent<Result<Nothing>>()
    val joinClassLiveData: LiveData<Result<Nothing>> = _joinClassResult

    private var joinClassJob: Job? = null

    fun joinClass(context: Context, classId: String, nickname: String) {
        if (joinClassJob == null) {
            _joinClassResult.value = Result.Loading()
            joinClassJob = viewModelScope.launch {
                try {
                    withTimeout(timeMillis = 60_000) {
                        val result = classRepository.joinClass(context, classId, nickname)
                        if (result is Result.Success) {
                            GlobalScope.launch {
                                accountRepository.saveNickname(nickname)
                            }
                        }
                        _joinClassResult.value = result
                    }
                } catch (e: Exception) {
                    _joinClassResult.value = Result.Error(msg = "${e.message}")
                } finally {
                    joinClassJob = null
                }
            }
        }
    }


    fun classDataChanged(classId: String, nickname: String) {
        if (!isClassIdValid(classId)) {
            _classForm.value = ClassFormState(nicknameError = R.string.invalid_classid)
        } else if (!isUserNameValid(nickname)) {
            _classForm.value = ClassFormState(classIdError = R.string.invalid_nickname)
        } else {
            _classForm.value = ClassFormState(isDataValid = true)
        }
    }

    // A placeholder username validation check
    private fun isUserNameValid(username: String) = username.isNotBlank()

    // A placeholder password validation check
    private fun isClassIdValid(classId: String) = classId.isNotEmpty()
}