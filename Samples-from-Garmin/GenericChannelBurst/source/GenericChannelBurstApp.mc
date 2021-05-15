//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;

class GenericChannelBurstApp extends Application.AppBase {
    const UI_UPDATE_PERIOD_MS = 250;

    hidden var _channelManager;
    hidden var _uiTimer;

    //! Constructor.
    function initialize() {
        AppBase.initialize();
    }

    //! Called on application start up
    function onStart(state) {
        _channelManager = new BurstChannelManager();
        _uiTimer = new Timer.Timer();
        _uiTimer.start(method(:updateScreen), UI_UPDATE_PERIOD_MS, true);
    }

    //! Called when your application is exiting
    function onStop(state) {
        _uiTimer.stop();
    }

    //! Returns the initial view of the application
    function getInitialView() {
        return [ new GenericChannelBurstView(_channelManager), new GenericChannelBurstDelegate(_channelManager) ];
    }

    //! A wrapper function to allow the timer to request a screen update
    function updateScreen() {
        WatchUi.requestUpdate();
    }
}
