//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

var keyToSelectable = false;

class CheckBoxDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelectable(event) {
        var instance = event.getInstance();

        if(instance instanceof Checkbox) {
            currentView.checkBoxes.handleEvent(instance, event.getPreviousState());
        }
        return true;
    }

    function onMenu() {
        keyToSelectable = !keyToSelectable;
        currentView.setKeyToSelectableInteraction(keyToSelectable);
        return true;
    }

    function onNextPage() {
        return pushMenu(WatchUi.SLIDE_IMMEDIATE);
    }

    function pushMenu(slideDir) {
        var view = new ButtonView();
        var delegate = new ButtonDelegate();
        WatchUi.pushView(view, delegate, slideDir);
        return true;
    }

    function onKey(evt) {
        var key = evt.getKey();

        if (key == KEY_ENTER) {
            return pushMenu(WatchUi.SLIDE_IMMEDIATE);
        }

        return false;
    }
}
