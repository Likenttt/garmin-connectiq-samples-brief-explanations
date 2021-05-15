//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Application;

class AttentionDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }

    // Handle key  events
    function onKey(evt) {
        var app = Application.getApp();
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            app.mainView.incIndex();
        } else if (WatchUi.KEY_UP == key) {
            app.mainView.decIndex();
        } else if (WatchUi.KEY_ENTER == key) {
            app.mainView.action();
        } else if (WatchUi.KEY_START == key) {
            app.mainView.action();
        } else {
            return false;
        }
        WatchUi.requestUpdate();
        return true;
    }

    // Handle touchscreen taps
    function onTap(evt) {
        var app = Application.getApp();
        if (WatchUi.CLICK_TYPE_TAP == evt.getType()) {
            var coords = evt.getCoordinates();
            app.mainView.setIndexFromYVal(coords[1]);
            WatchUi.requestUpdate();
            app.mainView.action();
        }
        return true;
    }

    // Handle enter events
    function onSelect() {
        Application.getApp().mainView.action();
    }

    // Handle swipe events
    function onSwipe(evt) {
        var app = Application.getApp();
        var direction = evt.getDirection();
        if (WatchUi.SWIPE_DOWN == direction) {
            app.mainView.incIndex();
        } else if (WatchUi.SWIPE_UP == direction) {
            app.mainView.decIndex();
        } else if (WatchUi.SWIPE_LEFT == direction) {
            app.mainView.decIndex();
        } else if (WatchUi.SWIPE_RIGHT == direction) {
            app.mainView.incIndex();
        }
        WatchUi.requestUpdate();
    }

}
