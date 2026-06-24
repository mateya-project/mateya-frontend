package com.zless.mateya

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
      "com.zless.mateya/external_url",
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

      val targetUri = Uri.parse(rawUrl)
      if (targetUri.scheme != "http" && targetUri.scheme != "https") {
        result.success(false)
        return@setMethodCallHandler
      }
      val browserCandidates = packageManager.queryIntentActivities(
        Intent(Intent.ACTION_VIEW, Uri.parse("https://www.google.com")).apply {
          addCategory(Intent.CATEGORY_BROWSABLE)
        },
        0,
      ).map { resolveInfo ->
        Intent(Intent.ACTION_VIEW, targetUri).apply {
          addCategory(Intent.CATEGORY_BROWSABLE)
          `package` = resolveInfo.activityInfo.packageName
        }
      }

      val intent =
        when {
          browserCandidates.isEmpty() -> Intent(Intent.ACTION_VIEW, targetUri).apply {
            addCategory(Intent.CATEGORY_BROWSABLE)
          }
          browserCandidates.size == 1 -> browserCandidates.first()
          else -> Intent.createChooser(
            browserCandidates.first(),
            getString(R.string.external_browser_chooser_title),
          ).apply {
            putExtra(
              Intent.EXTRA_INITIAL_INTENTS,
              browserCandidates.drop(1).toTypedArray(),
            )
          }
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
