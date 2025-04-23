import 'package:cs10_z100_pos_printer/printer_codes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cs10_z100_pos_printer_platform_interface.dart';

const _printInitMethodName = 'printInit';
const _printStringMethodName = 'printString';
const _printStartMethodName = 'printStart';
const _printCloseMethodName = 'printClose';

/// An implementation of [Cs10Z100PosPrinterPlatform] that uses method channels.
class MethodChannelCs10Z100PosPrinter extends Cs10Z100PosPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cs10_z100_pos_printer');

  Future<bool> _invokeMethod(String method, [dynamic arguments]) async {
    final respCode = await methodChannel.invokeMethod<int>(method, arguments).onError(
      (e, st) {
        debugPrint('e: $e, st: $st');
        return null;
      },
    );
    final initializationMsg = PrinterCodes.getLabel(respCode);
    debugPrint('[InvokeMethod-$method] : $initializationMsg');
    return respCode == 0;
  }

  @override
  Future<bool> printInit() => _invokeMethod(_printInitMethodName);

  @override
  Future<bool> printString(
    String text, [
    PrinterStringAlign? align,
    PrinterStringWidth? width,
    PrinterStringHeight? height,
  ]) =>
      _invokeMethod(_printStringMethodName, {
        'text': text,
        'align': align?.index,
        'fontWidth': width?.value,
        'fontHeight': height?.value,
      });

  @override
  Future<bool> printStart() => _invokeMethod(_printStartMethodName);

  @override
  Future<bool> printClose() => _invokeMethod(_printCloseMethodName);

  @override
  Future<PrinterStatus> printCheckStatus() async {
    const method = 'printCheckStatus';
    final respCode = await methodChannel.invokeMethod<int>(method).onError(
      (e, st) {
        debugPrint('e: $e, st: $st');
        return null;
      },
    );
    final initializationMsg = PrinterCodes.getLabel(respCode);
    debugPrint('[InvokeMethod-$method] : $initializationMsg');
    return PrinterStatus.fromPrinterCode(respCode);
  }
}
