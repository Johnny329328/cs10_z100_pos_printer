import 'package:flutter/material.dart' show immutable;

class PrinterCodes {
  static const Map<int, String> _errorCodes = {
    0: 'SUCCESS',
    -1: 'Short of Paper',
    -2: 'The temperature is too high',
    -3: 'The voltage is too low - Low battery voltage',
    8: 'Instruction reply disorder',
    9: 'Instruction reply disorder',
    1001: 'send fail',
    1002: 'receive timeout',
    -1023: 'status error',
    -1021: 'Short of paper',
    -1001: 'send fail - print timeout',
    -1002: 'receive timeout - print timeout',
    -1000: 'print timeout',
    -1016: 'print timeout',
    -1003: 'print timeout',
    -1004: 'print timeout',
    -1019: 'print timeout',
    -1017: 'print timeout',
    -1018: 'print timeout',
    -1020: 'print timeout',
    -1007: 'Print times exceeds limit',
    -1008: 'Print times exceeds limit',
    -1009: 'Print times exceeds limit',
    -1010: 'Print times exceeds limit',
    -1011: 'Print times exceeds limit',
    -1012: 'Print times exceeds limit',
    -1022: 'heat error',
    -1014: 'Short of paper',
    -1015: 'Short of paper',
    -4001: 'PRINT BUSY',
    -4002: 'PRINT NOPAPER',
    -4003: 'PRINT DATAERR',
    -4004: 'PRINT FAULT',
    -4005: 'PRINT TOOHEAT',
    -4006: 'PRINT UNFINISHED',
    -4007: 'PRINT NOFONTLIB',
    -4008: 'PRINT BUFFOVERFLOW',
    -4009: 'PRINT SETFONTERR',
    -4010: 'PRINT GETFONTERR',
    9998: 'Printing has not been started. Call printInit()',
    9999:
        'Plugin does not support this device, use a CS10 or Z100 printer model',
  };

  static String getLabel(int? code) {
    if (code == null || !_errorCodes.containsKey(code)) {
      return 'UNKNOWN ERROR CODE - FAILURE';
    }
    return '"$code" - ${_errorCodes[code]!}';
  }
}

/// Enum representing the possible statuses of the printer.
enum PrinterStatus {
  /// The printer is in a successful state.
  success,

  /// The printer is out of paper.
  needsPaper,

  /// The printer is experiencing a high temperature.
  highTemperature,

  /// The printer has a low battery voltage.
  lowBatteryVoltage,

  /// The printer status is unknown or an error occurred.
  unknownStatusError;

  /// Converts an integer printer code to a [PrinterStatus] enum value.
  ///
  /// The [code] parameter represents the integer code returned by the printer.
  /// Returns the corresponding [PrinterStatus] enum value, or
  /// [PrinterStatus.unknownStatusError] if the code is not recognized.
  static PrinterStatus fromPrinterCode(int? code) {
    switch (code) {
      case 0:
        return PrinterStatus.success;
      case 1:
        return PrinterStatus.needsPaper;
      case -2:
        return PrinterStatus.highTemperature;
      case -3:
        return PrinterStatus.lowBatteryVoltage;
      default:
        return PrinterStatus.unknownStatusError;
    }
  }
}

/// Enum representing the alignment options for printed text.
enum PrinterStringAlign {
  /// Align text to the start (left).
  start,

  /// Align text to the center.
  center,

  /// Align text to the end (right).
  end;
}

/// Enum representing the size options for printed text.
enum PrinterStringSize {
  xsmall(16),
  small(20),
  medium(24),
  large(28);

  /// The integer value representing the text size.
  final int value;
  const PrinterStringSize(this.value);
}

/// Enum representing the zoom options for printed text.
enum PrinterStringZoom {
  /// No zoom.
  zero(0),

  /// Medium zoom.
  medium(33);

  /// The integer value representing the zoom.
  final int value;
  const PrinterStringZoom(this.value);
}

/// Abstract base class for printable objects.
///
/// This class defines the common properties for all printable elements.
@immutable
abstract class Printable {
  final String value;
  final PrinterStringAlign align;

  const Printable(
    this.value, {
    this.align = PrinterStringAlign.start,
  });
}

/// Class representing text to be printed.
///
/// This class allows specifying the text content and formatting options.
@immutable
class PrinterText extends Printable {
  /// The size of the text.
  final PrinterStringSize size;

  /// The zoom level of the text.
  final PrinterStringZoom zoom;

  const PrinterText(
    super.value, {
    super.align,
    this.size = PrinterStringSize.medium,
    this.zoom = PrinterStringZoom.zero,
  });
}

/// Class representing a QR code to be printed.
///
/// This class allows specifying the QR code data and dimensions.
@immutable
class PrinterQrCode extends Printable {
  /// The width of the QR code.

  final int width;

  /// The height of the QR code.
  final int height;

  const PrinterQrCode(
    super.value, {
    super.align,
    this.width = 300,
    this.height = 300,
  });
}
