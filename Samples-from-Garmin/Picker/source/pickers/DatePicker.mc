using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

class DatePicker extends WatchUi.Picker {

    function initialize() {
        var months = [Rez.Strings.month01, Rez.Strings.month02, Rez.Strings.month03,
                      Rez.Strings.month04, Rez.Strings.month05, Rez.Strings.month06,
                      Rez.Strings.month07, Rez.Strings.month08, Rez.Strings.month09,
                      Rez.Strings.month10, Rez.Strings.month11, Rez.Strings.month12];
        var title = new WatchUi.Text({:text=>Rez.Strings.datePickerTitle, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var separator = new WatchUi.Text({:text=>Rez.Strings.dateSeparator, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new WordFactory(months, {}), separator, new NumberFactory(1,31,1, {}), separator, new NumberFactory(15,18,1,{:font=>Graphics.FONT_NUMBER_MEDIUM})]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class DatePickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var separator = WatchUi.loadResource(Rez.Strings.dateSeparator);
        var date = WatchUi.loadResource(values[0]) + separator + values[2] + separator + values[4];
        Application.getApp().setProperty("date", date);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
