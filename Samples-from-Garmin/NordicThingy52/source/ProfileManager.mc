using Toybox.BluetoothLowEnergy as Ble;

class ProfileManager {
    public const THINGY_ENVIRONMENTAL_SERVICE = Ble.longToUuid(0xEF6802009B354933L, 0x9B1052FFA9740042L);
    public const TEMPERATURE_CHARACTERISTIC   = Ble.longToUuid(0xEF6802019B354933L, 0x9B1052FFA9740042L);
    public const PRESSURE_CHARACTERISTIC      = Ble.longToUuid(0xEF6802029B354933L, 0x9B1052FFA9740042L);
    public const HUMIDITY_CHARACTERISTIC      = Ble.longToUuid(0xEF6802039B354933L, 0x9B1052FFA9740042L);
    public const AIR_QUALITY_CHARACTERISTIC   = Ble.longToUuid(0xEF6802049B354933L, 0x9B1052FFA9740042L);


    public const THINGY_CONFIGURATION_SERVICE   = Ble.longToUuid(0xEF6801009B354933L, 0x9B1052FFA9740042L);

    private const _envProfileDef = {
        :uuid => THINGY_ENVIRONMENTAL_SERVICE,
        :characteristics => [{
            :uuid => TEMPERATURE_CHARACTERISTIC,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => PRESSURE_CHARACTERISTIC,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => HUMIDITY_CHARACTERISTIC,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }, {
            :uuid => AIR_QUALITY_CHARACTERISTIC,
            :descriptors => [
                Ble.cccdUuid()
            ]
        }]
    };

    private const UuidNameLookup = {
        THINGY_ENVIRONMENTAL_SERVICE => "Thingy Environmental Profile",
        TEMPERATURE_CHARACTERISTIC => "Temperature",
        PRESSURE_CHARACTERISTIC => "Pressure",
        HUMIDITY_CHARACTERISTIC => "Humidity",
        AIR_QUALITY_CHARACTERISTIC => "Air Quality"
    };

    public function registerProfiles() {
        Ble.registerProfile( _envProfileDef );
    }

    public function getDescription( uuid ) {
        if( UuidNameLookup.hasKey( uuid ) ) {
            return UuidNameLookup[uuid];
        }

        return "Unknown";
    }
}
