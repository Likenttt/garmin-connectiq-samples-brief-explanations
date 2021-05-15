//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

class ButtonView extends WatchUi.View {

    //! Constructor
    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ButtonLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
    }
}
