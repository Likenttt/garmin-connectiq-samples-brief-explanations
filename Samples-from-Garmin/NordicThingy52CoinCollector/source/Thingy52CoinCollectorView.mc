using Toybox.WatchUi;

class Thingy52CoinCollectorView extends WatchUi.SimpleDataField {
    hidden var _tick;
    hidden var _deviceManager;

    // Set the label of the data field here.
    function initialize(deviceManager) {
        SimpleDataField.initialize();
        label = "My Label";
        _deviceManager = deviceManager;
        _tick = 0;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        _tick++;

        if( _tick > 1 ) {
            _deviceManager.playSample(0x01);
            _tick = 0;
        }

        // See Activity.Info in the documentation for available information.
        return 0.0;
    }

}
