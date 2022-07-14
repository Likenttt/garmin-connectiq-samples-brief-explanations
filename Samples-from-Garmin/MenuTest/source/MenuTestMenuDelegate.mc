using Toybox.WatchUi;
using Toybox.System;

class MenuTestMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    //这里演示了多级菜单的交互，注意AuxMenuDelegate的onBack方法
    function onMenuItem(item) {
        if (item == :Item1) {
            System.println("Item 1");
            WatchUi.pushView(new Rez.Menus.AuxMenu(), new AuxMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item == :Item2) {
            System.println("Item 2");
        }
    }
}
