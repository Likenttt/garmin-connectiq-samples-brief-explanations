//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Time;
using Toybox.Communications;

// This is the primary entry point of the application.
class AnalogWatch extends Application.AppBase
{
    var temperature = null;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }
    // This method runs each time the main application starts.
    function getInitialView() {
        if( Toybox.WatchUi has :WatchFaceDelegate ) {
            return [new AnalogView(), new AnalogDelegate()];
        } else {
            return [new AnalogView()];
        }
    }

    // This method runs when a goal is triggered and the goal view is started.
    function getGoalView(goal) {
        return [new AnalogGoalView(goal)];
    }

    function getSettingsView() {
        return [new AnalogSettingsView(), new AnalogSettingsDelegate()];
    }
}
