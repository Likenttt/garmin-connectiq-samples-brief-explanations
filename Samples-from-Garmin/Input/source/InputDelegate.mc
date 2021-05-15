//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

var last_key = null;
var last_behavior = null;
var buttons_pressed = null;
var buttons_expected = null;

class InputDelegate extends WatchUi.BehaviorDelegate {

    enum {
        ON_NEXT_PAGE,
        ON_PREV_PAGE,
        ON_MENU,
        ON_BACK,
        ON_NEXT_MODE,
        ON_PREV_MODE,
        ON_SELECT
    }

    function initialize() {
        BehaviorDelegate.initialize();

        buttons_pressed = 0;

        var deviceSettings = System.getDeviceSettings();
        buttons_expected = deviceSettings.inputButtons;
    }

    function onNextPage() {
        last_behavior = ON_NEXT_PAGE;
        setBehaviorString("NEXT_PAGE");
        return false;
    }

    function onPreviousPage() {
        last_behavior = ON_PREV_PAGE;
        setBehaviorString("PREVIOUS_PAGE");
        return false;
    }

    function onMenu() {
        last_behavior = ON_MENU;
        setBehaviorString("ON_MENU");
        return false;
    }

    function onBack() {
        if (ON_BACK == last_behavior) {
            System.exit();
        }
        last_behavior = ON_BACK;
        setBehaviorString("ON_BACK");
        return false;
    }

    function onNextMode() {
        last_behavior = ON_NEXT_MODE;
        setBehaviorString("ON_NEXT_MODE");
        return false;
    }

    function onPreviousMode() {
        last_behavior = ON_PREV_MODE;
        setBehaviorString("ON_PREVIOUS_MODE");
        return false;
    }

    function onSelect() {
        last_behavior = ON_SELECT;
        setBehaviorString("ON_SELECT");
        return false;
    }

    function onTap(evt) {
        setActionString("CLICK_TYPE_TAP");
        return true;
    }

    function onHold(evt) {
        setActionString("CLICK_TYPE_HOLD");
        return true;
    }

    function onRelease(evt) {
        setActionString("CLICK_TYPE_RELEASE");
        return true;
    }

