package com.netease.yunxin.education.data

import android.content.Context
import com.netease.meetinglib.sdk.*
import com.netease.meetinglib.sdk.menu.NEMenuIDs
import com.netease.meetinglib.sdk.menu.NEMenuItemListBuilder
import com.netease.meetinglib.sdk.menu.NEMenuItems
import com.netease.meetinglib.sdk.menu.NESingleStateMenuItem
import com.netease.yunxin.education.R
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.resume

@Singleton
class SDKApiService @Inject constructor(
        @ApplicationContext private val context: Context,
        private val config: NEMeetingSDKConfig
) {

    private val sdk = NEMeetingSDK.getInstance()

    private val options = NEJoinMeetingOptions().apply {
        noVideo = false
        noAudio = false

        fullToolbarMenuItems = NEMenuItemListBuilder.toolbarMenuBuilder()
                .replaceMenuById(
                        NEMenuIDs.MANAGE_PARTICIPANTS_MENU_ID,
                        NEMenuItems.managerParticipantsMenu().apply {
                            singleStateItem.text = context.getString(R.string.participant_menu_text)
                        })
                .replaceMenuById(
                        NEMenuIDs.PARTICIPANTS_MENU_ID,
                        NEMenuItems.participantsMenu().apply {
                            singleStateItem.text = context.getString(R.string.participant_menu_text)
                        })
                .build()
    }

    private lateinit var initializeJob: Job

    fun ensureInitialized(scope: CoroutineScope) {
        initializeJob = scope.launch {
            suspendCancellableCoroutine<Boolean> { cont ->
                sdk.initialize(context, config) { resultCode, _, _ ->
                    cont.resume(resultCode == NEMeetingError.ERROR_CODE_SUCCESS)
                }
            }
        }
    }

    private suspend fun awaitInitialized(): Boolean {
        initializeJob.join()
        return NEMeetingSDK.getInstance().isInitialized
    }

    suspend fun login(accountId: String?, accountToken: String?): Boolean {
        awaitInitialized()
        return suspendCancellableCoroutine { cont ->
            sdk.login(accountId, accountToken) { code, msg, detail ->
                cont.resume(code == NEMeetingError.ERROR_CODE_SUCCESS)
            }
        }
    }

    suspend fun joinClass(context: Context, classId: String, nickname: String): Result<Nothing> {
        val params = NEJoinMeetingParams().apply {
            meetingId = classId
            displayName = nickname
        }
        awaitInitialized()
        return suspendCancellableCoroutine { cont ->
            sdk.meetingService.joinMeeting(context, params, options) { resultCode, resultMsg, _ ->
                cont.resume(
                        if (resultCode == NEMeetingError.ERROR_CODE_SUCCESS) Result.Success()
                        else Result.Error(resultCode, resultMsg)
                )
            }
        }
    }
}