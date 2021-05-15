using Toybox.WatchUi;
using Toybox.System;

class AuxMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :AuxItem1) {
            System.println("Aux Item 1");
        } else if (item == :AuxItem2) {
            System.println("Aux Item 2");
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
