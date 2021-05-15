//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class EncryptionView extends Toybox.WatchUi.View {

    // Initalizes EncryptionView
    function initialize() {
        // Initializes parent class
        View.initialize();
    }

    // Loads start screen
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Updates the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
}
