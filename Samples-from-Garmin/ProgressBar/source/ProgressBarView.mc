//!
//! Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class MyWatchView extends WatchUi.View
{

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc)
    {
        var string;

        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
        dc.clear();
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
        string = "Push 'Menu'\n to select progress bar\n to test";
        dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
    }

}

class ProgressDelegate extends WatchUi.BehaviorDelegate
{
    var mCallback;
    function initialize(callback) {
        mCallback = callback;
        BehaviorDelegate.initialize();
    }

    function onBack() {
        mCallback.invoke();
        return true;
    }
}

class MenuInputDelegate extends WatchUi.MenuInputDelegate {

    var progressBar;
    var transparentSpinner;
    var timer;
    var count;

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( timer == null ) {
            timer = new Timer.Timer();
        }
        count = 0;

        if (item == :ProgressBar) {
            progressBar = new WatchUi.ProgressBar( "Processing", null );
            WatchUi.pushView( progressBar, new ProgressDelegate(method(:stopTimer)), WatchUi.SLIDE_DOWN );
            timer.start( method(:timerCallback), 1000, true );
        } else if (item == :TransparentProgressBar) {
            if( Toybox.WatchUi has :TransparentProgressBar ) {
                transparentSpinner = new WatchUi.TransparentProgressBar({});
                WatchUi.pushView( transparentSpinner, new ProgressDelegate(method(:stopTimer)), WatchUi.SLIDE_DOWN );
                timer.start( method(:spinnerCallback), 5000, true );
            }
        }
    }

    function stopTimer() {
        if( timer != null ) {
            timer.stop();
        }
    }

    function spinnerCallback() {
        timer.stop();
        WatchUi.popView( WatchUi.SLIDE_UP );
    }

    function timerCallback()
    {
        count += 1;

        if( count > 17 )
        {
            timer.stop();
            WatchUi.popView( WatchUi.SLIDE_UP );
        }
        else if( count > 15 )
        {
            progressBar.setDisplayString( "Complete" );
        }
        else if( count > 5 )
        {
            progressBar.setProgress( (count - 5) * 10 );
        }
    }
}

class InputDelegate extends WatchUi.BehaviorDelegate
{

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.ProgressBarMenu(), new MenuInputDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
