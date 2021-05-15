//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;

// This implements a Goal View for the Analog face
class AnalogGoalView extends WatchUi.View {
    var goalString;
    var screenShape;

    // Goal views are provided a Application.GOAL_TYPE_? enumeration value as an argument
    // Use this value to initialize the string to display on the goal view.
    function initialize(goal) {
        View.initialize();
        screenShape = System.getDeviceSettings().screenShape;

        goalString = "GOAL!";

        if(goal == Application.GOAL_TYPE_STEPS) {
            goalString = "STEPS " + goalString;
        }
        else if(goal == Application.GOAL_TYPE_FLOORS_CLIMBED) {
            goalString = "STAIRS " + goalString;
        }
        else if(goal == Application.GOAL_TYPE_ACTIVE_MINUTES) {
            goalString = "ACTIVE " + goalString;
        }
    }

    function onLayout(dc) {
        //Clear any clip that may currently be set by the partial update
        dc.clearClip();
    }

    // Update the clock face graphics during update
    function onUpdate(dc) {
        var width;
        var height;
        var clockTime = System.getClockTime();

        width = dc.getWidth();
        height = dc.getHeight();

        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_LONG);

        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);

        // Fill the screen with a black rectangle
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, width, height);

        // Fill the top right half of the screen with a grey triangle
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.fillPolygon([[0, 0], [width, 0], [width, height], [0, 0]]);

        // Draw the date
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (height / 4), Graphics.FONT_MEDIUM, dateStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw the Goal String
        dc.drawText(width / 2, (height / 2), Graphics.FONT_MEDIUM, goalString, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
