using Toybox.Application;
using Toybox.BluetoothLowEnergy as Ble;

class Thingy52CoinCollectorApp extends Application.AppBase {

    hidden var _profileManager;
    hidden var _bleDelegate;
    hidden var _deviceManager;
    hidden var _accelManager;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        _profileManager = new ProfileManager();
        _bleDelegate = new ThingyDelegate( _profileManager );
        _deviceManager = new DeviceManager( _bleDelegate, _profileManager );

        Ble.setDelegate( _bleDelegate );
        _profileManager.registerProfiles();
        _deviceManager.start();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        _accelManager = null;
        _deviceManager = null;
        _bleDelegate = null;
        _profileManager = null;
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new Thingy52CoinCollectorView(_deviceManager) ];
    }
}
