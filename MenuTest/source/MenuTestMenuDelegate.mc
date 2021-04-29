using Toybox.WatchUi;
using Toybox.System;

class MenuTestMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :Item1) {
            System.println("Item 1");
            WatchUi.pushView(new Rez.Menus.AuxMenu(), new AuxMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item == :Item2) {
            System.println("Item 2");
        }
    }
}
