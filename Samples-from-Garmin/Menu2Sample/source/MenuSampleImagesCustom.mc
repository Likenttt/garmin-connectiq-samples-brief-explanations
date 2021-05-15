//
// Copyright 2018 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

function pushImagesCustom() {
    var customMenu = new ImagesMenu(80,Graphics.COLOR_BLACK,{});
    customMenu.addItem(new CustomImagesItem(:bear, "Bear", WatchUi.loadResource(Rez.Drawables.bear)));
    customMenu.addItem(new CustomImagesItem(:dog, "Dog", WatchUi.loadResource(Rez.Drawables.dog)));
    customMenu.addItem(new CustomImagesItem(:fox, "Fox", WatchUi.loadResource(Rez.Drawables.fox)));
    customMenu.addItem(new CustomImagesItem(:mouse, "Mouse", WatchUi.loadResource(Rez.Drawables.mouse)));
    customMenu.addItem(new CustomImagesItem(:turtle, "Turtle", WatchUi.loadResource(Rez.Drawables.turtle)));
    WatchUi.pushView(customMenu, new ImagesCustomDelegate(), WatchUi.SLIDE_UP );
    }

class ImagesMenu extends WatchUi.CustomMenu {
    function initialize(itemHeight, backgroundColor, options) {
        CustomMenu.initialize(itemHeight, backgroundColor, options);
    }

    function drawTitle(dc) {
        if( Toybox.WatchUi.CustomMenu has :isTitleSelected ) {
            if( isTitleSelected() ) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
                dc.clear();
            }
        }
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0,dc.getHeight()-2,dc.getWidth(),dc.getHeight()-2);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, "Images", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class ImagesCustomDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        WatchUi.requestUpdate();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

// This is the custom item drawable.
// It draws the label it is initialized with at the center of the region
class CustomImagesItem extends WatchUi.CustomMenuItem {
    var mLabel;
    var mBitmap;
    var mBitmapOffset;

    function initialize(id, label, bitmap) {
        CustomMenuItem.initialize(id, {});
        mLabel = label;
        mBitmap = bitmap;
        mBitmapOffset = 0 - bitmap.getWidth() / 2;
    }

    // draw the item string at the center of the item.
    function draw(dc) {
        var font;
        var bmXY = dc.getHeight()/2 + mBitmapOffset;
        if( isFocused() ) {
            font = Graphics.FONT_LARGE;
        } else {
            font = Graphics.FONT_SMALL;
        }

        if( isSelected() ) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.drawBitmap(bmXY, bmXY, mBitmap);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getHeight(), dc.getHeight()/2, font, mLabel, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

