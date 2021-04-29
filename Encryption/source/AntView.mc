//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class AntView extends Toybox.WatchUi.View {

    const UI_UPDATE_PERIOD_MS = 500;

    var sensor;
    var uiTimer;

    // Initializes AntDelegate
    // @param antSensor, an AntModule.AntSensor type
    function initialize( antSensor ) {
        // Initializes parent
        View.initialize();

        // Set class variables
        sensor = antSensor;

        uiTimer = new Timer.Timer();
    }

    // Stop the ui timer when the screen is no longer being displayed
    function onHide() {
        uiTimer.stop();
    }

    // Loads layout
    function onLayout( dc ) {
        setLayout( Rez.Layouts.AntView( dc ) );
        // The default title for the page is "Slave" if the channel is master, update the title to "Master"
        if ( sensor.isMaster ) {
            View.findDrawableById( "antChannelType" ).setText( Toybox.WatchUi.loadResource( Rez.Strings.Master ) );
        }
        return true;
    }

    // Start the ui timer when the view is displayed
    function onShow() {
        uiTimer.start(method(:updateScreen), UI_UPDATE_PERIOD_MS, true);
    }

    // Update the view
    // @param dc, Device Context
    function onUpdate( dc ) {
        var status;
        var colour;
        if ( true == sensor.searching ) {
                // If channel is in searching state display a red searching label
                View.findDrawableById( "status" ).setColor( Toybox.Graphics.COLOR_RED );
                View.findDrawableById( "status" ).setText( Toybox.WatchUi.loadResource( Rez.Strings.Searching ) );
        } else {
            if ( true == sensor.encrypted ) {
                // If the channel is encrypted display a green encrypted label
                View.findDrawableById( "status" ).setColor( Toybox.Graphics.COLOR_GREEN );
                View.findDrawableById( "status" ).setText( Toybox.WatchUi.loadResource( Rez.Strings.Encrypted ) + sensor.deviceCfg.deviceNumber.toString() );
            } else {
                // If the channel is not encrypted display a red encrypted label
                View.findDrawableById( "status" ).setColor( Toybox.Graphics.COLOR_RED );
                View.findDrawableById( "status" ).setText( Toybox.WatchUi.loadResource( Rez.Strings.Unencrypted ) + sensor.deviceCfg.deviceNumber.toString() );
            }
            // Update the data label value
            View.findDrawableById( "data" ).setText( sensor.data);
        }
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate( dc );
    }

    // A wrapper function to allow the timer to request a screen update
    function updateScreen() {
        WatchUi.requestUpdate();
    }
}