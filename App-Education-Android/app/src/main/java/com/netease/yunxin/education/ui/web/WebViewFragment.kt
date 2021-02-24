package com.netease.yunxin.education.ui.web

import android.os.Bundle
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.fragment.app.Fragment
import com.netease.yunxin.education.R

private const val ARG_URL = "url"

/**
 * A simple [Fragment] subclass.
 * Use the [WebViewFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class WebViewFragment : Fragment(R.layout.fragment_web_view) {
    private lateinit var url: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            url = it.getString(ARG_URL)!!
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.findViewById<WebView>(R.id.web_view).apply {
            loadUrl(this@WebViewFragment.url)
            settings.apply {
                useWideViewPort = true
                loadWithOverviewMode = true
                builtInZoomControls = true
            }
        }
    }

    companion object {

        fun newInstance(url: String) =
                WebViewFragment().apply {
                    arguments = Bundle().apply {
                        putString(ARG_URL, url)
                    }
                }
    }
}