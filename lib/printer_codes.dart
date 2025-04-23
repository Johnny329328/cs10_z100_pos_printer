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
  };

  static String getLabel(int? code) {
    if (code == null || !_errorCodes.containsKey(code)) {
      return 'UNKNOWN ERROR CODE - FAILURE';
    }
    return ' "$code" : ${_errorCodes[0]!}';
  }
}

enum PrinterStatus {
  success,
  needsPaper,
  highTemperature,
  lowBatteryVoltage,
  unknownStatusError;

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

enum PrinterStringAlign {
  start,
  center,
  end;
}

enum PrinterStringWidth {
  xsmall(16),
  small(20),
  medium(24),
  large(28);

  final int value;
  const PrinterStringWidth(this.value);
}

enum PrinterStringHeight {
  xsmall(16),
  small(20),
  medium(24),
  large(28);

  final int value;
  const PrinterStringHeight(this.value);
}
