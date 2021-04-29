using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

class ColorPicker extends WatchUi.Picker {
    var factory;
    var title;

    function initialize() {
        title = new WatchUi.Text({:text=>Rez.Strings.colorPickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        factory = new ColorFactory([Graphics.COLOR_RED, Graphics.COLOR_GREEN, Graphics.COLOR_BLUE, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_PURPLE]);
        var defaults = null;
        var value = Application.getApp().getProperty("color");
        if(value != null) {
            defaults = [ factory.getIndex(value) ];
        }

        var nextArrow = new WatchUi.Bitmap({:rezId=>Rez.Drawables.nextArrow, :locX => WatchUi.LAYOUT_HALIGN_CENTER, :locY => WatchUi.LAYOUT_VALIGN_CENTER});
        var previousArrow = new WatchUi.Bitmap({:rezId=>Rez.Drawables.previousArrow, :locX => WatchUi.LAYOUT_HALIGN_CENTER, :locY => WatchUi.LAYOUT_VALIGN_CENTER});
        var brush = new WatchUi.Bitmap({:rezId=>Rez.Drawables.brush, :locX => WatchUi.LAYOUT_HALIGN_CENTER, :locY => WatchUi.LAYOUT_VALIGN_CENTER});
        Picker.initialize({:title=>title, :pattern=>[factory], :defaults=>defaults, :nextArrow=>nextArrow, :previousArrow=>previousArrow, :confirm=>brush});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class ColorPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        Application.getApp().setProperty("color", values[0]);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
