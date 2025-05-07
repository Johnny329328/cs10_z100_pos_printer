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
      PrinterQrCode('https://pub.dev/packages/cs10_z100_pos_printer',
          align: PrinterStringAlign.center),
      PrinterText('Url Link',
          align: PrinterStringAlign.center, size: PrinterStringSize.small),
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
