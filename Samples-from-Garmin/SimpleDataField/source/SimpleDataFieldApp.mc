//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;

class SimpleDataField extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        return false;
    }

    function getInitialView() {
        return [new DataField()];
    }

    function onStop(state) {
        return false;
    }

    function getSettingsView() {
        return [new DataFieldSettingsView(), new DataFieldSettingsDelegate()];
    }
}
