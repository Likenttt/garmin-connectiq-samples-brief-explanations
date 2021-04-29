//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class PrimatesDelegate extends WatchUi.BehaviorDelegate {
    var index = 0;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() {
        index = (index + 1) % 3;
        var view = new PrimatesView();
        view.setIndex(index);
        var delegate = new PrimatesDelegate();
        delegate.setIndex(index);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_LEFT);

        return true;
    }

    function onPreviousPage() {
        index = index - 1;
        if (index < 0) {
            index = 2;
        }
        index = index % 3;
        var view = new PrimatesView();
        view.setIndex(index);
        var delegate = new PrimatesDelegate();
        delegate.setIndex(index);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_RIGHT);

        return true;
    }

    function setIndex(newIndex) {
        index = newIndex;
    }

    function onSelect() {
        if (index == 0) {
            WatchUi.pushView(new ApesView(), new DetailsDelegate(), WatchUi.SLIDE_UP);
        } else if (index == 1) {
            WatchUi.pushView(new MonkeysView(), new DetailsDelegate(), WatchUi.SLIDE_UP);
        } else if (index == 2) {
            WatchUi.pushView(new ProsimiansView(), new DetailsDelegate(), WatchUi.SLIDE_UP);
        }

        return true;
    }
}
