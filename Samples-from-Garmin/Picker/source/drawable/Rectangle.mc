using Toybox.Graphics;
using Toybox.WatchUi;

class Rectangle extends WatchUi.Drawable {

    var mColor;

    function initialize(color) {
        Drawable.initialize({});
        mColor = color;
    }

    function draw(dc) {
        dc.setColor(mColor, mColor);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }
}
