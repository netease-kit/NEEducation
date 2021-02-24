package com.netease.yunxin.education.ui.main

import android.Manifest
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.netease.yunxin.education.R
import com.netease.yunxin.education.base.handleIt
import com.netease.yunxin.education.ui.NavigationModel
import com.netease.yunxin.education.ui.join.JoinClassFragment
import com.netease.yunxin.education.ui.web.WebViewFragment
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private val permissionRequestLauncher = registerForActivityResult(
            ActivityResultContracts.RequestMultiplePermissions()) { results ->
        results.values.forEach { allow ->
            if (allow.not()) {
                onPermissionDenied()
                return@registerForActivityResult
            }
        }
    }

    private val viewModel by viewModels<MainViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                    .replace(R.id.container, JoinClassFragment.newInstance())
                    .commitNow()
        }

        viewModel.navigationEvent.observe(this) { event ->
            event.handleIt { model ->
                when(model) {
                    is NavigationModel.OpenWebPage -> {
                        navigateToDestination(WebViewFragment.newInstance(model.url), model.backStackTag)
                    }
                }
            }
        }

        viewModel.requestLogin()

        permissionRequestLauncher.launch(
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_PHONE_STATE,
                        Manifest.permission.CAMERA,
                        Manifest.permission.RECORD_AUDIO)
        )
    }

    private fun navigateToDestination(destination: Fragment, backStackTag: String? = null) {
        supportFragmentManager.beginTransaction().run {
            replace(R.id.container, destination)
            if (backStackTag != null) addToBackStack(backStackTag)
            commit()
        }
    }

    private fun onPermissionDenied() {
        MaterialAlertDialogBuilder(this).apply {
            setTitle(R.string.alert)
            setMessage(R.string.some_permission_disallowed)
            setPositiveButton(R.string.i_know) { dialog, _ ->
                dialog.dismiss()
            }
        }.show()
    }
}