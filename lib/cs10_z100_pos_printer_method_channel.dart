import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'printer_codes.dart';
import 'cs10_z100_pos_printer_platform_interface.dart';

const _printInitMethodName = 'printInit';
const _printStringMethodName = 'printString';
const _printStartMethodName = 'printStart';
const _printCloseMethodName = 'printClose';
const _printQrCodeMethodName = 'printQrCode';
const _printCheckStatusMethodName = 'printCheckStatus';
const _methodChannelTag = 'CS10Z100_POS_PRINTER-METHOD_CHANNEL';
const _successPrinterCode = 0;

/// An implementation of [Cs10Z100PosPrinterPlatform] that uses method channels.
class MethodChannelCs10Z100PosPrinter extends Cs10Z100PosPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cs10_z100_pos_printer');

  void _debugPrintInvokeMethodError(dynamic e, String method) {
    debugPrint('[$_methodChannelTag]/Error on method: $method. $e');
  }

  void _debugPrintInvokeMethodResult(int? code, String method) {
    final printerCodeMsg = PrinterCodes.getLabel(code);
    debugPrint('[$_methodChannelTag]/$method: $printerCodeMsg');
  }

  Future<int?> _invokeMethodInt(String method, [dynamic arguments]) async {
    final respCode = await methodChannel.invokeMethod<int>(method, arguments).onError(
      (e, __) {
        _debugPrintInvokeMethodError(e, method);
        if (e is PlatformException) {
          return int.tryParse(e.details.toString());
        }
        return null;
      },
    );
    _debugPrintInvokeMethodResult(respCode, method);
    return respCode;
  }

  Future<bool> _invokeMethodBool(String method, [dynamic arguments]) async {
    final respCode = await _invokeMethodInt(method, arguments);
    return respCode == _successPrinterCode;
  }

  @override
  Future<bool> printInit() => _invokeMethodBool(_printInitMethodName);

  @override
  Future<bool> printString(PrinterText printerText) => _invokeMethodBool(_printStringMethodName, {
        'text': printerText.value,
        'align': printerText.align.index,
        'fontSize': printerText.size.value,
        'zoom': printerText.zoom.value,
      });

  @override
  Future<bool> printStart() => _invokeMethodBool(_printStartMethodName);

  @override
  Future<bool> printClose() => _invokeMethodBool(_printCloseMethodName);

  @override
  Future<PrinterStatus> printCheckStatus() async {
    final respCode = await _invokeMethodInt(_printCheckStatusMethodName);
    return PrinterStatus.fromPrinterCode(respCode);
  }

  @override
  Future<bool> printQrCode(PrinterQrCode qrCode) => _invokeMethodBool(_printQrCodeMethodName, {
        'data': qrCode.value,
        'width': qrCode.width,
        'height': qrCode.height,
      });
}
