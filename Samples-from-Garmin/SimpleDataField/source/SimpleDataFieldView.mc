//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

class DataFieldAlertView extends WatchUi.DataFieldAlert{

    function initialize() {
        DataFieldAlert.initialize();
    }

    function onUpdate(dc){
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Alert: 10 sec elapsed", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class DataField extends WatchUi.SimpleDataField {
    const METERS_TO_MILES = 0.000621371;
    const MILLISECONDS_TO_SECONDS = 0.001;

    var counter;
    var alertDisplayed;

    // Constructor
    function initialize() {
        SimpleDataField.initialize();
        label = "HR, Dist, Timer";
        counter = 0;
        alertDisplayed = false;
    }

    // Handle the update event
    function compute(info) {
                            WatchUi.DataField.showAlert(new DataFieldAlertView());
    
        var value_picked = "--";

        // Cycle between heart rate (int), distance (float), and stopwatch time (Duration)
        if(counter == 0) {
            if(info.currentHeartRate != null) {
                value_picked = info.currentHeartRate;
            }
        }
        if(counter == 1) {
            if(info.elapsedDistance != null) {
                value_picked = info.elapsedDistance * METERS_TO_MILES;
            }
        }
        if(counter == 2) {
            if(info.timerTime != null) {
                var options = {:seconds => info.timerTime *  MILLISECONDS_TO_SECONDS};
                value_picked = Time.Gregorian.duration(options);

                if(WatchUi.DataField has :showAlert) {
                    if(((info.timerTime * MILLISECONDS_TO_SECONDS) > 10.000f) && (alertDisplayed == false)) {
                        WatchUi.DataField.showAlert(new DataFieldAlertView());
                        alertDisplayed = true;
                    }
                }
            }
        }

        counter += 1;
        if(counter > 2) {
            counter = 0;
        }

        return value_picked;
    }
}