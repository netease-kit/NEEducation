package com.netease.yunxin.education.ui.join

import android.os.Bundle
import android.text.Editable
import android.text.InputFilter
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.widget.*
import androidx.core.text.buildSpannedString
import androidx.core.text.inSpans
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import com.netease.yunxin.education.R
import com.netease.yunxin.education.URL_PRIVACY_POLICY
import com.netease.yunxin.education.URL_USER_AGREEMENT
import com.netease.yunxin.education.data.Result
import com.netease.yunxin.education.databinding.FragmentJoinClassBinding
import com.netease.yunxin.education.ui.NavigationEvent
import com.netease.yunxin.education.ui.NavigationModel
import com.netease.yunxin.education.ui.base.ViewBindingFragment
import com.netease.yunxin.education.ui.main.MainViewModel
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class JoinClassFragment() : ViewBindingFragment<FragmentJoinClassBinding>() {

    companion object {
        fun newInstance() = JoinClassFragment()
    }

    private val joinClassViewModel: JoinClassViewModel by viewModels()
    private val mainViewModel: MainViewModel by activityViewModels()

    override fun inflateBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToParent: Boolean
    ): FragmentJoinClassBinding =
        FragmentJoinClassBinding.inflate(layoutInflater, container, attachToParent)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewBinding.classId.filters = arrayOf(InputFilter.LengthFilter(12))
        viewBinding.nickname.filters = arrayOf(InputFilter.LengthFilter(20))

//        joinClassViewModel.nicknameLiveData.observe(viewLifecycleOwner) { nickname ->
//            if (TextUtils.isEmpty(nicknameEditText.text))
//                nicknameEditText.setText(nickname)
//        }

        joinClassViewModel.classFormState.observe(viewLifecycleOwner) { loginFormState ->
            viewBinding.joinClass.isEnabled = loginFormState != null && loginFormState.isDataValid
        }

        val afterTextChangedAction = { _: Editable? ->
            joinClassViewModel.classDataChanged(
                viewBinding.classId.text?.toString() ?: "",
                viewBinding.nickname.text?.toString() ?: ""
            )
        }
        viewBinding.classId.doAfterTextChanged(afterTextChangedAction)
        viewBinding.nickname.apply {
            doAfterTextChanged(afterTextChangedAction)
            setOnEditorActionListener { _, actionId, _ ->
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    joinClass()
                }
                false
            }
        }

        viewBinding.joinClass.setOnClickListener {
            joinClass()
        }

        joinClassViewModel.joinClassLiveData.observe(viewLifecycleOwner) { result ->
            viewBinding.loading.visibility =
                if (result is Result.Loading) View.VISIBLE else View.GONE
            if (result is Result.Error) {
                showJoinInFailed(result.msg)
            }
        }

        viewBinding.disclaimer.apply {
            movementMethod = LinkMovementMethod.getInstance()
            text = buildSpannedString {
                append(getString(R.string.disclaimer_prefix))
                inSpans(ForegroundColorSpan(resources.getColor(R.color.primary_blue)),
                    ActionSpan { openWebPage(URL_PRIVACY_POLICY) }) {
                    append(getString(R.string.privacy_policy))
                }
                append(getString(R.string.disclaimer_and))
                inSpans(ForegroundColorSpan(resources.getColor(R.color.primary_blue)),
                    ActionSpan { openWebPage(URL_USER_AGREEMENT) }) {
                    append(getString(R.string.user_agreement))
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (joinClassViewModel.joinClassLiveData.value is Result.Success) {
            viewBinding.classId.setText("")
            viewBinding.nickname.setText("")
            requireView().findFocus()?.clearFocus()
        }
    }

    private fun joinClass() {
        val classId = viewBinding.classId.text.toString()
        val nickname = viewBinding.nickname.text.toString()
        joinClassViewModel.joinClass(requireActivity(), classId, nickname)
    }

    private fun showJoinInFailed(errorString: String) {
        val appContext = context?.applicationContext ?: return
        Toast.makeText(appContext, errorString, Toast.LENGTH_LONG).run {
            setGravity(Gravity.CENTER, 0, 0)
            show()
        }
    }

    private fun openWebPage(url: String) {
        mainViewModel.navigateTo(NavigationEvent(NavigationModel.OpenWebPage(url)))
    }
}

class ActionSpan(private val action: () -> Unit) : ClickableSpan() {

    override fun updateDrawState(ds: TextPaint) {
        ds.isUnderlineText = false
    }

    override fun onClick(widget: View) = action()
}