//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class EncryptionMenuDelegate extends Toybox.WatchUi.MenuInputDelegate {

    // Initializes EncryptionMenuDelegate
    function initialize() {
        MenuInputDelegate.initialize();
    }

    // On selection
    // @param item, the menu item that was choosen
    function onMenuItem( item ) {
        var sensor;
        if ( item == :master ) {
            // Creates a AntSensor object with a master channel
            sensor = new AntModule.AntSensor( true );
        } else {
            // Creates a AntSensor object with a slave channel
            sensor = new AntModule.AntSensor( false );
        }
        // Pushes view that displays AntSensor data
        Toybox.WatchUi.pushView( new AntView( sensor ), new AntDelegate( sensor ), Toybox.WatchUi.SLIDE_RIGHT );
    }
}