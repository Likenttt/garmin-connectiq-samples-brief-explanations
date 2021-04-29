//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class EncryptionDelegate extends Toybox.WatchUi.BehaviorDelegate {

    // Initializes EncryptionDelegate
    function initialize() {
        // Initializes parent class
        BehaviorDelegate.initialize();
    }

    // Pushes Master Slave menu
    function onMenu() {
        Toybox.WatchUi.pushView( new Rez.Menus.MainMenu(), new EncryptionMenuDelegate(), Toybox.WatchUi.SLIDE_UP );
        return true;
    }

    // Pushes Master Slave menu
    function onSelect() {
        Toybox.WatchUi.pushView( new Rez.Menus.MainMenu(), new EncryptionMenuDelegate(), Toybox.WatchUi.SLIDE_UP );
        return true;
    }
}