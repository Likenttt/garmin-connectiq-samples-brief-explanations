//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.System;

var page = 1;

class BaseInputDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() {
        onMenu();
    }

    function onMenu() {

        if (page == 3) {
            page = 1;
        } else {
            page = page + 1;
        }

        switchView(page);
        WatchUi.requestUpdate();
        return true;
    }

    function switchView(pageNum) {

        var newView = null;
        var inputDelegate = new BaseInputDelegate();

        if(page == 1) {
            newView = new UserProfileSectionOneView();
        }
        else if(page == 2) {
            newView = new UserProfileSectionTwoView();
        }
        else if(page == 3) {
            newView = new UserProfileSectionThreeView();
        }

        switchToView(newView, inputDelegate, WatchUi.SLIDE_IMMEDIATE);
    }
}