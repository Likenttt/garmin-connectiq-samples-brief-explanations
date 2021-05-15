//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

var timer1;
var timer2;
var timer3;
var count1 = 0;
var count2 = 0;
var count3 = 0;

class TimerView extends WatchUi.View {

    function initialize() {
        WatchUi.View.initialize();
    }

    function callback1() {
        count1 += 1;
        WatchUi.requestUpdate();
    }

    function callback2() {
        count2 += 1;
        WatchUi.requestUpdate();
    }

    function callback3() {
        count3 += 1;
        WatchUi.requestUpdate();
    }

    function onLayout(dc) {
        timer1 = new Timer.Timer();
        timer2 = new Timer.Timer();
        timer3 = new Timer.Timer();

        timer1.start(method(:callback1), 500, true);
        timer2.start(method(:callback2), 1000, true);
        timer3.start(method(:callback3), 2000, true);
    }

    function onUpdate(dc) {
        var string;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        string = "Count: " + count1;
        dc.drawText(40, (dc.getHeight() / 2) - 30, Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_LEFT);
        string = "Count: " + count2;
        dc.drawText(40, (dc.getHeight() / 2), Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_LEFT);
        string = "Count: " + count3;
        dc.drawText(40, (dc.getHeight() / 2) + 30, Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_LEFT);
    }

}
