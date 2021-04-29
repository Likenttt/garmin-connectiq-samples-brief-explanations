//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

var action_string;
var status_string;
var behavior_string;
var button_string;
var action_hits;
var behavior_hits;


function setStatusString(new_string) {
    status_string = new_string;
    WatchUi.requestUpdate();
}

function setActionString(new_string) {
    action_string = new_string;
    action_hits++;

    if (action_hits > behavior_hits) {
        behavior_string = "NO_BEHAVIOR";
        behavior_hits = action_hits;
    }

    WatchUi.requestUpdate();
}

function setBehaviorString(new_string) {
    behavior_string = new_string;
    behavior_hits++;
    WatchUi.requestUpdate();
}

function setButtonString(new_string) {
    button_string = new_string;
    WatchUi.requestUpdate();
}

class InputView extends WatchUi.View {

    function initialize() {
        View.initialize();
        action_string = "NO_ACTION";
        behavior_string = "NO_BEHAVIOR";
        status_string = "NO_EVENT";
        button_string = "PUSH_BUTTONS";
        action_hits = 0;
        behavior_hits = 0;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var dy = dc.getFontHeight(Graphics.FONT_SMALL);
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        y -= (4 * dy) / 2;

        dc.drawText(x, y, Graphics.FONT_SMALL, action_string, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, behavior_string, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, status_string, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, button_string, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
