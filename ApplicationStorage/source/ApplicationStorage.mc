//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Application;
using Toybox.WatchUi;

class ApplicationStorage extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new ApplicationStorageView(), new ApplicationStorageViewDelegate() ];
    }

    // For this app all that needs to be done is trigger a WatchUi refresh
    // since the settings are only used in onUpdate().
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }
}
