using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;

class DataModelFactory {
    // Dependancies
    private var _delegate;
    private var _profileManager;

    // Model Storage
    private var _scanDataModel;
    private var _deviceDataModel;
    private var _envModel;

    function initialize( delegate, profileManager ) {
        _delegate = delegate;
        _profileManager = profileManager;
    }

    function getScanDataModel() {
        var dataModel;
        if( null == _scanDataModel || !_scanDataModel.stillAlive() ) {
            dataModel = new ScanDataModel( _delegate );
            _scanDataModel = dataModel.weak();
        }
        else {
            dataModel = _scanDataModel.get();
        }

        return dataModel;
    }

    function getDeviceDataModel( scanResult ) {
        var dataModel;
        if( null == _deviceDataModel || !_deviceDataModel.stillAlive() ) {
            dataModel = new DeviceDataModel( _delegate, self, scanResult );
            _deviceDataModel = dataModel.weak();
        }
        else {
            dataModel = _deviceDataModel.get();
        }

        return dataModel;
    }

    function getEnvironmentModel( device ) {
        var dataModel;
        if( null == _envModel || !_envModel.stillAlive() ) {
            dataModel = new EnvironmentProfileModel( _delegate,
                _profileManager,
                device );
            _envModel = dataModel.weak();
        }
        else {
            dataModel = _envModel.get();
        }

        return dataModel;
    }
}
