using Toybox.System as Sys;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as WatchUi;

class ThingyDelegate extends Ble.BleDelegate {
    private var _profileManager = null;

    private var _onScanResult = null;
    private var _onConnection = null;
    private var _onDescriptorWrite = null;
    private var _onCharChanged = null;

    function initialize( profileManager ) {
        BleDelegate.initialize();
        _profileManager = profileManager;
    }

    function onScanResults( scanResults ) {
        for( var result = scanResults.next(); result != null; result = scanResults.next() ) {
            if( contains( result.getServiceUuids(), _profileManager.THINGY_CONFIGURATION_SERVICE ) ) {
                broadcastScanResult( result );
            }
        }
    }

    function onConnectedStateChanged( device, state ) {
        if( ( null != _onConnection ) && _onConnection.stillAlive() ) {
            _onConnection.get().procConnection( device, state );
        }
    }

    function onDescriptorWrite(descriptor, status) {
        if( ( null != _onDescriptorWrite ) && _onDescriptorWrite.stillAlive() ) {
            _onDescriptorWrite.get().onDescriptorWrite( descriptor, status );
        }
    }

    function onCharacteristicChanged(char, value) {
        if( ( null != _onCharChanged ) && _onCharChanged.stillAlive() ) {
            _onCharChanged.get().onCharacteristicChanged(char, value);
        }
    }

    function notifyScanResult( interface ) {
        _onScanResult = interface.weak();
    }

    function notifyConnection( interface ) {
        _onConnection = interface.weak();
    }

    function notifyDescriptorWrite( interface ) {
        _onDescriptorWrite = interface.weak();
    }

    function notifyCharacteristicChanged( interface ) {
        _onCharChanged = interface.weak();
    }

    private function broadcastScanResult( scanResult ) {
        if( ( null != _onScanResult ) && _onScanResult.stillAlive() ) {
            _onScanResult.get().procScanResult( scanResult );
        }
    }

    private function contains( iter, obj ) {
        for( var uuid = iter.next(); uuid != null; uuid = iter.next() ) {
            if( uuid.equals( obj ) ) {
                return true;
            }
        }

        return false;
    }
}
