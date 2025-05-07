import 'package:flutter_test/flutter_test.dart';
import 'package:cs10_z100_pos_printer/printer_codes.dart';
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer_platform_interface.dart';
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCs10Z100PosPrinterPlatform
    with MockPlatformInterfaceMixin
    implements Cs10Z100PosPrinterPlatform {
  @override
  Future<bool> printInit() {
    throw UnimplementedError();
  }

  @override
  Future<bool> printClose() {
    throw UnimplementedError();
  }

  @override
  Future<bool> printStart() {
    throw UnimplementedError();
  }

  @override
  Future<PrinterStatus> printCheckStatus() {
    throw UnimplementedError();
  }

  @override
  Future<bool> printString(PrinterText printerText) {
    throw UnimplementedError();
  }

  @override
  Future<bool> printQrCode(PrinterQrCode qrCode) {
    throw UnimplementedError();
  }
}

void main() {
  final Cs10Z100PosPrinterPlatform initialPlatform =
      Cs10Z100PosPrinterPlatform.instance;

  test('$MethodChannelCs10Z100PosPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCs10Z100PosPrinter>());
  });
}
