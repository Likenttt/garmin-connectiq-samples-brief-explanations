//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Application;
using Toybox.System;
using Toybox.Time;
using Toybox.Activity;
using Toybox.Graphics;

const BORDER_PAD = 4;
const UNITS_SPACING = 2;

var fonts = [Graphics.FONT_XTINY,Graphics.FONT_TINY,Graphics.FONT_SMALL,Graphics.FONT_MEDIUM,Graphics.FONT_LARGE,
             Graphics.FONT_NUMBER_MILD,Graphics.FONT_NUMBER_MEDIUM,Graphics.FONT_NUMBER_HOT,Graphics.FONT_NUMBER_THAI_HOT];


class MO2Field extends WatchUi.DataField {

    // Label Variables
    hidden var mLabelString = "M02 Data";
    hidden var mLabelFont = Graphics.FONT_SMALL;
    hidden var mLabelX;
    hidden var mLabelY = 10; // Does not change

    // Hemoglobin Concnetration variables
    hidden var mHCUnitsString = "g/dl";
    hidden var mHCUnitsWidth;
    hidden var mHCX;
    hidden var mHCY;
    hidden var mHCMaxWidth;

    // Hemoglobin Percentage variables
    hidden var mHPUnitsString = "%";
    hidden var mHPUnitsWidth;
    hidden var mHPX;
    hidden var mHPY;
    hidden var mHPMaxWidth;

    // Fit Contributor
    hidden var mFitContributor;

    // Font values
    hidden var mDataFont;
    hidden var mDataFontAscent;
    hidden var mUnitsFont = Graphics.FONT_TINY;

    // field separator line
    hidden var separator;

    hidden var mSensor;
    hidden var xCenter;
    hidden var yCenter;

    // Constructor
    function initialize(sensor) {
        DataField.initialize();
        mSensor = sensor;
        mFitContributor = new MO2FitContributor(self);
    }

    function compute(info) {
        mFitContributor.compute(mSensor);
    }

    function onLayout(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var top = mLabelY + Graphics.getFontAscent(mLabelFont) + BORDER_PAD;

        var vLayoutWidth;
        var vLayoutHeight;
        var vLayoutFontIdx;

        var hLayoutWidth;
        var hLayoutHeight;
        var hLayoutFontIdx;

        // Units width does not change, compute only once
        if (mHCUnitsWidth == null) {
            mHCUnitsWidth = dc.getTextWidthInPixels(mHCUnitsString, mUnitsFont) + UNITS_SPACING;
        }
        if (mHPUnitsWidth == null) {
            mHPUnitsWidth = dc.getTextWidthInPixels(mHPUnitsString, mUnitsFont) + UNITS_SPACING;
        }

        // Center the field label
        mLabelX = width / 2;

        // Compute data width/height for both layouts
        hLayoutWidth = (width - (4 * BORDER_PAD) ) / 2;
        hLayoutHeight = height - (2 * BORDER_PAD) - top;
        hLayoutFontIdx = selectFont(dc, (hLayoutWidth - mHCUnitsWidth), hLayoutHeight);

        vLayoutWidth = width - (2 * BORDER_PAD);
        vLayoutHeight = (height - top - (3 * BORDER_PAD)) / 2;
        vLayoutFontIdx = selectFont(dc, (vLayoutWidth - mHCUnitsWidth), vLayoutHeight);

        //Use the horizontal layout if it supports a larger font
        if (hLayoutFontIdx > vLayoutFontIdx) {
            mDataFont = fonts[hLayoutFontIdx];
            mDataFontAscent = Graphics.getFontAscent(mDataFont);

            //Compute the draw location of the Hemoglobin Concentration data
            mHCX = BORDER_PAD + (hLayoutWidth / 2) - (mHCUnitsWidth / 2);
            mHCY = (height - top) / 2 + top - (mDataFontAscent / 2);

            //Compute the center of the Hemo Percentage data
            mHPX = (2 * BORDER_PAD) + hLayoutWidth + (hLayoutWidth / 2) - (mHPUnitsWidth / 2);
            mHPY = mHCY;

            //Use a separator line for horizontal layout
            separator = [(width / 2), top + BORDER_PAD, (width / 2), height - BORDER_PAD];
        } else {
            // otherwise, use the veritical layout
            mDataFont = fonts[vLayoutFontIdx];
            mDataFontAscent = Graphics.getFontAscent(mDataFont);

            mHCX = BORDER_PAD + (vLayoutWidth / 2) - (mHCUnitsWidth / 2);
            mHCY = top + BORDER_PAD + (vLayoutHeight / 2) - (mDataFontAscent / 2);

            mHPX = BORDER_PAD + (vLayoutWidth / 2) - (mHPUnitsWidth / 2);
            mHPY = mHCY + BORDER_PAD + vLayoutHeight;

            // Do not use a separator line for vertical layout
            separator = null;
        }

        xCenter = dc.getWidth() / 2;
        yCenter = dc.getHeight() / 2;
    }

