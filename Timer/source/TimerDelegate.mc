//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class InputDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    function onMenu() {
        timer1.stop();
        return true;
    }
}