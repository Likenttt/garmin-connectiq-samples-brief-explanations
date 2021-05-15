//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

var lastText = "";

class KeyboardDelegate extends WatchUi.InputDelegate {

    function initialize() {
        WatchUi.InputDelegate.initialize();
    }

    // Push a text picker if the up button is pressed
    // or the screen receives a tap.
    function onKey(key) {
        if (WatchUi has :TextPicker) {
            if (key.getKey() == WatchUi.KEY_UP) {
                WatchUi.pushView(new WatchUi.TextPicker(lastText), new KeyboardListener(), WatchUi.SLIDE_DOWN);
            }
        }
    }

    function onTap(evt) {
        if (WatchUi has :TextPicker) {
            WatchUi.pushView(new WatchUi.TextPicker(lastText), new KeyboardListener(), WatchUi.SLIDE_DOWN);
        }
    }

}

class KeyboardListener extends WatchUi.TextPickerDelegate {

    function initialize() {
        WatchUi.TextPickerDelegate.initialize();
    }

    function onTextEntered(text, changed) {
        globalText = text + "\n" + "Changed: " + changed;
        lastText = text;
    }

    function onCancel() {
        globalText = "Cancelled";
    }
}