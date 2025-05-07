# Changelog

## [1.0.1] - Updated README

* Added an image of the CS10-Z100 POS terminal to the README.md for better device identification.

## [1.0.0] - Major Update: Refactored Printing Methods and Added QR Code Support

* **Breaking Change:** The `addString()` method has been completely refactored and is **not backward-compatible**.
    * This change was made to improve code organization and provide better encapsulation of text formatting options.
    * **Migration Guide:**
        * You **must** update your code to use the `addToString()` method and the `PrinterText` class to print text.
* **New Feature:** Added `addQrCode()` method to print QR codes.
    * This method takes a `PrinterQrCode` object as a parameter.
* **New Feature:** Introduced `addToQueue()` method for a more generic printing queue.
    * This method accepts a `Printable` object (either `PrinterText` or `PrinterQrCode`) and automatically calls the appropriate printing method.
* **New Classes:** The following classes have been added to support the new features and refactoring:
    * `Printable` (abstract class): Base class for printable objects.
    * `PrinterText`: Class to represent text to be printed, including formatting options.
    * `PrinterQrCode`: Class to represent QR codes to be printed.
    * `PrinterStringSize` (enum): Enum for text size options.
    * `PrinterStringZoom` (enum): Enum for text zoom options.
* **Important:** **Device Compatibility Check Added**
    * The plugin now explicitly checks for device compatibility with the CS10-Z100 POS terminal.
    * Plugin methods `initPrinter()` will return `false` and show the message error on the console if the device is not supported.
    * This change ensures that the plugin is used correctly and prevents unexpected crashes or behavior on unsupported devices.

## [0.0.1] - Initial Release

* Initial release of the CS10-Z100 POS Printer plugin.
* Provides the following functionality:
    * Printer initialization (`printInit()`).
    * Adding a string to the print queue with formatting options (`addString()`).
        * Supports text alignment (`align`).
        * Supports font width (`width`).
        * Supports font height (`height`).
    * Starting the printing process (`printStart()`).
    * Closing the printer connection and clearing the queue (`printClose()`).
    * Checking the printer's status (`printCheckStatus()`).
