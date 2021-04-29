//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Math;
using Toybox.SensorLogging;
using Toybox.ActivityRecording;
using Toybox.System;

// --- Min duration for the pause feature, [samples]
const NUM_FEATURE = 20;

// --- Min duration between pitches, [samples]
const TIME_PTC = 20;

// --- High level detection threshold
const HIGH_THR = 6.0f;

// --- Lowh level detection threshold
const LOW_THR = -4.2f;

// --- Pause feature threshold: positive and negative ones
const QP_THR = 2.0f;
const QN_THR = -QP_THR;

// --- Pause range: number of samples * 40 ms each
const Q_RANGE = (100 * 40);

var acc_x1 = 0;
var acc_x2 = 0;

var acc_z1 = 0;
var acc_z2 = 0;

var min_x = 0;
var max_x = 0;

var min_z = 0;
var max_z = 0;

// Pitch counter class
class PitchCounterProcess {

    var mX = [0];
    var mY = [0];
    var mZ = [0];
    var mFilter;
    var mPauseCount = 0;
    var mPauseTime = 0;
    var mSkipSample = 25;
    var mPitchCount = 0;
    var mLogger;
    var mSession;

    // Return min of two values
    hidden function min(a, b) {
        if(a < b) {
            return a;
        }
        else {
            return b;
        }
    }

    // Return max of two values
    hidden function max(a, b) {
        if(a > b) {
            return a;
        }
        else {
            return b;
        }
    }

    // Constructor
    function initialize() {
        // initialize FIR filter
        var options = {:coefficients => [ -0.0278f, 0.9444f, -0.0278f ], :gain => 0.001f};
        try {
            mFilter = new Math.FirFilter(options);
            mLogger = new SensorLogging.SensorLogger({:enableAccelerometer => true});
            mSession = ActivityRecording.createSession({:name=>"PitchCounter", :sport=>ActivityRecording.SPORT_GENERIC, :sensorLogger => mLogger});
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }

    // Callback to receive accel data
    function accel_callback(sensorData) {
        mX = mFilter.apply(sensorData.accelerometerData.x);
        mY = sensorData.accelerometerData.y;
        mZ = sensorData.accelerometerData.z;
        onAccelData();
    }

    // Start pitch counter
    function onStart() {
        // initialize accelerometer
        var options = {:period => 1, :sampleRate => 25, :enableAccelerometer => true};
        try {
            Sensor.registerSensorDataListener(method(:accel_callback), options);
            mSession.start();
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }

    // Stop pitch counter
    function onStop() {
        Sensor.unregisterSensorDataListener();
        mSession.stop();
    }

    // Return current pitch count
    function getCount() {
        return mPitchCount;
    }

    // Return current pitch count
    function getSamples() {
        return mLogger.getStats().sampleCount;
    }

    // Return current pitch count
    function getPeriod() {
        return mLogger.getStats().samplePeriod;
    }

    // Process new accel data
    function onAccelData() {
        var cur_acc_x = 0;
        var cur_acc_y = 0;
        var cur_acc_z = 0;
        var time = 0;

        for(var i = 0; i < mX.size(); ++i) {

            cur_acc_x = mX[i];
            cur_acc_y = mY[i];
            cur_acc_z = mZ[i];

            if(mSkipSample > 0) {
                mSkipSample--;
            }
            else {
                // --- Pause feature?
                if((cur_acc_x < QP_THR) && (cur_acc_x > QN_THR) && (cur_acc_y < QP_THR) &&
                   (cur_acc_y > QN_THR) && (cur_acc_z < QP_THR) && (cur_acc_z > QN_THR)) {
                    mPauseCount++;

                    // --- Long enough pause before a pitch?
                    if( mPauseCount > NUM_FEATURE ) {
                        mPauseCount = NUM_FEATURE;
                        mPauseTime = time;
                        }
                    }
                else {
                    mPauseTime = 0;
                }

                min_x = min(min(acc_x1, acc_x2), cur_acc_x);
                max_x = max(max(acc_x1, acc_x2), cur_acc_x);

                min_z = min(min(acc_z1, acc_z2), cur_acc_z);
                max_z = max(max(acc_z1, acc_z2), cur_acc_z);

                // --- Pitching motion?
                if((time - mPauseTime < Q_RANGE) && (((min_z < LOW_THR) && (max_x > HIGH_THR)) || ((min_z < LOW_THR) && (min_x < LOW_THR)))) {

                    // --- A new pitch detected
                    mPitchCount++;

                    // --- Next pitch should be farther in time than TIME_PTC
                    mSkipSample = TIME_PTC;

                    // --- Clear the previous accelerometer values for X and Z channels
                    acc_x2 = 0;
                    acc_x1 = 0;
                    acc_z2 = 0;
                    acc_z1 = 0;

                    // --- Reset pause feature counter
                    mPauseCount = 0;
                    mPauseTime = 0;
                }
                else {
                    // --- Update 3 elements of acceleration for X
                    acc_x2 = acc_x1;
                    acc_x1 = cur_acc_x;

                    // --- Update 3 elements of acceleration for Z
                    acc_z2 = acc_z1;
                    acc_z1 = cur_acc_z;
                }
            }
            time++;
        }
        WatchUi.requestUpdate();
    }
}
