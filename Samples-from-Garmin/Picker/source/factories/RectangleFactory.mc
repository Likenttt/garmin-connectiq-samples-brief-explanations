using Toybox.Graphics;
using Toybox.WatchUi;

class RectangleFactory extends WatchUi.PickerFactory {

    hidden var mColor;

    function initialize(color) {
        PickerFactory.initialize();
        mColor = color;
    }

    function getSize() {
        return 1;
    }

    function getValue(index) {
        return 0;
    }

    function getDrawable(index, selected) {
        return new Rectangle(mColor);
    }
}
