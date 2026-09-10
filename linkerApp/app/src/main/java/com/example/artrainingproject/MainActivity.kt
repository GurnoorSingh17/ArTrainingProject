package com.example.artrainingproject



import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import fi.iki.elonen.NanoHTTPD
import java.io.IOException

class MainActivity : AppCompatActivity() {
    private var server: HttpServer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 1. Start the local HTTP server
        try {
            server = HttpServer(this)
            server?.start(NanoHTTPD.SOCKET_READ_TIMEOUT, false)
        } catch (e: IOException) {
            e.printStackTrace()
        }

        // 2. Wait a moment so the server is fully bound to port 8080,
        //    then launch Chrome.
        Handler(Looper.getMainLooper()).postDelayed({
            val browserIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("http://localhost:8080/index.html")
            )
            startActivity(browserIntent)
        }, 500) // 500ms delay
    }

    override fun onDestroy() {
        super.onDestroy()
        // Do NOT stop the server here — Chrome may still be loading files.
        // It will be stopped when the process is killed by Android.
    }
}