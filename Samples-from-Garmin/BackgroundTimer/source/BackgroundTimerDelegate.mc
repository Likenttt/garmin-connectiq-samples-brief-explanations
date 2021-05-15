//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

// The primary input handling delegate for the background timer.
class BackgroundTimerDelegate extends WatchUi.BehaviorDelegate
{
    var mParentView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mParentView = view;
    }

    // Call the start stop timer method on the parent view
    // when the select action occurs (start/stop button on most products)
    function onSelect() {
        mParentView.startStopTimer();
        return true;
    }

    // Call the reset method on the parent view when the
    // back action occurs.
    function onBack() {
        return mParentView.resetTimer();
    }
}