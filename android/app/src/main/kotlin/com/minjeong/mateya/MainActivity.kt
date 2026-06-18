package com.minjeong.mateya

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(
      flutterEngine.dartExecutor.binaryMessenger,
      "com.minjeong.mateya/external_url",
    ).setMethodCallHandler { call, result ->
      if (call.method != "openUrl") {
        result.notImplemented()
        return@setMethodCallHandler
      }

      val rawUrl = call.arguments as? String
      if (rawUrl.isNullOrBlank()) {
        result.success(false)
        return@setMethodCallHandler
      }

      val intent = Intent(Intent.ACTION_VIEW, Uri.parse(rawUrl)).apply {
        addCategory(Intent.CATEGORY_BROWSABLE)
      }

      if (intent.resolveActivity(packageManager) == null) {
        result.success(false)
        return@setMethodCallHandler
      }

      startActivity(intent)
      result.success(true)
    }
  }
}
