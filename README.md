# CS10-Z100 POS Printer Plugin

[![pub package](https://badges.pub/packages/cs10_z100_pos_printer/versions.svg)](https://pub.dev/packages/cs10_z100_pos_printer)

A Flutter plugin for printing on the integrated terminal of CS10-Z100 POS devices.

## Features

* Initialize and close the printer connection.
* Check the printer status.
* Print text with customizable alignment and font settings.

## Installation

Add the plugin to your Flutter project by running:

```bash
flutter pub add cs10_z100_pos_printer
```

## Usage

```dart
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() async {
  final printer = Cs10Z100PosPrinter();
  final wasInit = await printer.printInit();
  if (!wasInit) return;
  final stringAdded = await printer.addString('Hello World!');
  if (!stringAdded) return;
  final printStarted = await printer.printStart();
  if (!printStarted) return;
  await printer.printClose();
}
```

