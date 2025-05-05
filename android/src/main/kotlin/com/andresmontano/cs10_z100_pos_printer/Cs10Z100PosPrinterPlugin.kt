package com.andresmontano.cs10_z100_pos_printer

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
  }

  private lateinit var channel : MethodChannel
  private lateinit var printer : PosApiHelper

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cs10_z100_pos_printer")
    channel.setMethodCallHandler(this)
    printer = PosApiHelper.getInstance()
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

  private fun initPrinter(result: Result) {
    try {
      Log.d(TAG, "Initializing printer...")
      val initStatus = printer.PrintInit()
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
      val text = call.argument<String>("text")
      val align = call.argument<Int>("align") ?: 0 
      val fontHeight = call.argument<Int>("fontSize") ?: 24
      val fontWidth = call.argument<Int>("fontWidth") ?: 20
      val zoom = call.argument<Int>("zoom") ?: 0

      if (text == null) {
        Log.e(TAG, "Missing 'text' parameter")
        result.error("INVALID_ARGUMENT", "Missing 'text' parameter", null)
        return
      }

      // Set alignment
      val alignStatus = printer.PrintSetAlign(align)
      if (alignStatus != 0) {
        Log.e(TAG, "Setting alignment $align failed")
        result.error("PRINT_ALIGN_ERROR", "Setting alignment failed", alignStatus)
        return
      }

      // Set font
      val fontStatus = printer.PrintSetFont(fontHeight.toByte(), fontWidth.toByte(), zoom.toByte())
      if (fontStatus != 0) {
        Log.e(TAG, "Setting font failed: $fontHeight, $fontWidth, $zoom")
        result.error("PRINT_FONT_ERROR", "Setting font failed", fontStatus)
        return
      }

      val printStatus = printer.PrintStr(text + "\n")
      if (printStatus != 0) {
        Log.e(TAG, "Fail to add string: $text")
        result.error("PRINT_STRING_ERROR", "Printing string failed", printStatus)
        return
      }
      Log.d(TAG, "String added successfully")
      result.success(printStatus)
    } catch (e: Exception) {
      Log.e(TAG, "Unexpected error during printString: ${e.message}")
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printStart(result: Result) {
    try {
      Log.d(TAG, "Starting print job...")
      val startStatus = printer.PrintStart()
      if (startStatus != 0) {
        Log.e(TAG, "Starting print failed with status: $startStatus")
        result.error("PRINT_START_ERROR", "Starting print failed", startStatus)
        return
      }
      Log.d(TAG, "Print job started successfully")
      result.success(startStatus)
    } catch (e: Exception) {
      Log.e(TAG, "Unexpected error during printStart: ${e.message}")
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printClose(result: Result) {
    try {
      val closeStatus = printer.PrintClose()
      if (closeStatus != 0) {
        Log.e(TAG, "Close print failed with status: $closeStatus")
        result.error("PRINT_CLOSE_ERROR", "Closing print failed", closeStatus)
        return
      }
      Log.d(TAG, "Print closed successfully")
      result.success(closeStatus)
    } catch (e: Exception) {
      Log.e(TAG, "Unexpected error during printCLose: ${e.message}")
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printCheckStatus(result: Result){
    try {
      val status = printer.PrintCheckStatus()
      if (status != 0) {
        Log.e(TAG, "Printer status check failed with status: $status")
        result.error("PRINT_STATUS_ERROR", "Printer status check failed", status)
        return
      }
      Log.d(TAG, "Printer status check successful")
      result.success(status)
    } catch (e: Exception) {
      Log.e(TAG, "Unexpected error during printCheckStatus: ${e.message}")
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  private fun printQrCode(call: MethodCall, result: Result) {
    try {
      val content = call.argument<String>("data")
      val width = call.argument<Int>("width")
      val height = call.argument<Int>("height")

      if (content == null || width == null || height == null) {
          result.error("INVALID_ARGUMENT", "Missing required parameters", null)
          return
      }

      val barcodeFormat = BarcodeFormat.QR_CODE

      val printStatus = printer.PrintQrCode_Cut(content, width, height, barcodeFormat)
      if (printStatus != 0) {
          result.error("PRINT_QR_CODE_ERROR", "Printing QR code failed", printStatus)
          return
      }
      result.success(printStatus)
    } catch (e: Exception) {
      result.error("UNEXPECTED_ERROR", "An unexpected error occurred", e.message)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
