package sk.zdenoiva.fuelix

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingScan = false
    private var shortcutChannel: MethodChannel? = null
    private var pendingPick: MethodChannel.Result? = null

    companion object {
        const val ACTION_SCAN = "sk.zdenoiva.fuelix.action.SCAN"
        private const val REQUEST_CREATE_DOCUMENT = 4242
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        shortcutChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "sk.zdenoiva.fuelix/shortcut",
        )
        shortcutChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeInitialScan" -> {
                    result.success(pendingScan)
                    pendingScan = false
                }
                else -> result.notImplemented()
            }
        }

        val backupChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "sk.zdenoiva.fuelix/backup",
        )
        backupChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickTarget" -> startPickTarget(result)
                "writeTarget" -> {
                    val uri = call.argument<String>("uri")
                    val bytes = call.argument<ByteArray>("bytes")
                    if (uri == null || bytes == null) {
                        result.error("bad_args", "Missing uri or bytes", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val stream = contentResolver.openOutputStream(Uri.parse(uri), "wt")
                            ?: throw IllegalStateException("Cannot open stream")
                        stream.use { it.write(bytes) }
                        result.success(true)
                    } catch (error: Exception) {
                        result.error("write_failed", error.message, null)
                    }
                }
                "releaseTarget" -> {
                    val uri = call.argument<String>("uri")
                    if (uri != null) {
                        try {
                            contentResolver.releasePersistableUriPermission(
                                Uri.parse(uri),
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
                            )
                        } catch (_: Exception) {
                        }
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        pendingScan = intent?.action == ACTION_SCAN
    }

    private fun startPickTarget(result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "A destination picker is already open", null)
            return
        }
        pendingPick = result
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/octet-stream"
            putExtra(Intent.EXTRA_TITLE, "fuelix-backup.fuelix")
        }
        startActivityForResult(intent, REQUEST_CREATE_DOCUMENT)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_CREATE_DOCUMENT) return

        val result = pendingPick
        pendingPick = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result?.success(null)
            return
        }

        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
        } catch (_: Exception) {
            // The provider does not offer permanent access. The file is still
            // valid for this session, but the next backup will ask again.
        }

        var name = uri.lastPathSegment ?: "fuelix-backup.fuelix"
        try {
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (index >= 0 && cursor.moveToFirst()) {
                    name = cursor.getString(index) ?: name
                }
            }
        } catch (_: Exception) {
        }

        result?.success(mapOf("uri" to uri.toString(), "name" to name))
    }

    @Deprecated("Deprecated in Java")
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == ACTION_SCAN) {
            pendingScan = true
            shortcutChannel?.invokeMethod("openScanner", null)
        }
    }
}
