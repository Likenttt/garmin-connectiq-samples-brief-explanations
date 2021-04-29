using Toybox.WatchUi;

class ScanDelegate extends WatchUi.BehaviorDelegate {
    private var _scanDataModel;
    private var _viewController;

    function initialize( scanDataModel, viewController ) {
        BehaviorDelegate.initialize();

        _scanDataModel = scanDataModel;
        _viewController = viewController;
    }

    function onMenu() {
        _viewController.pushScanMenu();
        return true;
    }

    function onSelect() {
        if( null != _scanDataModel.getDisplayResult() ){
            _viewController.pushDeviceView( _scanDataModel.getDisplayResult() );
        }
    }

    function onNextPage() {
        _scanDataModel.nextResult();
    }

    function onPreviousPage() {
        _scanDataModel.previousResult();
    }
}
