//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;

module NumberPickerConstants {
    enum {
        DISPLAY_FLOAT,
        DISPLAY_INT,
        DISPLAY_DURATION
    }
}

var testValf = 1000f;
var testVali = 1;
var modeLabel = "";
var fieldTypeToDisplay = null;
var count = 0;
var dur = null;

class NPDf extends WatchUi.NumberPickerDelegate {
    function initialize() {
        NumberPickerDelegate.initialize();
    }

    function onNumberPicked(value) {
        testValf = value;
    }
}

class NPDi extends WatchUi.NumberPickerDelegate {
    function initialize() {
        NumberPickerDelegate.initialize();
    }

    function onNumberPicked(value) {
        testVali = value;
    }
}

class NPDd extends WatchUi.NumberPickerDelegate {
    function initialize() {
        NumberPickerDelegate.initialize();
    }

    function onNumberPicked(value) {
        dur = value;
    }
}

class BaseInputDelegate extends WatchUi.BehaviorDelegate {
    var np;
    var npi;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        onMenu();
    }

    function onMenu() {
            var value;
            if(count == 0) {
                modeLabel = "Distance";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_FLOAT;
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_DISTANCE, testValf);
                WatchUi.pushView(np, new NPDf(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 1) {
                modeLabel = "Duration HH:MM:SS";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_DURATION;
                // intentionally larger than max
                value = Gregorian.duration({:hours=>9, :minutes=>8, :seconds=>10});
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME, value);
                WatchUi.pushView(np, new NPDd(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 2) {
                modeLabel = "Duration MM:SS";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_DURATION;
                value = Gregorian.duration({:hours=>1, :minutes=>8, :seconds=>10});
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME_MIN_SEC, value);
                WatchUi.pushView(np, new NPDd(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 3) {
                modeLabel = "Time Of Day";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_DURATION;
                value = Gregorian.duration({:hours=>23, :minutes=>8, :seconds=>10});
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME_OF_DAY, value);
                WatchUi.pushView(np, new NPDd(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 4) {
                modeLabel = "Weight";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_FLOAT;
                value = 454;
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_WEIGHT, value);
                WatchUi.pushView(np, new NPDf(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 5) {
                modeLabel = "Height";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_FLOAT;
                value = 2;
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_HEIGHT, value);
                WatchUi.pushView(np, new NPDf(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 6) {
                modeLabel = "Calories";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_INT;
                value = 200;
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_CALORIES, value);
                WatchUi.pushView(np, new NPDi(), WatchUi.SLIDE_IMMEDIATE);
                count = count + 1;
            }
            else if(count == 7) {
                modeLabel = "Birth Year";
                fieldTypeToDisplay = NumberPickerConstants.DISPLAY_INT;
                value = 1980;
                np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_BIRTH_YEAR, value);
                WatchUi.pushView(np, new NPDi(), WatchUi.SLIDE_IMMEDIATE);
                count = 0;
            }
            return true;

        return false;
    }

    function onNextPage() {
    }
}

class NumberPickerView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        onUpdate(dc);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var modeLabelFontHeight = dc.getFontHeight(Graphics.FONT_SMALL);
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var labelLocY = centerY - 10;
        var valueLocY = labelLocY + modeLabelFontHeight + 5;

            dc.drawText(centerX, (centerY - 50), Graphics.FONT_SMALL, "Press Menu Or Select", Graphics.TEXT_JUSTIFY_CENTER);
            if(fieldTypeToDisplay != null) {

                dc.drawText(centerX, labelLocY, Graphics.FONT_SMALL, modeLabel, Graphics.TEXT_JUSTIFY_CENTER);

                if(fieldTypeToDisplay == NumberPickerConstants.DISPLAY_FLOAT) {
                   dc.drawText(centerX, valueLocY, Graphics.FONT_SMALL, testValf.toString(), Graphics.TEXT_JUSTIFY_CENTER);
                }

                else if(fieldTypeToDisplay == NumberPickerConstants.DISPLAY_INT) {
                   dc.drawText(centerX, valueLocY, Graphics.FONT_SMALL, testVali.toString(), Graphics.TEXT_JUSTIFY_CENTER);
                }

                else if(fieldTypeToDisplay == NumberPickerConstants.DISPLAY_DURATION) {
                    if( dur != null ) {
                        dc.drawText(centerX, valueLocY, Graphics.FONT_SMALL, dur.value().toString(), Graphics.TEXT_JUSTIFY_CENTER);
                    }
                }
            }
        
    }
}

