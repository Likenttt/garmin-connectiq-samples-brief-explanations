//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

var globalText = "Push Up\nor Tap\nTo Start";

class KeyboardView extends WatchUi.View {

    function initialize() {
        WatchUi.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
        dc.clear();
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
        if (WatchUi has :TextPicker) {
            dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, globalText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
        } else {
            dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "TextPicker not\nsupported", Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

}