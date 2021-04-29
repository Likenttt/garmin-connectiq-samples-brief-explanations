//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;

class ObjectStoreView extends WatchUi.View {

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

    function onUpdate(dc) {
        var app = Application.getApp();

        var int = app.getProperty(INT_KEY);
        var float = app.getProperty(FLOAT_KEY);
        var string = app.getProperty(STRING_KEY);
        var boolean = app.getProperty(BOOLEAN_KEY);
        var array = app.getProperty(ARRAY_KEY);
        var dictionary = app.getProperty(DICTIONARY_KEY);

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

        if (null==array) {
            array="Not set";
        }

        if (null==dictionary) {
            dictionary="Not set";
        }


        var intLabel = View.findDrawableById("IntLabel");
        var floatLabel = View.findDrawableById("FloatLabel");
        var stringLabel = View.findDrawableById("StringLabel");
        var boolLabel = View.findDrawableById("BoolLabel");
        var arrLabel = View.findDrawableById("ArrayLabel");
        var dictLabel = View.findDrawableById("DictLabel");

        intLabel.setText("Int: " + int);
        floatLabel.setText("Float: " + float);
        stringLabel.setText("String: " + string);
        boolLabel.setText("Boolean: " + boolean);
        arrLabel.setText("Array: " + array);
        dictLabel.setText("Dictionary: " + dictionary);

        View.onUpdate(dc);

        mIndicator.draw(dc, 0);
    }
}

enum {
    INT_KEY,
    FLOAT_KEY,
    STRING_KEY,
    BOOLEAN_KEY,
    ARRAY_KEY,
    DICTIONARY_KEY
}

class ObjectStoreViewDelegate extends WatchUi.BehaviorDelegate {
    var count;

    function initialize() {
        BehaviorDelegate.initialize();
        count = Application.getApp().getProperty("count");
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
        var app = Application.getApp();

        if (0 == count) {
            app.setProperty(INT_KEY, 3);
        } else if (1 == count) {
            app.setProperty(FLOAT_KEY, 3.14159);
        } else if (2 == count) {
            app.setProperty(STRING_KEY, "pie");
        } else if (3 == count) {
            app.setProperty(BOOLEAN_KEY, true);
        } else if (4 == count) {
            app.setProperty(ARRAY_KEY, [1,2,3,null]);
        } else if (5 == count) {
            app.setProperty(DICTIONARY_KEY, {1=>"one", "two"=>2, "null"=>null});
        } else {
            app.deleteProperty(count - 6);
        }

        count += 1;

        if (count == 12) {
            count = 0;
        }

        app.setProperty("count", count);

        WatchUi.requestUpdate();
        return true;
    }

    function onHold(evt) {
        Application.getApp().clearProperties();
        count = 0;
        WatchUi.requestUpdate();
        return true;
    }

}
