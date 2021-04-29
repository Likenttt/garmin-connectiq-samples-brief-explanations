//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.Graphics;
using Toybox.System;

class FieldTimerEventsView extends WatchUi.DataField
{
    enum
    {
        STOPPED,
        PAUSED,
        RUNNING
    }

    hidden var mLapNumber = 0;
    hidden var mTimerState = STOPPED;
    hidden var mLapCertainty = "";

    //! constructor
    function initialize()
    {
        DataField.initialize();

        var info = Activity.getActivityInfo();

        //! If the activity timer is greater than 0, then we don't know the lap or timer state.
        if( (info.timerTime != null) && (info.timerTime > 0) )
        {
            mLapCertainty = "?";
        }
    }

    //! This is called each time a lap is created, so increment the lap number.
    function onTimerLap()
    {
        mLapNumber++;
    }

    //! This is called each time a Workout Step finishes. Increment the lap number for these also
    function onWorkoutStepComplete()
    {
        mLapNumber++;
    }

    //! This is called each time a Multisport activity advances to the next leg. Reset the laps
    function onNextMultisportLeg()
    {
        mLapNumber = 0;
    }

    //! The timer was started, so set the state to running.
    function onTimerStart()
    {
        mTimerState = RUNNING;
    }

    //! The timer was stopped, so set the state to stopped.
    function onTimerStop()
    {
        mTimerState = STOPPED;
    }

    //! The timer was started, so set the state to running.
    function onTimerPause()
    {
        mTimerState = PAUSED;
    }

    //! The timer was stopped, so set the state to stopped.
    function onTimerResume()
    {
        mTimerState = RUNNING;
    }

    //! The timer was reeset, so reset all our tracking variables
    function onTimerReset()
    {
        mLapNumber = 0;
        mTimerState = STOPPED;
        mLapCertainty = "";
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info)
    {
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc)
    {
        // Timer events are supported so update the view with the
        // current timer/lap information.
        if (WatchUi.DataField has :onTimerLap) {
            var dataColor;
            var lapString;

            //! Select text color based on timer state.
            if( mTimerState == null )
            {
                dataColor = Graphics.COLOR_BLACK;
            }
            else if( mTimerState == RUNNING )
            {
                dataColor = Graphics.COLOR_GREEN;
            }
            else if( mTimerState == PAUSED )
            {
                dataColor = Graphics.COLOR_YELLOW;
            }
            else
            {
                dataColor = Graphics.COLOR_RED;
            }

            dc.setColor(dataColor, Graphics.COLOR_WHITE);
            dc.clear();

            //! Construct the lap string.
            lapString = mLapNumber.format("%d") + mLapCertainty;

            //! Draw the lap number
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_NUMBER_MEDIUM, lapString, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));

        // Timer events are not supported so show a message letting
        // the user know that.
        } else {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            dc.clear();

            var message = "Timer Events\nNot Supported";
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, message, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
        }
    }
}
