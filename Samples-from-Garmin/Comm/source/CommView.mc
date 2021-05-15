//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;
using Toybox.System;

class CommView extends WatchUi.View {
    var screenShape;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        screenShape = System.getDeviceSettings().screenShape;
    }

    function drawIntroPage(dc) {
        if(System.SCREEN_SHAPE_ROUND == screenShape) {
            dc.drawText(dc.getWidth() / 2, 25,  Graphics.FONT_SMALL, "Communications", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 55, Graphics.FONT_SMALL, "Test", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 80,  Graphics.FONT_TINY,  "Connect a phone then", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 100,  Graphics.FONT_TINY,  "use the menu to send", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 120,  Graphics.FONT_TINY,  "strings to your phone", Graphics.TEXT_JUSTIFY_CENTER);
        } else if(System.SCREEN_SHAPE_SEMI_ROUND == screenShape) {
            dc.drawText(dc.getWidth() / 2, 20,  Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 50,  Graphics.FONT_SMALL,  "Connect a phone", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 70,  Graphics.FONT_SMALL,  "Then use the menu to send", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 90,  Graphics.FONT_SMALL,  "strings to your phone", Graphics.TEXT_JUSTIFY_CENTER);
        } else if(dc.getWidth() > dc.getHeight()) {
            dc.drawText(10, 20,  Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 50,  Graphics.FONT_SMALL,  "Connect a phone", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70,  Graphics.FONT_SMALL,  "Then use the menu to send", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90,  Graphics.FONT_SMALL,  "strings to your phone", Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(10, 20, Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 40, Graphics.FONT_MEDIUM, "Test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70, Graphics.FONT_SMALL, "Connect a phone", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90, Graphics.FONT_SMALL, "Then use the menu", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 110, Graphics.FONT_SMALL, "to send strings", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 130, Graphics.FONT_SMALL, "to your phone", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if(hasDirectMessagingSupport) {
            if(page == 0) {
                drawIntroPage(dc);
            } else {
                var i;
                var y = 50;

                dc.drawText(dc.getWidth() / 2, 20,  Graphics.FONT_MEDIUM, "Strings Received:", Graphics.TEXT_JUSTIFY_CENTER);
                for(i = 0; i < stringsSize; i += 1) {
                    dc.drawText(dc.getWidth() / 2, y,  Graphics.FONT_SMALL, strings[i], Graphics.TEXT_JUSTIFY_CENTER);
                    y += 20;
                }
             }
         } else {
             dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_MEDIUM, "Direct Messaging API\nNot Supported", Graphics.TEXT_JUSTIFY_CENTER);
         }
    }


}