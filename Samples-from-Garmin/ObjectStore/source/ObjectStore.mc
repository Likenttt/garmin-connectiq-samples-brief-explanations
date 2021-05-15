//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Application;
using Toybox.WatchUi;

class ObjectStore extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new ObjectStoreView(), new ObjectStoreViewDelegate() ];
    }

    // For this app all that needs to be done is trigger a WatchUi refresh
    // since the settings are only used in onUpdate().
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }
}
