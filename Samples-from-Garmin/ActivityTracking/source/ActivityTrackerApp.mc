//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.System;

var screenShape;

// This is the primary start point for a ConnectIQ application
class ActivityTrackerApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        screenShape = System.getDeviceSettings().screenShape;
        return false;
    }

    function getInitialView() {
        return [new ActivityTrackerView(), new ActivityTrackerDelegate()];
    }

    function onStop(state) {
        return false;
    }
}
