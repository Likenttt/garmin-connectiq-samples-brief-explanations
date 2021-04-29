//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class AntDelegate extends WatchUi.BehaviorDelegate {

    var sensor;

    // Initializes AntDelegate
    // @param antSensor, an AntModule.AntSensor type
    function initialize( antSensor ) {
        Toybox.WatchUi.BehaviorDelegate.initialize();
        sensor = antSensor;
        sensor.open();
    }

    // Toggles channel in and out of encryption mode
    function onSelect() {
        if ( sensor.encrypted ) {
            sensor.disableEncryption();
        } else {
            sensor.enableEncryption();
        }
        return true;
    }

    // Returns app back to the menu state
    function onBack() {
        sensor.disableEncryption();
        sensor.release();
        Toybox.WatchUi.popView( Toybox.WatchUi.SLIDE_IMMEDIATE );
        return true;
    }
}