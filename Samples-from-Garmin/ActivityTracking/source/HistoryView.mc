//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.ActivityMonitor;

class HistoryView extends WatchUi.View {

    // Constructor
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.HistoryLayout(dc));
    }

    // Handle the update event
    function onUpdate(dc) {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var actHistArray = ActivityMonitor.getHistory();
        var padding = 5;
        var string = "";
        var fontHeight = Graphics.getFontHeight(Graphics.FONT_TINY);

        if (null != actHistArray && actHistArray.size() > 0) {
            // Loop through array of history items
            for (var i = 0; i < actHistArray.size(); i += 1) {
                dc.drawText(padding, padding + fontHeight * (i+2), Graphics.FONT_TINY, (i+1).toString(), Graphics.TEXT_JUSTIFY_LEFT);
                // Validate that each element is non-null
                if (null != actHistArray[i] && null != actHistArray[i].steps) {
                    string = actHistArray[i].steps.toString() + " / " + actHistArray[i].stepGoal.toString();
                    dc.drawText(dc.getWidth() / 2, padding + fontHeight * (i+2), Graphics.FONT_TINY, string, Graphics.TEXT_JUSTIFY_CENTER);
                    // Check if the device supports floors climbed info and validate that element is non-null
                    if (actHistArray[i] has :floorsClimbed && null != actHistArray[i].floorsClimbed) {
                        dc.drawText(dc.getWidth(), padding + fontHeight * (i+2), Graphics.FONT_TINY, actHistArray[i].floorsClimbed.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
                    }
                }
            }
        }
    }
}