    function onSwipe(evt) {
        var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            setActionString("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
            setActionString("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
            setActionString("SWIPE_DOWN");
        } else if (swipe == SWIPE_LEFT) {
            setActionString("SWIPE_LEFT");
        }

        return true;
    }

    function onKey(evt) {
        var key = evt.getKey();

        var buttonString = getButtonString(key);

        if (buttonString != null) {
            setButtonString(buttonString);
        }

        var keyString = getKeyString(key);

        if (keyString != null) {
            setActionString(keyString);
        }

        if (key == KEY_ESC) {
            if (last_key == KEY_ESC) {
                System.exit();
            }
        }

        last_key = key;

        return true;
    }

    function onKeyPressed(evt) {
        var keyString = getKeyString( evt.getKey());
        if( keyString != null) {
            setStatusString( keyString + " PRESSED");
        }

        return true;
    }

    function onKeyReleased(evt) {
        var keyString = getKeyString( evt.getKey());
        if( keyString != null) {
            setStatusString( keyString + " RELEASED");
        }

        return true;
    }

    function getKeyString(key) {
        if (key == KEY_POWER) {
            return "KEY_POWER";
        } else if (key == KEY_LIGHT) {
            return "KEY_LIGHT";
        } else if (key == KEY_ZIN) {
            return "KEY_ZIN";
        } else if (key == KEY_ZOUT) {
            return "KEY_ZOUT";
        } else if (key == KEY_ENTER) {
            return "KEY_ENTER";
        } else if (key == KEY_ESC) {
            return "KEY_ESC";
        } else if (key == KEY_FIND) {
            return "KEY_FIND";
        } else if (key == KEY_MENU) {
            return "KEY_MENU";
        } else if (key == KEY_DOWN) {
            return "KEY_DOWN";
        } else if (key == KEY_DOWN_LEFT) {
            return "KEY_DOWN_LEFT";
        } else if (key == KEY_DOWN_RIGHT) {
            return "KEY_DOWN_RIGHT";
        } else if (key == KEY_LEFT) {
            return "KEY_LEFT";
        } else if (key == KEY_RIGHT) {
            return "KEY_RIGHT";
        } else if (key == KEY_UP) {
            return "KEY_UP";
        } else if (key == KEY_UP_LEFT) {
            return "KEY_UP_LEFT";
        } else if (key == KEY_UP_RIGHT) {
            return "KEY_UP_RIGHT";
        } else if (key == KEY_PAGE) {
            return "KEY_PAGE";
        } else if (key == KEY_START) {
            return "KEY_START";
        } else if (key == KEY_LAP) {
            return "KEY_LAP";
        } else if (key == KEY_RESET) {
            return "KEY_RESET";
        } else if (key == KEY_SPORT) {
            return "KEY_SPORT";
        } else if (key == KEY_CLOCK) {
            return "KEY_CLOCK";
        } else if (key == KEY_MODE) {
            return "KEY_MODE";
        }

        return null;
    }

    function getButtonString(key) {
        var buttonBit = getButtonBit(key);
        if (buttonBit == null || buttons_pressed == null) {
            buttons_pressed = null;
            return "UNKNOWN_BUTTON";
        }
        else {
            buttons_pressed |= buttonBit;

            if (buttons_pressed == buttons_expected) {
                return "NO_MORE_BUTTONS";
            }
            else {
                return "MORE_BUTTONS";
            }
        }
    }

    function getButtonBit(key) {
        if (key == KEY_ENTER) {
            return System.BUTTON_INPUT_SELECT;
        } else if (key == KEY_UP) {
            return System.BUTTON_INPUT_UP;
        } else if (key == KEY_DOWN) {
            return System.BUTTON_INPUT_DOWN;
        } else if (key == KEY_MENU) {
            return System.BUTTON_INPUT_MENU;
        } else if ((key == KEY_CLOCK) && (System has :BUTTON_INPUT_CLOCK)) {
            return System.BUTTON_INPUT_CLOCK;
        } else if ((key == KEY_DOWN_LEFT) && (System has :BUTTON_INPUT_DOWN_LEFT)) {
            return System.BUTTON_INPUT_DOWN_LEFT;
        } else if ((key == KEY_DOWN_RIGHT) && (System has :BUTTON_INPUT_DOWN_RIGHT)) {
            return System.BUTTON_INPUT_DOWN_RIGHT;
        } else if ((key == KEY_ESC) && (System has :BUTTON_INPUT_ESC)) {
            return System.BUTTON_INPUT_ESC;
        } else if ((key == KEY_FIND) && (System has :BUTTON_INPUT_FIND)) {
            return System.BUTTON_INPUT_FIND;
        } else if ((key == KEY_LAP) && (System has :BUTTON_INPUT_LAP)) {
            return System.BUTTON_INPUT_LAP;
        } else if ((key == KEY_LEFT) && (System has :BUTTON_INPUT_LEFT)) {
            return System.BUTTON_INPUT_LEFT;
        } else if ((key == KEY_LIGHT) && (System has :BUTTON_INPUT_LIGHT)) {
            return System.BUTTON_INPUT_LIGHT;
        } else if ((key == KEY_MODE) && (System has :BUTTON_INPUT_MODE)) {
            return System.BUTTON_INPUT_MODE;
        } else if ((key == KEY_PAGE) && (System has :BUTTON_INPUT_PAGE)) {
            return System.BUTTON_INPUT_PAGE;
        } else if ((key == KEY_POWER) && (System has :BUTTON_INPUT_POWER)) {
            return System.BUTTON_INPUT_POWER;
        } else if ((key == KEY_RESET) && (System has :BUTTON_INPUT_RESET)) {
            return System.BUTTON_INPUT_RESET;
        } else if ((key == KEY_RIGHT) && (System has :BUTTON_INPUT_RIGHT)) {
            return System.BUTTON_INPUT_RIGHT;
        } else if ((key == KEY_SPORT) && (System has :BUTTON_INPUT_SPORT)) {
            return System.BUTTON_INPUT_SPORT;
        } else if ((key == KEY_START) && (System has :BUTTON_INPUT_START)) {
            return System.BUTTON_INPUT_START;
        } else if ((key == KEY_UP_LEFT) && (System has :BUTTON_INPUT_LEFT)) {
            return System.BUTTON_INPUT_LEFT;
        } else if ((key == KEY_UP_RIGHT) && (System has :BUTTON_INPUT_RIGHT)) {
            return System.BUTTON_INPUT_UP_RIGHT;
        } else if ((key == KEY_ZIN) && (System has :BUTTON_INPUT_ZIN)) {
            return System.BUTTON_INPUT_ZIN;
        } else if ((key == KEY_ZOUT) && (System has :BUTTON_INPUT_ZOUT)) {
            return System.BUTTON_INPUT_ZOUT;
        }

        return null;
    }
}
