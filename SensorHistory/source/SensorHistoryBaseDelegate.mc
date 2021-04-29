//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.System;
using Toybox.WatchUi;

class SensorHistoryBaseDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        var view = new SensorHistoryView();
        var delegate = new SensorHistoryDelegate(view);
        pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}