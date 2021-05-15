using Toybox.System as Sys;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class DeviceDataModel {
    private var _scanResult;
    private var _device;
    private var _environmentProfile;
    private var _dataModelFactory;

    function initialize( bleDelegate, dataModelFactory, scanResult ) {
        _scanResult = scanResult;
        _dataModelFactory = dataModelFactory;

        bleDelegate.notifyConnection( self );

        _device = null;
        _environmentProfile = null;
    }

    function procConnection( device, connState ) {
        if( device != _device ) {
            // Not our device
            return;
        }

        if( device.isConnected() ) {
            procDeviceConnected();
        }

        WatchUi.requestUpdate();
    }

    function pair() {
        Ble.setScanState( Ble.SCAN_STATE_OFF );
        _device = Ble.pairDevice( _scanResult );
    }

    function unpair() {
        Ble.unpairDevice( _device );
        _device = null;
    }

    function getActiveProfile() {
        if( !_device.isConnected() ) {
            return null;
        }

        return _environmentProfile;
    }

    function isConnected() {
        return ( _device != null ) && _device.isConnected();
    }

    private function procDeviceConnected() {
        _environmentProfile = _dataModelFactory.getEnvironmentModel( _device );
    }
}
