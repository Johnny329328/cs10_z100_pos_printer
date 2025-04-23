import 'package:cs10_z100_pos_printer/printer_codes.dart';

import 'cs10_z100_pos_printer_platform_interface.dart';

export 'printer_codes.dart';

/// A Flutter plugin for printing on the integrated terminal of CS10-Z100 POS devices.
class Cs10Z100PosPrinter {
  /// Initializes the printer.
  ///
  /// The [initParams] parameter is optional and can be used to provide
  /// specific initialization settings.
  ///
  /// Returns `true` if the initialization was successful, `false` otherwise.
  Future<bool> printInit() => Cs10Z100PosPrinterPlatform.instance.printInit();

  /// Prints the given [text] with optional formatting options.
  ///
  /// The [align] parameter specifies the text alignment (left, center, right).
  /// The [height] and [width] parameters control the font size.
  Future<bool> addString(
    String text, {
    PrinterStringAlign align = PrinterStringAlign.start,
    PrinterStringWidth width = PrinterStringWidth.medium,
    PrinterStringHeight height = PrinterStringHeight.medium,
  }) =>
      Cs10Z100PosPrinterPlatform.instance.printString(text, align, width, height);

  /// Start printing process
  Future<bool> printStart() => Cs10Z100PosPrinterPlatform.instance.printStart();

  /// Close printing and clear queue
  Future<bool> printClose() => Cs10Z100PosPrinterPlatform.instance.printClose();

  /// Check printer status
  Future<PrinterStatus> printCheckStatus() => Cs10Z100PosPrinterPlatform.instance.printCheckStatus();
}
