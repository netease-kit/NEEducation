package com.netease.yunxin.education.data

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.netease.yunxin.education.data.model.AccountInfo
import com.netease.yunxin.education.data.model.ApiResult
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.withContext
import java.util.concurrent.atomic.AtomicBoolean
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AccountRepository @Inject constructor(
        private val dataStore: DataStore<Preferences>,
        private val accountService: AccountService,
        private val sdkApiService: SDKApiService
) {

    private val NICKNAME = stringPreferencesKey("nickname")

    private val _loggedStateFlow = MutableStateFlow(false)
    val loggedStateFlow: StateFlow<Boolean> = _loggedStateFlow

    fun isLogged() = loggedStateFlow.value

    private val logging = AtomicBoolean(false)

    suspend fun login(): Boolean {
        if (isLogged()) return true
        if (logging.compareAndSet(false, true).not()) return false

        val apiResult: ApiResult<AccountInfo>?
        withContext(Dispatchers.IO) {
            apiResult = try {
                accountService.getAccountInfo()
            } catch (e: Throwable) {
                null
            }
        }
        _loggedStateFlow.value = apiResult != null && apiResult.isSuccess
                && sdkApiService.login(apiResult.data?.accountId, apiResult.data?.accountToken)
        logging.set(false)
        return isLogged()
    }

    val nicknameFlow: Flow<String> = dataStore.data
        .take(1)
        .map { preferences -> preferences[NICKNAME] ?: "" }
        .catch { emit("") }

    suspend fun saveNickname(nickname: String) {
        dataStore.edit { settings ->
            settings[NICKNAME] = nickname
        }
    }
}