//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.ActivityMonitor;
using Toybox.Timer;

class ActivityTrackerView extends WatchUi.View {

    var timer;

    // Constructor
    function initialize() {
        View.initialize();

        // Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        timer = new Timer.Timer();
    }

    function onShow() {
        timer.start(method(:onTimer), 1000, true);
    }

    function onHide() {
        timer.stop();
    }

    // Handle the update event
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var info = ActivityMonitor.getInfo();

        if (info has :stepGoal) {
            if (info.stepGoal == 0) {
                info.stepGoal = 5000;
            }
            var stepsPercent = info.steps.toFloat() / info.stepGoal;
            drawBar(dc, "Steps", dc.getHeight() / 4, stepsPercent, Graphics.COLOR_GREEN);
        }
        else {
            dc.drawText(20, dc.getHeight() / 4, Graphics.FONT_SMALL, "Steps not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }

        if (info has :floorsClimbed && info has :floorsClimbedGoal) {
            if (info.floorsClimbedGoal == 0) {
                info.floorsClimbedGoal = 10;
            }
            var floorsPercent = info.floorsClimbed.toFloat() / info.floorsClimbedGoal;
            drawBar(dc, "Floors", dc.getHeight() / 2, floorsPercent, Graphics.COLOR_BLUE);
        }
        else {
            dc.drawText(20, dc.getHeight() / 2, Graphics.FONT_SMALL, "Floors not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }

        if (info has :activeMinutesWeek && info has :activeMinutesWeekGoal) {
            if (info.activeMinutesWeekGoal == 0) {
                info.activeMinutesWeekGoal = 150;
            }
            var activePercent = info.activeMinutesWeek.total.toFloat() / info.activeMinutesWeekGoal;
            drawBar(dc, "Minutes", dc.getHeight() / 4 * 3, activePercent, Graphics.COLOR_ORANGE);
        }
        else {
            dc.drawText(20, dc.getHeight() / 4 * 3, Graphics.FONT_SMALL, "Minutes not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function drawBar(dc, string, y, percent, color) {
        var width = dc.getWidth() / 5 * 4;
        var x = dc.getWidth() / 10;

        if (percent > 1) {
            percent = 1.0;
        }

        dc.setColor(color, color);
        dc.fillRectangle(x, y, width * percent, 10);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, width, 10);
        dc.setPenWidth(1);

        var font = Graphics.FONT_SMALL;

        dc.drawText(x, y - Graphics.getFontHeight(font) - 3, font, string, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function onTimer() {
        //Kick the display update
        WatchUi.requestUpdate();
    }
}
