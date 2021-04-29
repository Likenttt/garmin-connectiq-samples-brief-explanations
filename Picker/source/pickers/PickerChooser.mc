using Toybox.Graphics;
using Toybox.WatchUi;

class PickerChooser extends WatchUi.Picker {

    function initialize() {
        var title = new WatchUi.Text({:text=>Rez.Strings.pickerChooserTitle, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var factory = new WordFactory([Rez.Strings.pickerChooserColor, Rez.Strings.pickerChooserDate, Rez.Strings.pickerChooserString, Rez.Strings.pickerChooserTime, Rez.Strings.pickerChooserLayout], {:font=>Graphics.FONT_MEDIUM});
        Picker.initialize({:title=>title, :pattern=>[factory]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class PickerChooserDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        if(values[0] == Rez.Strings.pickerChooserColor) {
            WatchUi.pushView(new ColorPicker(), new ColorPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        else if(values[0] == Rez.Strings.pickerChooserDate) {
            WatchUi.pushView(new DatePicker(), new DatePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        else if(values[0] == Rez.Strings.pickerChooserString) {
            var picker = new StringPicker();
            WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_IMMEDIATE);
        }
        else if(values[0] == Rez.Strings.pickerChooserTime) {
            WatchUi.pushView(new TimePicker(), new TimePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        else if(values[0] == Rez.Strings.pickerChooserLayout) {
            WatchUi.pushView(new LayoutPicker(), new LayoutPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}
