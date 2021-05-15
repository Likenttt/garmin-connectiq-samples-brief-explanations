using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention;

class AnimationDelegate extends WatchUi.AnimationDelegate {

    var view = null;

    function initialize( v ) {
        view = v;
        WatchUi.AnimationDelegate.initialize();
    }

    function onAnimationEvent(event, options)
    {
        if( event == WatchUi.ANIMATION_EVENT_COMPLETE ) {
            System.println("onComplete: " + view.playCount);
            System.println("play: " + (view.playCount));
            view.play();
        } else if( event == WatchUi.ANIMATION_EVENT_CANCELED ) {
            System.println("canceled");
        }
        else {
            System.println("on unknown event");
        }
    }
}

class AnimationWatchFaceView extends WatchUi.WatchFace {

    var playCount = 0;
    var backgroundAnimationLayer = null;
    var foregroundAnimationLayer = null;
    var drawLayer = null;

    var drawLayerArea = null;
    var partialUpdateClip = null;

    var majorFont = Graphics.FONT_NUMBER_MEDIUM;
    var minorFont = Graphics.FONT_NUMBER_MILD;
    var gap = 10;

    var majorTextOffsetX = 0;
    var majorTextOffsetY = 0;

    var minorTextOffsetX = 0;
    var minorTextOffsetY = 0;

    var rand_base = 0x7FFFFFFF;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        // clear the whole screen with solid color
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        var settings = System.getDeviceSettings();
        var majorFontWidth = Graphics.getFontHeight(majorFont) * 2 / 3;
        var majorFontHeight = Graphics.getFontHeight(majorFont);
        var minorFontWidth = Graphics.getFontHeight(minorFont) * 2 / 3;
        var minorFontHeight = Graphics.getFontHeight(minorFont);

        var drawLayerWidth = majorFontWidth * 5;
        var drawLayerHeight = majorFontHeight + gap + minorFontHeight;

        var partialUpdateWidth = minorFontWidth * 2;
        var partialUpdateHeight = minorFontHeight;

        drawLayerArea = [
            ( settings.screenWidth - drawLayerWidth ) / 2,
            settings.screenHeight / 3,
            drawLayerWidth,
            drawLayerHeight
        ];

        // set the text offsets with in the draw layer
        majorTextOffsetX = drawLayerArea[2] / 2;
        majorTextOffsetY = 0;
        minorTextOffsetX = majorTextOffsetX;
        minorTextOffsetY = majorTextOffsetY + majorFontHeight + gap;

        // partial update clip in the draw layer
        partialUpdateClip = [
            ( drawLayerArea[2] - partialUpdateWidth ) / 2,
            minorTextOffsetY,
            partialUpdateWidth,
            partialUpdateHeight
        ];

        // seed the random number
        Math.srand( 0 );

        // create animation and draw layers
        backgroundAnimationLayer = new WatchUi.AnimationLayer( Rez.Drawables.backgroundmonkey, null );
        drawLayer = new WatchUi.Layer({
            :locX => drawLayerArea[0],
            :locY => drawLayerArea[1],
            :width => drawLayerArea[2],
            :height => drawLayerArea[3]});
        foregroundAnimationLayer = new WatchUi.AnimationLayer( Rez.Drawables.transparentmonkey, null );

        // add the layers to the view
        addLayer( backgroundAnimationLayer );
        addLayer( drawLayer );
        addLayer( foregroundAnimationLayer );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        playCount = 0;
        // start the playback
        play();
    }

    function play() {
        // alternate the playback between foreground and background animations
        if( playCount % 4 == 0 ) {
            backgroundAnimationLayer.setVisible(true);
            backgroundAnimationLayer.play({:delegate=>new AnimationDelegate(self)});
        } else {
            // set the foreground animation to be visible
            foregroundAnimationLayer.setVisible(true);

            // change foreground layer level to play
            // above or below draw layer (clock)
            removeLayer(foregroundAnimationLayer);
            insertLayer(foregroundAnimationLayer, (playCount % 2) + 1 );

            // change the foreground animation playback position,
            // so it can be repositioned across the clock text randomly
            var deltaPercX = Math.rand().toDouble() / rand_base;
            var deltaPercY = Math.rand().toDouble() / rand_base;
            var animatinRez = foregroundAnimationLayer.getResource();
            var x = drawLayerArea[0] + ( drawLayerArea[2] * deltaPercX ).toNumber() - animatinRez.getWidth() / 2;
            var y = drawLayerArea[1] + ( drawLayerArea[3] * deltaPercY ).toNumber() - animatinRez.getHeight() / 2;
            // reset the x and z (layer) to the new coordinates
            foregroundAnimationLayer.setLocation(x,y);
            // start the playback
            foregroundAnimationLayer.play({:delegate=>new AnimationDelegate(self)});
        }
        playCount += 1;
    }

    function onUpdate(dc) {
        // Update the entire draw layer
        updateWatchOverlay(true);
    }

    function onPartialUpdate(dc) {
        // Only update the second digit
        updateWatchOverlay(false);
    }

    function updateWatchOverlay(isFullUpdate) {
        if( drawLayer == null ) {
            return;
        }
        var drawLayerDc = drawLayer.getDc();
        if( drawLayerDc == null ) {
            // dc not avaialbe
            return;
        }

        // Get and overlay the current time on top of the animation background
        var clockTime = System.getClockTime();
        var hourMinString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var secString = Lang.format( "$1$", [clockTime.sec.format("%02d")] );

        if( isFullUpdate ) {
            // Full update, clear the layer clip
            drawLayerDc.clearClip();
        } else {
            // partial update, updat the second digits only
            drawLayerDc.setClip(
                partialUpdateClip[0],
                partialUpdateClip[1],
                partialUpdateClip[2],
                partialUpdateClip[3] );
        }

        // clear the clip region with transparent background color, so the animation rendered in the background
        // can be seen through the overlay
        drawLayerDc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        drawLayerDc.clear();

        // draw clock text
        if( isFullUpdate ) {
            // only re-draw hour/min during full update
            drawLayerDc.drawText( majorTextOffsetX, majorTextOffsetY, majorFont, hourMinString, Graphics.TEXT_JUSTIFY_CENTER );
        }
        drawLayerDc.drawText( minorTextOffsetX, minorTextOffsetY, minorFont, secString, Graphics.TEXT_JUSTIFY_CENTER );
    }

    function onHide() {
        // invoke default View.onHide() which will stop all animations
        View.onHide();
    }

    function onExitSleep() {
        // reset the play count and start playing the animations
        playCount = 0;
        play();
    }

    function onEnterSleep() {
        // animation playback will be stopped by system
        // after entering sleep mode
        if( foregroundAnimationLayer != null ) {
            // set the froeground animation to be invisible so it won't block the clock text
            foregroundAnimationLayer.setVisible(false);
        }
    }
}
