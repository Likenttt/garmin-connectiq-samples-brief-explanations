//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Attention;
using Toybox.System;

var selectedIndex;
var currentTone = null;
var currentVibe = null;

class AttentionView extends WatchUi.View {

    var backlightOn = false;
    var toneIdx = 0;
    var mainText;
    var toneNames = [ "Key",
                      "Start",
                      "Stop",
                      "Message",
                      "Alert Hi",
                      "Alert Lo",
                      "Loud Beep",
                      "Interval Alert",
                      "Alarm",
                      "Reset",
                      "Lap",
                      "Canary",
                      "Time Alert",
                      "Distance Alert",
                      "Failure",
                      "Success",
                      "Power",
                      "Low Battery",
                      "Error",
                      "Custom" ];

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        selectedIndex = 0;
        mainText = Rez.Layouts.MainText(dc);
        setLayout(mainText);
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw selected box
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, selectedIndex * dc.getHeight() / 3, dc.getWidth(), dc.getHeight() / 3);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw frames
        dc.drawLine(0, dc.getHeight() / 3, dc.getWidth(), dc.getHeight() / 3);
        dc.drawLine(0, 2 * dc.getHeight() / 3, dc.getWidth(), 2 * dc.getHeight() / 3);

        var backlightLabel = View.findDrawableById("BacklightLabel");
        var vibrateLabel = View.findDrawableById("VibeLabel");
        var toneLabel = View.findDrawableById("ToneLabel");

        backlightLabel.setText("Toggle Backlight");

        if (currentVibe != null) {
            vibrateLabel.setText("Vibe: " + currentVibe);
        } else {
            vibrateLabel.setText("Vibrate");
        }

        if (currentTone != null) {
            toneLabel.setText("Tone: " + currentTone);
        } else {
            toneLabel.setText("Play a tone");
        }

        // Draw text fields in layout
        for (var i = 0; i < mainText.size(); i+=1) {
            mainText[i].draw(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    // Take a tap coordinate and correspond it to one of three sections
    function setIndexFromYVal(yval) {
        var screenHeight = System.getDeviceSettings().screenHeight;
        selectedIndex = (yval / (screenHeight / 3)).toNumber();
    }

    // Decrement the currently selected option index
    function incIndex() {
        if (null != selectedIndex) {
            selectedIndex += 1;
            if (2 < selectedIndex) {
                selectedIndex = 0;
            }
        }
    }

    // Decrement the currently selected option index
    function decIndex() {
        if (null != selectedIndex) {
            selectedIndex -= 1;
            if (0 > selectedIndex) {
                selectedIndex = 2;
            }
        }
    }

    // Process the current attention action
    function action() {
        if (0 == selectedIndex) {
            // Toggle backlight
            currentTone = null;
            backlightOn = !backlightOn;
            Attention.backlight(backlightOn);
            WatchUi.requestUpdate();
        } else if (1 == selectedIndex) {
            // Play a tone -- Note, sounds are not supported on the vivoactive
            if (Attention has :playTone) {
                var currentToneIdx = toneIdx;
                currentTone = toneNames[toneIdx];

                ++toneIdx;
                if (toneNames.size() == toneIdx) {
                    toneIdx = 0;

                    if (Attention has :ToneProfile && Rez.JsonData has :id_birthday) {
                        Attention.playTone({
                            :toneProfile => loadSong(Rez.JsonData.id_birthday)
                        });
                    }
                    else {
                       currentTone = "Not supported";
                    }
                }
                else {
                    Attention.playTone(currentToneIdx);
                }

            } else {
                currentTone = "Not supported";
            }
            WatchUi.requestUpdate();
        } else if (2 == selectedIndex) {
            // Vibrate
            currentTone = null;
            if (Attention has :vibrate) {
                var vibrateData = [
                        new Attention.VibeProfile(  25, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile( 100, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  25, 100 )
                      ];

                Attention.vibrate(vibrateData);
            } else {
                currentVibe = "Not supported";
            }
            WatchUi.requestUpdate();
        }
    }

    hidden function loadSong(rezId) {
        var array = WatchUi.loadResource(rezId);

        // convert array of [frequncy, duration] into array of ToneProfile
        for (var i = 0; i < array.size(); ++i) {
            array[i] = new Attention.ToneProfile(array[i][0], array[i][1]);
        }

        return array;
    }

}
