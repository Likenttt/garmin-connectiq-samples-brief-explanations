using Toybox.System as Sys;
using Toybox.BluetoothLowEnergy as Ble;

class DeviceManager {
    hidden var _profileManager;
    hidden var _device;
    hidden var _soundService;
    hidden var _config;
    hidden var _speakerData;
    hidden var _configComplete;
    hidden var _sampleInProgress;

    function initialize( bleDelegate, profileManager ) {
        _device = null;

        bleDelegate.notifyScanResult( self );
        bleDelegate.notifyConnection( self );
        bleDelegate.notifyCharWrite( self );

        _profileManager = profileManager;
    }

    function start() {
        Ble.setScanState( Ble.SCAN_STATE_SCANNING );
    }

    function procScanResult( scanResult ) {
        // Pair the first Thingy we see with good RSSI
        if( scanResult.getRssi() > -50 ) {
            Ble.setScanState( Ble.SCAN_STATE_OFF );
            Ble.pairDevice( scanResult );
        }
    }

    function procConnection( device, state ) {
        if( device.isConnected() ) {
            _device = device;
            startSoundControl();
        } else {
            _device = null;
        }
    }

    function procCharWrite( char, status ) {
        Sys.println( "Proc Write: (" + char.getUuid() +") - " + status );

        if( char.equals( _config ) ) {
            _configComplete = true;
            _sampleInProgress = false;
        }
        else if( char.equals( _speakerData ) ) {
            _sampleInProgress = false;
        }
    }

    function playSample( sampleId ) {
        if( ( null == _device ) || !_configComplete || _sampleInProgress ) {
            return;
        }

        _sampleInProgress = true;
        _speakerData.requestWrite([sampleId]b, {});
    }

    private function startSoundControl() {
        Sys.println( "Start Sound" );
        _soundService = _device.getService( _profileManager.THINGY_SOUND_SERVICE);
        _config = _soundService.getCharacteristic(
            _profileManager.SOUND_CONFIG_CHARACTERISTIC );
        _speakerData = _soundService.getCharacteristic(
            _profileManager.SPEAKER_DATA_CHARACTERISTIC );

        // Put the speaker into Sample Mode
        _configComplete = false;
        _config.requestWrite( [0x03, 0x01]b, { :writeType => Ble.WRITE_TYPE_WITH_RESPONSE } );
    }
}
