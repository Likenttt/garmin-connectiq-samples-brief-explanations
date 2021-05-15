using Toybox.WatchUi;
using Toybox.System;
using Toybox.BluetoothLowEnergy as Ble;

class ScanMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            Ble.setScanState( Ble.SCAN_STATE_SCANNING );
        }
        else if (item == :item_2) {
            Ble.setScanState( Ble.SCAN_STATE_OFF );
        }
    }
}
