import 'package:cs10_z100_pos_printer/printer_codes.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cs10_z100_pos_printer_method_channel.dart';

abstract class Cs10Z100PosPrinterPlatform extends PlatformInterface {
  /// Constructs a Cs10Z100PosPrinterPlatform.
  Cs10Z100PosPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static Cs10Z100PosPrinterPlatform _instance =
      MethodChannelCs10Z100PosPrinter();

  /// The default instance of [Cs10Z100PosPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelCs10Z100PosPrinter].
  static Cs10Z100PosPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Cs10Z100PosPrinterPlatform] when
  /// they register themselves.
  static set instance(Cs10Z100PosPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> printInit();

  Future<bool> printString(PrinterText printerText);

  Future<bool> printStart();

  Future<bool> printClose();

  Future<PrinterStatus> printCheckStatus();

  Future<bool> printQrCode(PrinterQrCode qrCode);
}
