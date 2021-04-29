//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.System;
using Toybox.WatchUi;

class SensorHistoryDelegate extends WatchUi.BehaviorDelegate {

    var mView;

    function initialize( view ) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onNextPage() {
        mView.nextSensor();
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() {
        mView.previousSensor();
        WatchUi.requestUpdate();
        return true;
    }
}