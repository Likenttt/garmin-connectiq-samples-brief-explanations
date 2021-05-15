//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;

class DefaultPropertiesView extends WatchUi.View {

    hidden var mIndicator;

    function initialize() {
        View.initialize();
        mIndicator = new PageIndicator();
        var size = 2;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = mIndicator.ALIGN_TOP_RIGHT;
        var margin = 3;
        mIndicator.setup(size, selected, notSelected, alignment, margin);
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.SettingsLayout(dc));
    }

    function onUpdate(dc) {
        var app = Application.getApp();

        var int = app.getProperty("number_prop");
        var float = app.getProperty("float_prop");
        var string = app.getProperty("string_prop");
        var boolean = app.getProperty("boolean_prop");

        if (null==int) {
            int="Not set";
        }

        if (null==float) {
            float="Not set";
        }

        if (null==string) {
            string="Not set";
        }

        if (null==boolean) {
            boolean="Not set";
        }

        var intLabel = View.findDrawableById("IntLabel");
        var floatLabel = View.findDrawableById("FloatLabel");
        var stringLabel = View.findDrawableById("StringLabel");
        var boolLabel = View.findDrawableById("BoolLabel");

        intLabel.setText("Int: " + int);
        floatLabel.setText("Float: " + float);
        stringLabel.setText("String: " + string);
        boolLabel.setText("Boolean: " + boolean);

        View.onUpdate(dc);

        mIndicator.draw(dc, 1);
    }
}

class DefaultPropertiesViewDelegate extends WatchUi.BehaviorDelegate {

    var count = 0;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() {
        WatchUi.switchToView(new ObjectStoreView(), new ObjectStoreViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new ObjectStoreView(), new ObjectStoreViewDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onKey(evt) {
        if (evt.getKey() == WatchUi.KEY_ENTER) {
            return onTap(null);
        }
        return false;
    }

    function onTap(evt) {
        var app = Application.getApp();
        var int = app.getProperty("number_prop");
        int += 1;
        app.setProperty("number_prop", int );
        WatchUi.requestUpdate();
        return true;
    }

}
