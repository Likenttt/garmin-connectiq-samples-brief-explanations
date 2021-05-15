//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;

const CURR_HEMO_CONC_FIELD_ID = 0;
const LAP_HEMO_CONC_FIELD_ID = 1;
const AVG_HEMO_CONC_FIELD_ID = 2;
const CURR_HEMO_PERCENT_FIELD_ID = 3;
const LAP_HEMO_PERCENT_FIELD_ID = 4;
const AVG_HEMO_PERCENT_FIELD_ID = 5;

class MO2FitContributor {
    // Variables for computing averages
    hidden var mHCLapAverage = 0.0;
    hidden var mHCSessionAverage = 0.0;
    hidden var mHPLapAverage = 0.0;
    hidden var mHPSessionAverage = 0.0;
    hidden var mLapRecordCount = 0;
    hidden var mSessionRecordCount = 0;
    hidden var mTimerRunning = false;

    // FIT Contributions variables
    hidden var mCurrentHCField = null;
    hidden var mLapAverageHCField = null;
    hidden var mSessionAverageHCField = null;
    hidden var mCurrentHPField = null;
    hidden var mLapAverageHPField = null;
    hidden var mSessionAverageHPField = null;

    // Constructor
    function initialize(dataField) {
        mCurrentHCField = dataField.createField("currHemoConc", CURR_HEMO_CONC_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>54, :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"g/dl" });
        mLapAverageHCField = dataField.createField("lapHemoConc", LAP_HEMO_CONC_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>84, :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"g/dl" });
        mSessionAverageHCField = dataField.createField("avgHemoConc", AVG_HEMO_CONC_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>95, :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"g/dl" });

        mCurrentHPField = dataField.createField("currHemoPerc", CURR_HEMO_PERCENT_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>57, :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"%" });
        mLapAverageHPField = dataField.createField("lapHemoConc", LAP_HEMO_PERCENT_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>87, :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"%" });
        mSessionAverageHPField = dataField.createField("avgHemoConc", AVG_HEMO_PERCENT_FIELD_ID, FitContributor.DATA_TYPE_UINT16, { :nativeNum=>98, :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"%" });

        mCurrentHCField.setData(0);
        mLapAverageHCField.setData(0);
        mSessionAverageHCField.setData(0);

        mCurrentHPField.setData(0);
        mLapAverageHPField.setData(0);
        mSessionAverageHPField.setData(0);

    }

    function compute(sensor) {
        if( sensor != null ) {
            var HemoConc = sensor.data.totalHemoConcentration;
            var HemoPerc = sensor.data.currentHemoPercent;

            // Hemoglobin Concentration is stored in 1/100ths g/dL fixed point
            mCurrentHCField.setData( toFixed(HemoConc, 100) );
            // Saturated Hemoglobin Percent is stored in 1/10ths % fixed point
            mCurrentHPField.setData( toFixed(HemoPerc, 10)  );

            if( mTimerRunning ) {
                // Update lap/session data and record counts
                mLapRecordCount++;
                mSessionRecordCount++;
                mHCLapAverage += HemoConc;
                mHCSessionAverage += HemoConc;
                mHPLapAverage += HemoPerc;
                mHPSessionAverage += HemoPerc;

                // Updatea lap/session FIT Contributions
                mLapAverageHCField.setData( toFixed(mHCLapAverage/mLapRecordCount, 100) );
                mSessionAverageHCField.setData( toFixed(mHCSessionAverage/mSessionRecordCount, 100) );

                mLapAverageHPField.setData( toFixed(mHPLapAverage/mLapRecordCount, 10) );
                mSessionAverageHPField.setData( toFixed(mHPSessionAverage/mSessionRecordCount, 10) );
            }
        }
    }

    function toFixed(value, scale) {
        return ((value * scale) + 0.5).toNumber();
    }

    function setTimerRunning(state) {
        mTimerRunning = state;
    }

    function onTimerLap() {
        mLapRecordCount = 0;
        mHCLapAverage = 0.0;
        mHPLapAverage = 0.0;
    }

    function onTimerReset() {
        mSessionRecordCount = 0;
        mHCSessionAverage = 0.0;
        mHPSessionAverage = 0.0;
    }

}