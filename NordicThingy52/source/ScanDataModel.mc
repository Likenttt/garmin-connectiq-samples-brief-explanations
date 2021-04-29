using Toybox.System as Sys;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class ScanDataModel {
    private var _displayResult;
    private var _scanResults;

    function initialize( bleDelegate ) {
        bleDelegate.notifyScanResult( self );

        _scanResults = [];
        _displayResult = 0;
    }

    function procScanResult( scanResult ) {
        var newDevice = true;

        // Determine if this is a new Device
        for( var i = 0; i < _scanResults.size(); i++ ) {
            if( scanResult.isSameDevice( _scanResults[i] ) ) {
                newDevice = false;
                _scanResults[i] = scanResult;
                break;
            }
        }

        if( newDevice ) {
            _scanResults.add( scanResult );
        }

        WatchUi.requestUpdate();
    }

    function nextResult() {
        if( _displayResult < ( _scanResults.size() - 1 ) ) {
            _displayResult++;
            WatchUi.requestUpdate();
        }
    }

    function previousResult() {
        if( _displayResult > 0 ) {
            _displayResult--;
            WatchUi.requestUpdate();
        }
    }

    function getScanResults() {
        return _scanResults;
    }

    function getDisplayResult() {
        if( 0 == _scanResults.size() ) {
            return null;
        }

        return _scanResults[_displayResult];
    }

    function getDisplayIndex() {
        if( _scanResults.size() == 0 ){
            return 0;
        }

        return _displayResult + 1;
    }

    function getResultCount() {
        return _scanResults.size();
    }
}
