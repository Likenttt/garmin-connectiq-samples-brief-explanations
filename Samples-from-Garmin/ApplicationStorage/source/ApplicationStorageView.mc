//!
//! Copyright 2017 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;
using Toybox.Application.Storage as Storage;

class ApplicationStorageView extends WatchUi.View {

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
        setLayout(Rez.Layouts.StoreLayout(dc));
    }

    hidden function getDisplayString(storagePrefix, storageId) {
        var value = Storage.getValue(storageId);
        if (value == null) {
            value = "Not set";
        }
        return storagePrefix + ": " + value;
    }

    hidden function updateLabel(labelId, labelText) {
        var drawable = View.findDrawableById(labelId);
        if (drawable != null) {
            drawable.setText(labelText);
        }
    }

    function onUpdate(dc) {
        updateLabel("IntLabel", getDisplayString("Int", INT_KEY));
        updateLabel("LongLabel", getDisplayString("Long", LONG_KEY));
        updateLabel("FloatLabel", getDisplayString("Float", FLOAT_KEY));
        updateLabel("DoubleLabel", getDisplayString("Double", DOUBLE_KEY));
        updateLabel("StringLabel", getDisplayString("String", STRING_KEY));
        updateLabel("BoolLabel", getDisplayString("Boolean", BOOLEAN_KEY));
        updateLabel("ArrayLabel", getDisplayString("Array", ARRAY_KEY));
        updateLabel("DictLabel", getDisplayString("Dictionary", DICTIONARY_KEY));

        View.onUpdate(dc);

        mIndicator.draw(dc, 0);
    }
}

enum {
    INT_KEY,
    LONG_KEY,
    FLOAT_KEY,
    DOUBLE_KEY,
    STRING_KEY,
    BOOLEAN_KEY,
    ARRAY_KEY,
    DICTIONARY_KEY,

    KEY_COUNT
}

class ApplicationStorageViewDelegate extends WatchUi.BehaviorDelegate {
    var count;

    function initialize() {
        BehaviorDelegate.initialize();
        count = Storage.getValue("count");
        if (count == null)
        {
            count = 0;
        }
    }

    function onNextPage() {
        WatchUi.switchToView(new DefaultPropertiesView(), new DefaultPropertiesViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    function onPreviousPage() {
        WatchUi.switchToView(new DefaultPropertiesView(), new DefaultPropertiesViewDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onKey(evt) {
        if (evt.getKey() == WatchUi.KEY_ENTER) {
            return onTap(null);
        } else if (evt.getKey() == WatchUi.KEY_MENU) {
            return onHold(null);
        }
        return false;
    }

    function onTap(evt) {
        if (INT_KEY == count) {
            Storage.setValue(count, 3);
        } else if (LONG_KEY == count) {
            Storage.setValue(count, 4l);
        } else if (FLOAT_KEY == count) {
            Storage.setValue(count, 3.14159);
        } else if (DOUBLE_KEY == count) {
            Storage.setValue(count, 1.0d / 3);
        } else if (STRING_KEY == count) {
            Storage.setValue(count, "pie");
        } else if (BOOLEAN_KEY == count) {
            Storage.setValue(count, true);
        } else if (ARRAY_KEY == count) {
            Storage.setValue(count, [1,2,3,null]);
        } else if (DICTIONARY_KEY == count) {
            Storage.setValue(count, {1=>"one", "two"=>2, "null"=>null});
        } else {
            Storage.deleteValue(count - KEY_COUNT);
        }

        count += 1;

        if (count == (2 * KEY_COUNT)) {
            count = 0;
        }

        Storage.setValue("count", count);

        WatchUi.requestUpdate();
        return true;
    }

    function onHold(evt) {
        Storage.clearValues();
        count = 0;
        WatchUi.requestUpdate();
        return true;
    }

}
