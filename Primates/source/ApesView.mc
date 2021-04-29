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

class ApesView extends WatchUi.View {

    hidden var color;

    function initialize() {
        View.initialize();
        color = Graphics.COLOR_WHITE;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2;
        var y = 20;

        dc.drawText(x, y, Graphics.FONT_MEDIUM, "Apes", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_MEDIUM);
        dc.drawText(x, y, Graphics.FONT_SMALL, "Apes are usually", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "larger and heavier", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "than monkeys and", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "have no tail.", Graphics.TEXT_JUSTIFY_CENTER);
    }

}
