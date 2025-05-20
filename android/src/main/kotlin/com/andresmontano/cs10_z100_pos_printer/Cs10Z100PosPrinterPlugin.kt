package com.andresmontano.cs10_z100_pos_printer

import android.os.Build
import android.util.Log
import vpos.apipackage.PosApiHelper
import vpos.apipackage.PrintInitException
import com.google.zxing.BarcodeFormat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Cs10Z100PosPrinterPlugin */
class Cs10Z100PosPrinterPlugin: FlutterPlugin, MethodCallHandler {
  
  companion object {
    private const val TAG = "Cs10Z100PosPrinterPlugin" 
    private const val NOT_SUPPORTED_ERROR_CODE = 9999
    private const val NOT_INIT_ERROR_CODE = 9998
    private const val MIN_ANDROID_SDK_VERSION = 22 // Corresponds to Android 5.1 Lollipop MR1
    private const val MAX_ANDROID_SDK_VERSION = 25 // Corresponds to Android 7.0 Nougat
  }

  private lateinit var channel : MethodChannel
  private var printer : PosApiHelper? = null


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cs10_z100_pos_printer")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "printInit" -> {
          initPrinter(result)
        }
        "printString" -> {
          printString(call,result)
        }
        "printStart" -> {
          printStart(result)
        }
        "printClose" -> {
          printClose(result)
        }
        "printCheckStatus" -> {
          printCheckStatus(result)
        }
        "printQrCode" -> {
          printQrCode(call,result)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  private fun checkDeviceSupport(): Boolean {
    try {
      val model = Build.MODEL.uppercase() 
      val manufacturer = Build.MANUFACTURER.uppercase()
      val sdkInt = Build.VERSION.SDK_INT 
      val modelPattern = "CS10|Z100".toRegex()
      if (!modelPattern.containsMatchIn(model)) {
          Log.d(TAG, "Model: $model. Does not match pattern 'CS10|Z100'.")
          return false
      }
      if (sdkInt < MIN_ANDROID_SDK_VERSION || sdkInt > MAX_ANDROID_SDK_VERSION) {
        Log.d(TAG, "Android SDK: $sdkInt. Not within supported range ($MIN_ANDROID_SDK_VERSION - $MAX_ANDROID_SDK_VERSION).")
        return false
      }
      return true
    } catch (e: Exception) {
      Log.e(TAG, "Printer check support exception: ${e.message}")
      return false
    }
  }


  private fun initPrinter(result: Result) {
    val deviceSupported = checkDeviceSupport()
    if (!deviceSupported) {
      result.error("PLUGIN_NOT_COMPATIBLE", "Device is not supported", NOT_SUPPORTED_ERROR_CODE)
      return
    }
    try {
      Log.d(TAG, "Initializing printer...")
      if (printer == null) {
        printer = PosApiHelper.getInstance()
      }
      val initStatus = printer!!.PrintInit()
      if (initStatus != 0) {
        Log.e(TAG, "Printer initialization failed with status: $initStatus")
      }
      Log.d(TAG, "Initialization successful")
      result.success(initStatus)
    } catch (e: Exception) {
      Log.e(TAG, "Printer initialization exception: ${e.message}")
      result.error("PRINT_INIT_EXCEPTION", "Printer initialization exception", e.message)
    }
  }

  private fun printString(call: MethodCall, result: Result) {
    try {
      if (printer == null) {
        result.error("PRINTER_NOT_INIT", "Printer not initialized", NOT_INIT_ERROR_CODE)
        return
      }
      val text = call.argument<String>("text")
      val align = call.argument<Int>("align") ?: 0 
      val fontHeight = call.argument<Int>("fontSize") ?: 24
      val fontWidth = call.argument<Int>("fontWidth") ?: 20
      val zoom = call.argument<Int>("zoom") ?: 0

      if (text == null) {
        result.error("INVALID_ARGUMENT", "Missing 'text' parameter", null)
        return
      }

      // Set alignment
      val alignStatus = printer!!.PrintSetAlign(align)
      if (alignStatus != 0) {
        Log.e(TAG, "Setting alignment $align failed")
        result.error("PRINT_ALIGN_ERROR", "Setting alignment failed", alignStatus)
        return
      }

      // Set font
      val fontStatus = printer!!.PrintSetFont(fontHeight.toByte(), fontWidth.toByte(), zoom.toByte())
      if (fontStatus != 0) {
        Log.e(TAG, "Setting font failed: $fontHeight, $fontWidth, $zoom")
        result.error("PRINT_FONT_ERROR", "Setting font failed", fontStatus)
        return
      }

      val printStatus = printer!!.PrintStr(text + "\n")
      if (printStatus != 0) {
        result.error("PRINT_STRING_ERROR", "Printing string failed", printStatus)
        return
      }
      Log.d(TAG, "String added successfully")
      result.success(printStatus)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printStart(result: Result) {
    try {
      if (printer == null) {
        result.error("PRINTER_NOT_INIT", "Printer not initialized", NOT_INIT_ERROR_CODE)
        return
      }
      Log.d(TAG, "Starting print...")
      val startStatus = printer!!.PrintStart()
      if (startStatus != 0) {
        result.error("PRINT_START_ERROR", "Starting print failed", startStatus)
        return
      }
      Log.d(TAG, "Print started successfully")
      result.success(startStatus)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printClose(result: Result) {
    try {
      if (printer == null) {
        result.error("PRINTER_NOT_INIT", "Printer not initialized", NOT_INIT_ERROR_CODE)
        return
      }
      val closeStatus = printer!!.PrintClose()
      if (closeStatus != 0) {
        result.error("PRINT_CLOSE_ERROR", "Closing print failed", closeStatus)
        return
      }
      Log.d(TAG, "Print closed successfully")
      result.success(closeStatus)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printCheckStatus(result: Result){
    try {
      if (printer == null) {
        result.error("PRINTER_NOT_INIT", "Printer not initialized", NOT_INIT_ERROR_CODE)
        return
      }
      val status = printer!!.PrintCheckStatus()
      if (status != 0) {
        result.error("PRINT_STATUS_ERROR", "Printer status check failed", status)
        return
      }
      result.success(status)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printQrCode(call: MethodCall, result: Result) {
    try {
      if (printer == null) {
        result.error("PRINTER_NOT_INIT", "Printer not initialized", NOT_INIT_ERROR_CODE)
        return
      }
      val content = call.argument<String>("data")
      val width = call.argument<Int>("width")
      val height = call.argument<Int>("height")

      if (content == null || width == null || height == null) {
          result.error("INVALID_ARGUMENT", "Missing required arguments", null)
          return
      }

      val barcodeFormat = BarcodeFormat.QR_CODE

      val printStatus = printer!!.PrintQrCode_Cut(content, width, height, barcodeFormat)
      if (printStatus != 0) {
          result.error("PRINT_QR_CODE_ERROR", "Printing QR code failed", printStatus)
          return
      }
      Log.d(TAG, "QR Code added successfully")
      result.success(printStatus)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
