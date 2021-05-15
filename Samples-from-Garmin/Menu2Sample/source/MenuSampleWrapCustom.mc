//
// Copyright 2018 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

function pushWrapCustom() {
    var customMenu = new WrapTopMenu(80,Graphics.COLOR_BLACK,{});
    customMenu.addItem(new CustomWrapItem(:item1, "Item 1", Graphics.COLOR_WHITE));
    customMenu.addItem(new CustomWrapItem(:item2, "Item 2", Graphics.COLOR_WHITE));
    customMenu.addItem(new CustomWrapItem(:item3, "Item 3", Graphics.COLOR_WHITE));
    WatchUi.pushView(customMenu, new WrapTopCustomDelegate(), WatchUi.SLIDE_LEFT );
    }

function pushWrapCustomBottom() {
    var customMenu = new WrapBottomMenu(80,Graphics.COLOR_WHITE,{});
    customMenu.addItem(new CustomWrapItem(:item1, "Item 1", Graphics.COLOR_BLACK));
    customMenu.addItem(new CustomWrapItem(:item2, "Item 2", Graphics.COLOR_BLACK));
    customMenu.addItem(new CustomWrapItem(:item3, "Item 3", Graphics.COLOR_BLACK));
    WatchUi.pushView(customMenu, new WrapBottomCustomDelegate(), WatchUi.SLIDE_UP );
    }

class WrapTopMenu extends WatchUi.CustomMenu {
    function initialize(itemHeight, backgroundColor, options) {
        CustomMenu.initialize(itemHeight, backgroundColor, options);
    }

    function drawBackground(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
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
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, "Top\nMenu", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawFooter(dc) {
        var height = dc.getHeight();
        var centerX = dc.getWidth() / 2;
        var bkColor = Graphics.COLOR_WHITE;
        if( Toybox.WatchUi.CustomMenu has :isFooterSelected ) {
            bkColor = isFooterSelected() ? Graphics.COLOR_BLUE : Graphics.COLOR_WHITE;
        }
        dc.setColor(bkColor, bkColor);
        dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0,1,dc.getWidth(),1);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/3, Graphics.FONT_MEDIUM, "To Sub Menu", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillPolygon([[centerX,height-10],[centerX+5,height-15],[centerX-5,height-15]]);
    }
}

class WrapBottomMenu extends WatchUi.CustomMenu {
    function initialize(itemHeight, backgroundColor, options) {
        CustomMenu.initialize(itemHeight, backgroundColor, options);
    }

    function drawTitle(dc) {
        var centerX = dc.getWidth() / 2;
        var bkColor = Graphics.COLOR_BLACK;
        if( Toybox.WatchUi.CustomMenu has :isTitleSelected ) {
            bkColor = isTitleSelected() ? Graphics.COLOR_BLUE : Graphics.COLOR_BLACK;
        }
        dc.setColor(bkColor, bkColor);
        dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0,dc.getHeight()-2,dc.getWidth(),dc.getHeight()-2);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/3*2, Graphics.FONT_MEDIUM, "Back to Top", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillPolygon([[centerX,10],[centerX+5,15],[centerX-5,15]]);
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class WrapTopCustomDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        WatchUi.requestUpdate();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onWrap(key) {
        if(key == WatchUi.KEY_DOWN) {
            pushWrapCustomBottom();
        }
        return false;
    }

    function onFooter() {
        pushWrapCustomBottom();
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class WrapBottomCustomDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        WatchUi.requestUpdate();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onWrap(key) {
        if(key == WatchUi.KEY_UP) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return false;
    }

    function onTitle() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

// This is the custom item drawable.
// It draws the label it is initialized with at the center of the region
class CustomWrapItem extends WatchUi.CustomMenuItem {
    var mLabel;
    var mTextColor;

    function initialize(id, label, textColor) {
        CustomMenuItem.initialize(id, {});
        mLabel = label;
        mTextColor = textColor;
    }

    // draw the item string at the center of the item.
    function draw(dc) {
        var font;
        if( isFocused() ) {
            font = Graphics.FONT_LARGE;
        } else {
            font = Graphics.FONT_SMALL;
        }

        if( isSelected() ) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.setColor(mTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight()/2, font, mLabel, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

