using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;

class ViewController {
    private var _modelFactory;

    function initialize( modelFactory ) {
        _modelFactory = modelFactory;
    }

    function getInitialView() {
        var scanDataModel = _modelFactory.getScanDataModel();

        return [
            new ScanView( scanDataModel ),
            new ScanDelegate( scanDataModel, self )
            ];
    }

    function pushScanMenu( ) {
        WatchUi.pushView(
            new Rez.Menus.MainMenu(),
            new ScanMenuDelegate(),
            WatchUi.SLIDE_UP
        );
    }

    function pushDeviceView( scanResult ) {
        var deviceDataModel = _modelFactory.getDeviceDataModel( scanResult );

        WatchUi.pushView(
            new DeviceView( deviceDataModel ),
            new DeviceDelegate( deviceDataModel ),
            WatchUi.SLIDE_UP
        );
    }
}
