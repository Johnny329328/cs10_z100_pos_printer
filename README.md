# CS10-Z100 POS Printer Plugin

[<img src="https://github.com/user-attachments/assets/6f0b1f67-f682-4f82-9f21-4822bf07cdfb" alt="pubdev logo" width="20" align="absmiddle"/> Pub Dev Package](https://pub.dev/packages/cs10_z100_pos_printer)


A Flutter plugin for printing on the integrated terminal of CS10-Z100 POS devices.
Built specifically for Android POS models CS10 and Z100

## Features

* Initialize and close the printer connection.
* Check the printer status.
* Print text with customizable alignment and font settings.
* Print QR code.

**Important:** Be sure to call `printInit()` at least once before using any other methods.

## Device Compatibility

**Important:** This plugin is **exclusively compatible with the CS10-Z100 POS terminal**. It will not function correctly and will print  `Plugin does not support this device, use a CS10 or Z100 printer model` message on the console.
These models usually look like this:

<p align="center">
  <img src="https://github.com/user-attachments/assets/f41772cd-8128-4460-842d-8d85202d145c" alt="cs10z100model logo" width="300"/>
</p>

## Installation

Add the plugin to your Flutter project by running:

```bash
flutter pub add cs10_z100_pos_printer
```

## Usage

Import the plugin:

```dart
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';
```

Initialize the printer plugin instance:

```dart 
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() async {
  final printer = Cs10Z100PosPrinter();
  final wasInit = await printer.printInit();
  if (wasInit) {
    print('Printer initialized successfully');
  } else {
    print('Printer initialization failed');
  }
}
```

Add text to the printer queue:

```dart 
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() async {
  final printer = Cs10Z100PosPrinter();
  final wasInit = await printer.printInit();
  if (!wasInit) return;

  // option 1
  await printer.addString(PrinterText('Example Text',align: PrinterStringAlign.center,zoom: PrinterStringZoom.medium));

  // option 2
  await printer.addToQueue(PrinterText('Example Text',align: PrinterStringAlign.center,zoom: PrinterStringZoom.medium));
}
```

Add a Qr Code to the queue:

```dart 
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() async {
  final printer = Cs10Z100PosPrinter();
  final wasInit = await printer.printInit();
  if (!wasInit) return;

  // option 1
  await printer.addQrCode(PrinterQrCode('https://pub.dev/packages/cs10_z100_pos_printer', align: PrinterStringAlign.center));

  // option 2
  await printer.addToQueue(PrinterQrCode('https://pub.dev/packages/cs10_z100_pos_printer', align: PrinterStringAlign.center));
}
```

Start printing the queue:

```dart 
final printStarted = await printer.printStart();
```

Clears the queue:

```dart 
await printer.printClose();
```

Example:

```dart 
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() async {
  final space = List.generate(8, (index) => '\n').join();
  final printer = Cs10Z100PosPrinter();
  final wasInit = await printer.printInit();
  if (!wasInit) return;
  final List<Printable> list = [
    PrinterText(
      'Example Title',
      align: PrinterStringAlign.center,
      zoom: PrinterStringZoom.medium,
    ),
    PrinterText('\n\n'),
    PrinterText('Receipt Number:\t12034'),
    PrinterText('Date:\t25/04/2025'),
    PrinterText('\n'),
    PrinterText('Amount: \$. 10.00'),
    PrinterText('Tax:    \$.  1.00'),
    PrinterText('Total:  \$. 11.00'),
    PrinterText('\n'),
    PrinterQrCode('https://pub.dev/packages/cs10_z100_pos_printer', align: PrinterStringAlign.center),
    PrinterText('Url Link', align: PrinterStringAlign.center, size: PrinterStringSize.small),
    PrinterText(space, align: PrinterStringAlign.center),
  ];
  bool stringAdded = false;
  for (var element in list) {
    stringAdded = await printer.addToQueue(element);
    if (!stringAdded) return;
  }
  final printStarted = await printer.printStart();
  if (!printStarted) return;
  await printer.printClose();
}
```

