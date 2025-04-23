# Changelog

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
