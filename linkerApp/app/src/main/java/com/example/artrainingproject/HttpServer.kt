package com.example.artrainingproject

import android.content.Context
import android.content.res.AssetManager
import fi.iki.elonen.NanoHTTPD
import java.io.IOException

class HttpServer(context: Context) : NanoHTTPD(8080) {
    private val assetManager: AssetManager = context.assets

    override fun serve(session: IHTTPSession): Response {
        var uri = session.uri
        if (uri == "/") uri = "/index.html"

        return try {
            val inputStream = assetManager.open("www$uri")
            newChunkedResponse(Response.Status.OK, getMimeType(uri), inputStream)
        } catch (e: IOException) {
            newFixedLengthResponse(
                Response.Status.NOT_FOUND,
                MIME_PLAINTEXT,
                "Error 404: Not Found"
            )
        }
    }

    private fun getMimeType(uri: String): String {
        val mimeTypes = mapOf(
            "html" to "text/html",
            "js" to "application/javascript",
            "wasm" to "application/wasm",
            "pck" to "application/octet-stream",
            "png" to "image/png",
            "json" to "application/json",
            "css" to "text/css"
        )
        val dot = uri.lastIndexOf('.')
        return if (dot > 0) {
            mimeTypes[uri.substring(dot + 1).lowercase()] ?: "application/octet-stream"
        } else "application/octet-stream"
    }
}