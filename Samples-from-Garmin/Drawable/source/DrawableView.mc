//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;

class MyWatchView extends WatchUi.View {

    var train;
    var backdrop;
    var cloud;

    // Constructor
    function initialize() {
        View.initialize();
        train = new Rez.Drawables.train();
        backdrop = new Rez.Drawables.backdrop();
        cloud = new WatchUi.Bitmap({:rezId=>Rez.Drawables.cloud,:locX=>10,:locY=>30});
    }

    // Load your resources here
    function onLayout(dc) {
        WatchUi.animate( cloud, :locX, WatchUi.ANIM_TYPE_LINEAR, 10, dc.getWidth() + 50, 10, null );
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        backdrop.draw(dc);
        train.draw(dc);
        cloud.draw(dc);
    }

}
