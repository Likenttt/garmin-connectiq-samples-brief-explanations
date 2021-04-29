//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;

class CommListener extends Communications.ConnectionListener {
    function initialize() {
        Communications.ConnectionListener.initialize();
    }

    function onComplete() {
        System.println("Transmit Complete");
    }

    function onError() {
        System.println("Transmit Failed");
    }
}

class CommInputDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu();
        var delegate;

        menu.addItem("Send Data", :sendData);
        menu.addItem("Set Listener", :setListener);
        delegate = new BaseMenuDelegate();
        WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);

        return true;
    }

    function onTap(event) {
        if(page == 0) {
            page = 1;
        } else {
            page = 0;
        }
        WatchUi.requestUpdate();
    }
}

class BaseMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var menu = new WatchUi.Menu();
        var delegate = null;

        if(item == :sendData) {
            menu.addItem("Hello World.", :hello);
            menu.addItem("Ackbar", :trap);
            menu.addItem("Garmin", :garmin);
            delegate = new SendMenuDelegate();
        } else if(item == :setListener) {
            menu.setTitle("Listner Type");
            menu.addItem("Mailbox", :mailbox);
            if(Communications has :registerForPhoneAppMessages) {
                menu.addItem("Phone Application", :phone);
            }
            menu.addItem("None", :none);
            menu.addItem("Crash if 'Hi'", :phoneFail);
            delegate = new ListnerMenuDelegate();
        }

        WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);
    }
}

class SendMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var listener = new CommListener();

        if(item == :hello) {
            Communications.transmit("Hello World.", null, listener);
        } else if(item == :trap) {
            Communications.transmit("IT'S A TRAP!", null, listener);
        } else if(item == :garmin) {
            Communications.transmit("ConnectIQ", null, listener);
        }

        WatchUi.popView(SLIDE_IMMEDIATE);
    }
}

class ListnerMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if(item == :mailbox) {
            Communications.setMailboxListener(mailMethod);
        } else if(item == :phone) {
            if(Communications has :registerForPhoneAppMessages) {
                Communications.registerForPhoneAppMessages(phoneMethod);
            }
        } else if(item == :none) {
            Communications.registerForPhoneAppMessages(null);
            Communications.setMailboxListener(null);
        } else if(item == :phoneFail) {
            crashOnMessage = true;
            Communications.registerForPhoneAppMessages(phoneMethod);
        }

        WatchUi.popView(SLIDE_IMMEDIATE);
    }
}

