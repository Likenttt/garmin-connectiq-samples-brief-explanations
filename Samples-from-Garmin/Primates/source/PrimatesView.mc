//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;

class PrimatesView extends WatchUi.View {

    hidden var color;
    hidden var index;
    hidden var images;
    hidden var indicator;
    hidden var bitmap;

    var primates = [ "Apes", "Monkeys", "Prosimians" ];

    function initialize() {
        View.initialize();
        index = 0;
        color = Graphics.COLOR_BLACK;
        images = [ Rez.Drawables.id_apes,
                   Rez.Drawables.id_monkeys,
                   Rez.Drawables.id_prosimians ];

        bitmap = WatchUi.loadResource(images[index]);

        indicator = new PageIndicator();
        var size = 3;
        var margin = 3;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = indicator.ALIGN_BOTTOM_CENTER;
        indicator.setup(size, selected, notSelected, alignment, margin);
    }

    function setIndex(newIndex) {
        index = newIndex;
        bitmap = null;
        bitmap = WatchUi.loadResource(images[index]);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText( (dc.getWidth() / 2), 5, Graphics.FONT_SMALL, primates[index], Graphics.TEXT_JUSTIFY_CENTER);

        var bx = (dc.getWidth() / 2) - (bitmap.getWidth() / 2);
        var by = (dc.getHeight() / 2) - (bitmap.getHeight() / 2);

        dc.drawBitmap(bx, by, bitmap);

        indicator.draw(dc, index);
    }

}
