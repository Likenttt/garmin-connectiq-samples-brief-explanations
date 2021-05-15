//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class PositionSampleView extends WatchUi.View {

    var posnInfo = null;

    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    function onHide() {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var string;

        // Set background color
        dc.setColor( Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK );
        dc.clear();
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
        if( posnInfo != null ) {
            string = "Location lat = " + posnInfo.position.toDegrees()[0].toString();
            dc.drawText( (dc.getWidth() / 2), ((dc.getHeight() / 2) - 40), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER );
            string = "Location long = " + posnInfo.position.toDegrees()[1].toString();
            dc.drawText( (dc.getWidth() / 2), ((dc.getHeight() / 2) - 20), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER );
            string = "speed = " + posnInfo.speed.toString();
            dc.drawText( (dc.getWidth() / 2), ((dc.getHeight() / 2) ), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER );
            string = "alt = " + posnInfo.altitude.toString();
            dc.drawText( (dc.getWidth() / 2), ((dc.getHeight() / 2) + 20), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER );
            string = "heading = " + posnInfo.heading.toString();
            dc.drawText( (dc.getWidth() / 2), ((dc.getHeight() / 2) + 40), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER );
        }
        else {
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Graphics.FONT_SMALL, "No position info", Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function setPosition(info) {
        posnInfo = info;
        WatchUi.requestUpdate();
    }


}
