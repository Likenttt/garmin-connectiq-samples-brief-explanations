//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application.Storage;

class AnalogSettingsView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.clearClip();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Press Menu \nfor settings", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class AnalogSettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new AnalogSettingsMenu();
        var boolean = Storage.getValue(1) ? true : false;
        menu.addItem(new WatchUi.ToggleMenuItem("Settings1", null, 1, boolean, null));

        boolean = Storage.getValue(2) ? true : false;
        menu.addItem(new WatchUi.ToggleMenuItem("Settings2", null, 2, boolean, null));

        boolean = Storage.getValue(3) ? true : false;
        menu.addItem(new WatchUi.ToggleMenuItem("Settings3", null, 3, boolean, null));

        boolean = Storage.getValue(4) ? true : false;
        menu.addItem(new WatchUi.ToggleMenuItem("Settings4", null, 4, boolean, null));

        WatchUi.pushView( menu, new AnalogSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}