    function selectFont(dc, width, height) {
        var testString = "88.88"; //Dummy string to test data width
        var fontIdx;
        var dimensions;

        //Search through fonts from biggest to smallest
        for (fontIdx = (fonts.size() - 1); fontIdx > 0; fontIdx--) {
            dimensions = dc.getTextDimensions(testString, fonts[fontIdx]);
            if ((dimensions[0] <= width) && (dimensions[1] <= height)) {
                //If this font fits, it is the biggest one that does
                break;
            }
        }

        return fontIdx;
    }

    // Handle the update event
    function onUpdate(dc) {
        var bgColor = getBackgroundColor();
        var fgColor = Graphics.COLOR_WHITE;

        if (bgColor == Graphics.COLOR_WHITE) {
            fgColor = Graphics.COLOR_BLACK;
        }

        dc.setColor(fgColor, bgColor);
        dc.clear();

        dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);

        //Draw the field label
        dc.drawText(mLabelX, mLabelY, mLabelFont, mLabelString, Graphics.TEXT_JUSTIFY_CENTER);

        // Update status
        if (mSensor == null) {
            dc.drawText(xCenter, yCenter, Graphics.FONT_MEDIUM, "No Channel!", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (true == mSensor.searching) {
            dc.drawText(xCenter, yCenter, Graphics.FONT_MEDIUM, "Searching...", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            var x;
            var y;
            var HemoConc = mSensor.data.totalHemoConcentration.format("%.2f");
            var HemoPerc = mSensor.data.currentHemoPercent.format("%.1f");

            //Draw Hemoglobin Concnetration
            dc.drawText(mHCX, mHCY, mDataFont, HemoConc, Graphics.TEXT_JUSTIFY_CENTER);
            x = mHCX + (dc.getTextWidthInPixels(HemoConc, mDataFont) / 2) + UNITS_SPACING;
            y = mHCY + mDataFontAscent - Graphics.getFontAscent(mUnitsFont);
            dc.drawText(x, y, mUnitsFont, mHCUnitsString, Graphics.TEXT_JUSTIFY_LEFT);

            //Draw Hemoglobin Percentage
            dc.drawText(mHPX, mHPY, mDataFont, HemoPerc, Graphics.TEXT_JUSTIFY_CENTER);
            x = mHPX + (dc.getTextWidthInPixels(HemoPerc, mDataFont) / 2) + UNITS_SPACING;
            y = mHPY + mDataFontAscent - Graphics.getFontAscent(mUnitsFont);
            dc.drawText(x, y, mUnitsFont, mHPUnitsString, Graphics.TEXT_JUSTIFY_LEFT);

            if (separator != null) {
                dc.setColor(fgColor, fgColor);
                dc.drawLine(separator[0], separator[1], separator[2], separator[3]);
            }
        }
    }

    function onTimerStart() {
        mFitContributor.setTimerRunning( true );
    }

    function onTimerStop() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerPause() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerResume() {
        mFitContributor.setTimerRunning( true );
    }

    function onTimerLap() {
        mFitContributor.onTimerLap();
    }

    function onTimerReset() {
        mFitContributor.onTimerReset();
    }

}

class MoxyField extends Application.AppBase {
    var mSensor;

    function initialize() {
        AppBase.initialize();
    }

    // onStart is the primary start point for a Monkeybrains application
    function onStart(state) {
        try {
            //Create the sensor object and open it
            mSensor = new MO2Sensor();
            mSensor.open();
        } catch(e instanceof Ant.UnableToAcquireChannelException) {
            System.println(e.getErrorMessage());
            mSensor = null;
        }
    }

    function getInitialView() {
        return [new MO2Field(mSensor)];
    }

    function onStop(state) {
        mSensor.closeSensor();
        return false;
    }
}
