using Toybox.WatchUi;

class DeviceDelegate extends WatchUi.BehaviorDelegate {
    private var _deviceDataModel;

    function initialize( deviceDataModel ) {
        BehaviorDelegate.initialize();

        _deviceDataModel = deviceDataModel;
        _deviceDataModel.pair();
    }

    function onBack() {
        _deviceDataModel.unpair();
        WatchUi.popView( WatchUi.SLIDE_DOWN );
        return true;
    }
}
