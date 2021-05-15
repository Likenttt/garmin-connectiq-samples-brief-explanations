using Toybox.BluetoothLowEnergy as Ble;

class ProfileManager {
    public const THINGY_CONFIGURATION_SERVICE   = Ble.longToUuid(0xEF6801009B354933L, 0x9B1052FFA9740042L);

    public const THINGY_SOUND_SERVICE = Ble.longToUuid(0xEF6805009B354933L, 0x9B1052FFA9740042L);
    public const SOUND_CONFIG_CHARACTERISTIC = Ble.longToUuid(0xEF6805019B354933L, 0x9B1052FFA9740042L);
    public const SPEAKER_DATA_CHARACTERISTIC = Ble.longToUuid(0xEF6805029B354933L, 0x9B1052FFA9740042L);

    private const _soundProfileDef = {
        :uuid => THINGY_SOUND_SERVICE,
        :characteristics => [{
            :uuid => SOUND_CONFIG_CHARACTERISTIC
        }, {
            :uuid => SPEAKER_DATA_CHARACTERISTIC
        }]
    };

    public function registerProfiles() {
        Ble.registerProfile( _soundProfileDef );
    }
}
