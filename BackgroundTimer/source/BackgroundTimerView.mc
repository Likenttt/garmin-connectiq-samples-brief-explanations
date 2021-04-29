//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Timer;
using Toybox.Background;

const TIMER_DURATION_KEY = 0;
const TIMER_START_TIME_KEY = 1;
const TIMER_PAUSE_TIME_KEY = 2;

const TIMER_DURATION_DEFAULT = (5 * 60);    // 5 minutes

// The main view for the timer application. This displays the
// remaining time on the countdown timer
class BackgroundTimerView extends WatchUi.View
{
    var mTimerDuration;
    var mTimerStartTime;
    var mTimerPauseTime;
    var mUpdateTimer;

    // Initialize variables for this view
    function initialize(backgroundRan) {
        View.initialize();

        // Fetch the persisted values from the object store
        if(backgroundRan == null) {
            mTimerDuration = objectStoreGet(TIMER_DURATION_KEY, TIMER_DURATION_DEFAULT);
            mTimerStartTime = objectStoreGet(TIMER_START_TIME_KEY, null);
            mTimerPauseTime = objectStoreGet(TIMER_PAUSE_TIME_KEY, null);
        } else {
            // If we got an expiration event from the background process
            // when we started up, reset the timer back to the default value.
            mTimerDuration = TIMER_DURATION_DEFAULT;
            mTimerStartTime = null;
            mTimerPauseTime = null;
        }

        // Create our timer object that is used to drive display updates
        mUpdateTimer = new Timer.Timer();

        // If the timer is running, we need to start the timer up now.
        if((mTimerStartTime != null) && (mTimerPauseTime == null)) {
            // Update the display each second.
            mUpdateTimer.start(method(:requestUpdate), 1000, true);
        }
    }

    // Draw the time remaining on the timer to the display
    function onUpdate(dc) {
        var timerString;
        var timerValue;
        var elapsed;
        var minutes;
        var seconds;
        var textColor = Graphics.COLOR_WHITE;

        elapsed = 0;
        if(mTimerStartTime != null) {
            if(mTimerPauseTime != null) {
                // Draw the time in yellow if the timer is paused
                textColor = Graphics.COLOR_YELLOW;
                elapsed = mTimerPauseTime - mTimerStartTime;
            } else {
                elapsed = Time.now().value() - mTimerStartTime;
            }

            if( elapsed >= mTimerDuration ) {
                elapsed = mTimerDuration;
                // Draw the time in red if the timer has expired
                textColor = Graphics.COLOR_RED;
                mTimerPauseTime = Time.now().value();
                mUpdateTimer.stop();
            }
        }

        timerValue = mTimerDuration - elapsed;

        seconds = timerValue % 60;
        minutes = timerValue / 60;

        timerString = minutes + ":" + seconds.format("%02d");

        dc.setColor(textColor, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2,
            Graphics.FONT_NUMBER_THAI_HOT,
            timerString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // If the timer is running, pause it. Otherwise, start it up.
    function startStopTimer() {
        var now = Time.now().value();

        if(mTimerStartTime == null) {
            mTimerStartTime = now;
            mUpdateTimer.start(method(:requestUpdate), 1000, true);
        } else {
            if(mTimerPauseTime == null) {
                mTimerPauseTime = now;
                mUpdateTimer.stop();
                WatchUi.requestUpdate();
            } else if( mTimerPauseTime - mTimerStartTime < mTimerDuration ) {
                mTimerStartTime += (now - mTimerPauseTime);
                mTimerPauseTime = null;
                mUpdateTimer.start(method(:requestUpdate), 1000, true);
            }
        }
    }

    // If the timer is paused, then go ahead and reset it back to the defualt time.
    function resetTimer() {
        if(mTimerPauseTime != null) {
            mTimerStartTime = null;
            mTimerPauseTime = null;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    // Save all the persisted values into the object store. This gets
    // called by the Application base before the application shuts down.
    function saveProperties() {
        objectStorePut(TIMER_DURATION_KEY, mTimerDuration);
        objectStorePut(TIMER_START_TIME_KEY, mTimerStartTime);
        objectStorePut(TIMER_PAUSE_TIME_KEY, mTimerPauseTime);
    }

    // Set up a background event to occur when the timer expires. This
    // will alert the user that the timer has expired even if the
    // application does not remain open.
    function setBackgroundEvent() {
        if((mTimerStartTime != null) && (mTimerPauseTime == null)) {
            var time = new Time.Moment(mTimerStartTime);
            time = time.add(new Time.Duration(mTimerDuration));
            try {
                var info = Time.Gregorian.info(time, Time.FORMAT_SHORT);
                Background.registerForTemporalEvent(time);
            } catch (e instanceof Background.InvalidBackgroundTimeException) {
                // We shouldn't get here because our timer is 5 minutes, which\
                // matches the minimum background time. If we do get here,
                // then it is not possible to set an event at the time when
                // the timer is going to expire because we ran too recently.
            }
        }
    }

    // Delete the background event. We can get rid of this event when the
    // application opens because now we can see exactly when the timer
    // is going to expire. We will set it again when the application closes.
    function deleteBackgroundEvent() {
        Background.deleteTemporalEvent();
    }

    // If we do receive a background event while the appliation is open,
    // go ahead and reset to the default timer.
    function backgroundEvent(data) {
        mTimerDuration = TIMER_DURATION_DEFAULT;
        mTimerStartTime = null;
        mTimerPauseTime = null;
        WatchUi.requestUpdate();
    }

    // This is the callback method we use for our timer. It is
    // only needed to request display updates as the timer counts
    // down so we see the updated time on the display.
    function requestUpdate() {
        WatchUi.requestUpdate();
    }
}
