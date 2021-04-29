using Toybox.System as Sys;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Lang;

class EnvironmentProfileModel {
    private var _service;
    private var _profileManager;
    private var _pendingNotifies;

    private var _temperature;
    private var _pressure;
    private var _humidity;
    private var _eco2;
    private var _tvoc;

    function initialize( delegate, profileManager, device ) {
        delegate.notifyDescriptorWrite( self );
        delegate.notifyCharacteristicChanged( self );

        _profileManager  = profileManager;
        _service = device.getService(
            profileManager.THINGY_ENVIRONMENTAL_SERVICE );

        _pendingNotifies = [];

        var characteristic = _service.getCharacteristic(
            profileManager.TEMPERATURE_CHARACTERISTIC);
        if( null != characteristic ) {
            _pendingNotifies = _pendingNotifies.add( characteristic );
        }

        characteristic = _service.getCharacteristic(
            profileManager.PRESSURE_CHARACTERISTIC );
        if( null != characteristic ) {
            _pendingNotifies = _pendingNotifies.add( characteristic );
        }

        characteristic = _service.getCharacteristic(
            profileManager.HUMIDITY_CHARACTERISTIC );
        if( null != characteristic ) {
            _pendingNotifies = _pendingNotifies.add( characteristic );
        }

        characteristic = _service.getCharacteristic(
            profileManager.AIR_QUALITY_CHARACTERISTIC );
        if( null != characteristic ) {
            _pendingNotifies = _pendingNotifies.add( characteristic );
        }

        activateNextNotification();
    }

    function onCharacteristicChanged(char, value) {
        switch( char.getUuid() ) {
            case _profileManager.TEMPERATURE_CHARACTERISTIC:
                processTemperatureValue( value );
                break;

            case _profileManager.PRESSURE_CHARACTERISTIC:
                processPressureValue( value );
                break;

            case _profileManager.HUMIDITY_CHARACTERISTIC:
                processHumidityValue( value );
                break;

            case _profileManager.AIR_QUALITY_CHARACTERISTIC:
                processAirQualityValue( value );
                break;
        }
    }

    function onDescriptorWrite(descriptor, status) {
        if( Ble.cccdUuid().equals( descriptor.getUuid() ) ) {
            processCccdWrite( status );
        }
    }

    function getTemperature() {
        return _temperature;
    }

    function getPressure() {
        return _pressure;
    }

    function getHumidity() {
        return _humidity;
    }

    function getEco2() {
        return _eco2;
    }

    function getTvoc() {
        return _tvoc;
    }

    private function activateNextNotification() {
        if( _pendingNotifies.size() == 0 ) {
            return;
        }

        var char = _pendingNotifies[0];
        var cccd = char.getDescriptor(Ble.cccdUuid());
        cccd.requestWrite([0x01, 0x00]b);
    }

    private function processCccdWrite( status ) {
        if( _pendingNotifies.size() > 1 ) {
            _pendingNotifies = _pendingNotifies.slice(
                1,
                _pendingNotifies.size() );

            activateNextNotification();
        }
        else {
            _pendingNotifies = [];
        }

    }

    private function processAirQualityValue( value ) {
        _eco2 = value.decodeNumber( Lang.NUMBER_FORMAT_UINT16, null );
        _tvoc = value.decodeNumber( Lang.NUMBER_FORMAT_UINT16, { :offset => 2 } );
        WatchUi.requestUpdate();
    }

    private function processHumidityValue( value ) {
        _humidity = value.decodeNumber( Lang.NUMBER_FORMAT_UINT8, null );
        WatchUi.requestUpdate();
    }

    private function processPressureValue( value ) {
        _pressure = value.decodeNumber( Lang.NUMBER_FORMAT_SINT32, null ) +
            (value.decodeNumber( Lang.NUMBER_FORMAT_UINT8, { :offset => 4 } ) / 100.0);
        WatchUi.requestUpdate();
    }

    private function processTemperatureValue( value ) {
        _temperature = value.decodeNumber( Lang.NUMBER_FORMAT_SINT8, null ) +
            (value.decodeNumber( Lang.NUMBER_FORMAT_UINT8, { :offset => 1 } ) / 100.0);
        WatchUi.requestUpdate();
    }
}
