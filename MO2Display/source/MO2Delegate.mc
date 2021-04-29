//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class MO2Delegate extends WatchUi.BehaviorDelegate {
    var mIndex;
    var mSensor;

    function initialize(sensor, index) {
        WatchUi.InputDelegate.initialize();

        mSensor = sensor;
        mIndex = index;
    }

    function onNextPage() {
        mIndex = (mIndex + 1) % 4;
        WatchUi.switchToView(getView(mIndex), getDelegate(mIndex), WatchUi.SLIDE_LEFT);
    }

    function onPreviousPage() {
        mIndex = mIndex - 1;
        if (mIndex < 0) {
            mIndex = 3;
        }
        mIndex = mIndex % 4;
        WatchUi.switchToView(getView(mIndex), getDelegate(mIndex), WatchUi.SLIDE_RIGHT);
    }

    function onSwipe(evt) {
        if (evt.getDirection() == WatchUi.SWIPE_LEFT) {
            onNextPage();
        } else if (evt.getDirection() == WatchUi.SWIPE_RIGHT) {
            onPreviousPage();
        }
    }

    function onTap(evt) {
        if (mIndex == 3) {
            mSensor.setTime();
        }
    }

    function onKey(evt) {
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            onNextPage();
        } else if (WatchUi.KEY_UP == key) {
            onPreviousPage();
        }
    }

    function getView(mIndex) {
        var view;

        if (0 == mIndex) {
            view = new MainView(mSensor, mIndex);
        } else if (1 == mIndex) {
            view = new DataView(mSensor, mIndex);
        } else if (2 == mIndex) {
            view = new GraphView(mSensor, mIndex);
        } else {
            view = new CommandView(mSensor, mIndex);
        }

        return view;
    }

    function getDelegate(mIndex) {
        var delegate = new MO2Delegate(mSensor, mIndex);
        return delegate;
    }

}
