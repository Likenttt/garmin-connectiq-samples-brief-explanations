using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

class LayoutPicker extends WatchUi.Picker {

    function initialize() {
        var factory = new RectangleFactory(Graphics.COLOR_PURPLE);
        Picker.initialize({:title=>new Rectangle(Graphics.COLOR_RED),
                           :pattern=>[factory, factory, factory, factory, factory],
                           :nextArrow=>new Rectangle(Graphics.COLOR_GREEN),
                           :previousArrow=>new Rectangle(Graphics.COLOR_GREEN),
                           :confirm=>new Rectangle(Graphics.COLOR_WHITE)});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class LayoutPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
