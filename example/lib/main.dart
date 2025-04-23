import 'package:flutter/material.dart';
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _testPrinter() async {
    final printer = Cs10Z100PosPrinter();
    final wasInit = await printer.printInit();
    if (!wasInit) return;
    bool stringAdded = await printer.addString(
      'Add String (start,small,small) example',
      width: PrinterStringWidth.small,
      height: PrinterStringHeight.small,
    );
    if (!stringAdded) return;
    stringAdded = await printer.addString(
      'String (center,m,m)',
      align: PrinterStringAlign.center,
      width: PrinterStringWidth.medium,
      height: PrinterStringHeight.medium,
    );
    if (!stringAdded) return;
    stringAdded = await printer.addString(
      'Add String (end,large,large) example',
      align: PrinterStringAlign.end,
      width: PrinterStringWidth.large,
      height: PrinterStringHeight.large,
    );
    if (!stringAdded) return;
    stringAdded = await printer.addString('\n\n\n\n\n\n');
    if (!stringAdded) return;
    final printStarted = await printer.printStart();
    if (!printStarted) return;
    await printer.printClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CS10/Z100 POS Printer Plugin'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: _testPrinter,
            child: const Text('Test Printer'),
          ),
        ],
      ),
    );
  }
}
