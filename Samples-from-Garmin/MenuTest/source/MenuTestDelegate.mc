using Toybox.WatchUi;

class MenuTestDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuTestMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
