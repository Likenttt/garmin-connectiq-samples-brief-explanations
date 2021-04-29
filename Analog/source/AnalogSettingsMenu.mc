//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Application.Storage;

class AnalogSettingsMenuItem extends WatchUi.MenuItem {

    private var mId;

    function initialize(id) {
        MenuItem.initialize();

        mId = id;
    }
}

class AnalogSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");
    }
}

class AnalogSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(menuItem) {
        Storage.setValue(menuItem.getId(), menuItem.isEnabled());
    }
}

