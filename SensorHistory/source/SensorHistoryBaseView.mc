//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.SensorHistory;
using Toybox.Graphics;
using Toybox.WatchUi;

class SensorHistoryBaseView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, "Press Select", Graphics.TEXT_JUSTIFY_CENTER);
    }
}


