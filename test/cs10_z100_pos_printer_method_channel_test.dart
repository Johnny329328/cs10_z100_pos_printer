import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs10_z100_pos_printer/cs10_z100_pos_printer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCs10Z100PosPrinter platform = MethodChannelCs10Z100PosPrinter();
  const MethodChannel channel = MethodChannel('cs10_z100_pos_printer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return true;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('init printer', () async {
    expect(await platform.printInit(), true);
  });
}
