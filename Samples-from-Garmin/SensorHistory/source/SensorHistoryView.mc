//
// Copyright 2016-2019 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.SensorHistory;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;

class SensorHistoryView extends WatchUi.View {

    hidden var mIndex = 0;

    hidden var mSensorSymbols = [
        :getHeartRateHistory,
        :getTemperatureHistory,
        :getPressureHistory,
        :getElevationHistory,
        :getOxygenSaturationHistory,
    ];

    hidden var mSensorLabel = [
        "Heart Rate",
        "Temperature",
        "Pressure",
        "Elevation",
        "Oxygen Saturation",
    ];

    hidden var mSensorMin = [
        50,
        0,
        50000,
        0,
        80,
    ];

    hidden var mSensorRange = [
        140,
        45,
        60000,
        6000,
        20,
    ];

    function initialize() {
        View.initialize();
    }

    function getIterator() {
        if ( ( Toybox has :SensorHistory ) && ( Toybox.SensorHistory has mSensorSymbols[mIndex] ) ) {
            var getMethod = new Lang.Method( Toybox.SensorHistory, mSensorSymbols[mIndex] );
            return getMethod.invoke( {} );
        }
        return null;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if ( Toybox has :SensorHistory ) {
            var sensorIter = getIterator();
            if( sensorIter != null ) {
                var previous = sensorIter.next();
                var sample = sensorIter.next();
                var x = 15;
                var min = sensorIter.getMin();
                var max = sensorIter.getMax();
                var firstSampleTime = null;
                var lastSampleTime = null;
                var graphBottom = dc.getHeight()/2 + 45;
                var graphHeight = 90;
                var dataOffset = mSensorMin[mIndex].toFloat();
                var dataScale = mSensorRange[mIndex].toFloat();
                var gotValidData = false;
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);

                while( null != sample ) {

                    if( null == firstSampleTime ) {
                        firstSampleTime = previous.when;
                    }

                    if( sample.data != null && previous.data != null ) {
                        lastSampleTime = sample.when;
                        var y1 = graphBottom - (previous.data - dataOffset) / dataScale * graphHeight;
                        var y2 = graphBottom - (sample.data - dataOffset) / dataScale * graphHeight;
                        dc.drawLine(x, y1, x+1, y2);
                        gotValidData = true;
                    }

                    ++x;
                    previous = sample;
                    sample = sensorIter.next();
                }

                if( gotValidData ) {
                    var font = Graphics.FONT_XTINY;
                    var fontHeight = dc.getFontHeight(font);

                    // draw the min/max hr values
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    if( max == null ) {
                        max = "?";
                    } else {
                        max = max.format( "%d" );
                    }
                    if( min == null ) {
                        min = "?";
                    } else {
                        min = min.format( "%d" );
                    }
                    dc.drawText(dc.getWidth() / 2, 1 * fontHeight, font, mSensorLabel[mIndex], Graphics.TEXT_JUSTIFY_CENTER);
                    dc.drawText(dc.getWidth() / 2, 2 * fontHeight, font, "Min: " + min + " Max: " + max, Graphics.TEXT_JUSTIFY_CENTER);

                    // draw the start/end times
                    var startInfo = Gregorian.info(firstSampleTime, Time.FORMAT_SHORT);
                    var endInfo = Gregorian.info(lastSampleTime, Time.FORMAT_SHORT);

                    var startString = Lang.format("$1$/$2$ $3$:$4$:$5$", [
                        startInfo.month.format("%d"),
                        startInfo.day.format("%d"),
                        startInfo.hour.format("%02d"),
                        startInfo.min.format("%02d"),
                        startInfo.sec.format("%02d")
                    ]);

                    var endString = Lang.format("$1$/$2$ $3$:$4$:$5$", [
                        endInfo.month.format("%d"),
                        endInfo.day.format("%d"),
                        endInfo.hour.format("%02d"),
                        endInfo.min.format("%02d"),
                        endInfo.sec.format("%02d")
                    ]);

                    dc.drawText(dc.getWidth()/2, dc.getHeight() - (3 * fontHeight), font, "Start: " + startString, Graphics.TEXT_JUSTIFY_CENTER);
                    dc.drawText(dc.getWidth()/2, dc.getHeight() - (2 * fontHeight), font, "End: " + endString, Graphics.TEXT_JUSTIFY_CENTER);
                }
                else {
                    var message = mSensorLabel[mIndex] + "\nNo data available.";
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                    dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, message, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
                }
            }
            else {
                var message = mSensorLabel[mIndex] + "\nSensor not available";
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, message, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
            }

        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            var message = "Sensor History\nNot Supported";
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, message, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
        }
    }

    function nextSensor() {
        mIndex += 1;
        mIndex %= mSensorSymbols.size();
    }

    function previousSensor() {
        mIndex += mSensorSymbols.size() - 1;
        mIndex %= mSensorSymbols.size();
    }
}
