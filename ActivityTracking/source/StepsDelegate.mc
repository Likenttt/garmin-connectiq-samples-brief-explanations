//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class StepsDelegate extends WatchUi.BehaviorDelegate {
    // Constructor
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onNextPage() {
        WatchUi.switchToView(new HistoryView(), new HistoryDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new HistoryView(), new HistoryDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}