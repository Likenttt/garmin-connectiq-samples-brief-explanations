using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.BluetoothLowEnergy as Ble;

class NordicThingyApp extends Application.AppBase {
    private var _bleDelegate;
    private var _profileManager;
    private var _modelFactory;
    private var _viewController;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        _profileManager = new ProfileManager();
        _bleDelegate = new ThingyDelegate( _profileManager );
        _modelFactory = new DataModelFactory( _bleDelegate, _profileManager );
        _viewController = new ViewController( _modelFactory );

        Ble.setDelegate( _bleDelegate );
        _profileManager.registerProfiles();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        _viewController = null;
        _modelFactory = null;
        _profileManager = null;
        _bleDelegate = null;
    }

    // Return the initial view of your application here
    function getInitialView() {
        return _viewController.getInitialView();
    }

}
