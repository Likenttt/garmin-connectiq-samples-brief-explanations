//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;
using Toybox.Application.Properties as Properties;

class DefaultPropertiesView extends WatchUi.View {

    hidden var mIndicator;

    static const INT_PROP = "number_prop";
    static const LONG_PROP = "long_prop";
    static const FLOAT_PROP = "float_prop";
    static const DOUBLE_PROP = "double_prop";
    static const STRING_PROP = "string_prop";
    static const BOOLEAN_PROP = "boolean_prop";

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
        updateLabel("IntLabel", getDisplayString("Int", INT_PROP));
        updateLabel("LongLabel", getDisplayString("Long", LONG_PROP));
        updateLabel("FloatLabel", getDisplayString("Float", FLOAT_PROP));
        updateLabel("DoubleLabel", getDisplayString("Double", DOUBLE_PROP));
        updateLabel("StringLabel", getDisplayString("String", STRING_PROP));
        updateLabel("BoolLabel", getDisplayString("Boolean", BOOLEAN_PROP));

        View.onUpdate(dc);

        mIndicator.draw(dc, 1);
    }

    hidden function getDisplayString(propertyPrefix, propertyId) {
        var value = Properties.getValue(propertyId);
        if (value == null) {
            value = "Not set";
        }
        return propertyPrefix + ": " + value;
    }

    hidden function updateLabel(labelId, labelText) {
        var drawable = View.findDrawableById(labelId);
        if (drawable != null) {
            drawable.setText(labelText);
        }
    }
}

class DefaultPropertiesViewDelegate extends WatchUi.BehaviorDelegate {

    var count = 0;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() {
        WatchUi.switchToView(new ApplicationStorageView(), new ApplicationStorageViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new ApplicationStorageView(), new ApplicationStorageViewDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onKey(evt) {
        if (evt.getKey() == WatchUi.KEY_ENTER) {
            return onTap(null);
        }
        return false;
    }

    function onTap(evt) {
        var int = Properties.getValue(DefaultPropertiesView.INT_PROP);
        int += 1;
        Properties.setValue(DefaultPropertiesView.INT_PROP, int );
        WatchUi.requestUpdate();
        return true;
    }

}
