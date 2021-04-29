//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

class CommandView extends WatchUi.View {
    hidden var mIcon;
    hidden var mIndex;
    hidden var mIndicator;
    hidden var mSensor;

    function initialize(sensor, index) {
        WatchUi.View.initialize();

        mIndex = index;

        mIndicator = new PageIndicator();
        var size = 4;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = mIndicator.ALIGN_BOTTOM_RIGHT;
        mIndicator.setup(size, selected, notSelected, alignment, 0);

        mSensor = sensor;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 30;
        var font;
        var text;
        var fWidth;

        text = "Notifications";
        font = Graphics.FONT_LARGE;
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2 - fWidth/2, margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        text = "UTC Time";
        font = Graphics.FONT_MEDIUM;
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2 - fWidth/2, height/3 + margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        if (mSensor.data.utcTimeSet) {
            text = "Required";
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 - fWidth/2, height*2/3, font, text, Graphics.TEXT_JUSTIFY_LEFT);

            text = "Tap to set";
            font = Graphics.FONT_SMALL;
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 - fWidth/2, height*2/3 + margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            text = "Not Required";
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 - fWidth/2, height*2/3, font, text, Graphics.TEXT_JUSTIFY_LEFT);
        }

        // Draw page indicator
        mIndicator.draw(dc, mIndex);
    }

}