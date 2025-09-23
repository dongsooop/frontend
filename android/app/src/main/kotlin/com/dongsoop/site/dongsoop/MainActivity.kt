package com.dongsoop.site.dongsoop

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "app/push" // 상수는 const/대문자 OK
    }

    private var activeChatRoomId: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setActiveChat" -> {
                        val rid = (call.argument<String>("roomId") ?: "")
                            .trim()
                            .lowercase()
                        activeChatRoomId = if (rid.isNotEmpty()) rid else null
                        result.success(null)
                    }
                    "clearActiveChat" -> {
                        activeChatRoomId = null
                        result.success(null)
                    }
                    "setBadge" -> {
                        // Android는 전역 배지 표준 미지원 (스텁)
                        result.success(null)
                    }
                    "clearBadge" -> {
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        Log.d("MainActivity", "MethodChannel($CHANNEL) registered, activeChat=$activeChatRoomId")
    }
}
