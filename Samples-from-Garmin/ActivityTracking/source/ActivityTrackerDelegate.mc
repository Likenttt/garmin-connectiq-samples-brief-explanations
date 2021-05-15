//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class ActivityTrackerDelegate extends WatchUi.BehaviorDelegate {

    // Constructor
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        WatchUi.pushView(new StepsView(), new StepsDelegate(), WatchUi.SLIDE_LEFT);
    }
}