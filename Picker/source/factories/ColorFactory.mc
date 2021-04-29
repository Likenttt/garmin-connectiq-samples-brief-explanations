using Toybox.Graphics;
using Toybox.WatchUi;

class ColorFactory extends WatchUi.PickerFactory
{
    var mColorWheel;

    function initialize(colors) {
        PickerFactory.initialize();
        mColorWheel = new ColorWheel({:colors => colors});
    }

    function getIndex(value) {
        return mColorWheel.getColorIndex(value);
    }

    function getSize() {
        return mColorWheel.getNumberOfColors();
    }

    function getValue(index) {
        return mColorWheel.getColor(index);
    }

    function getDrawable(index, selected) {
        mColorWheel.setColor(index);
        return mColorWheel;
    }
}
