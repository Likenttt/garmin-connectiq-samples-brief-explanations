//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Sensor;
using Toybox.Timer;
using Toybox.Math;

class AccelMagView extends WatchUi.View {
    const r = 10;
    const incrFrict = 15;
    const pcntFrict = 99;
    const wallLoss = 80;
    const arrowLen = 25.0;
    const hitForce = 50.0;
    const velocityToPix = 0.004; // 1/250

    var dataTimer;
    var x;
    var y;
    var xVelocity;
    var yVelocity;
    var width;
    var height;
    var xMult;
    var yMult;

    var accel;
    var mag;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        dataTimer = new Timer.Timer();
        dataTimer.start(method(:timerCallback), 100, true);

        width = dc.getWidth();
        height = dc.getHeight();
        x = width / 2;
        y = height / 2;
        xVelocity = 0;
        yVelocity = 0;
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.fillCircle(x.toNumber(), y.toNumber(), r);

        if (mag != null) {
            var xArrow;
            var yArrow;
            var xArrowTail;
            var yArrowTail;

            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_LT_GRAY);

            //Draw arrow stem
            xArrow = x - xMult * arrowLen;
            yArrow = y - yMult * arrowLen;
            dc.drawLine(xArrow, yArrow, x, y);

            //Draw first arrow tail
            xArrowTail = x + yMult * arrowLen / 2;
            yArrowTail = y - xMult * arrowLen / 2;
            xArrowTail = (xArrowTail + xArrow) / 2;
            yArrowTail = (yArrowTail + yArrow) / 2;
            dc.drawLine(xArrowTail, yArrowTail, x, y);

            //Draw second arrow tail
            xArrowTail = x - yMult * arrowLen / 2;
            yArrowTail = y + xMult * arrowLen / 2;
            xArrowTail = (xArrowTail + xArrow) / 2;
            yArrowTail = (yArrowTail + yArrow) / 2;
            dc.drawLine(xArrowTail, yArrowTail, x, y);
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (accel != null) {
            dc.drawText(width / 2,  3, Graphics.FONT_TINY, "Ax = " + accel[0], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 23, Graphics.FONT_TINY, "Ay = " + accel[1], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 43, Graphics.FONT_TINY, "Az = " + accel[2], Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width / 2, 3, Graphics.FONT_TINY, "no Accel", Graphics.TEXT_JUSTIFY_CENTER);
        }

        if (mag != null) {
            dc.drawText(width / 2, height - 70, Graphics.FONT_TINY, "Mx = " + mag[0], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, height - 50, Graphics.FONT_TINY, "My = " + mag[1], Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, height - 30, Graphics.FONT_TINY, "Mz = " + mag[2], Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width /2, height - 30, Graphics.FONT_TINY, "no Mag", Graphics.TEXT_JUSTIFY_CENTER);
        }

    }

    function timerCallback() {
        var info = Sensor.getInfo();

        if (info has :accel && info.accel != null) {
            accel = info.accel;
            var xAccel = accel[0];
            var yAccel = accel[1] * -1; // Cardinal Y direction is opposite the screen coordinates

            //Ignore low acceleration values
            if (xAccel > incrFrict || xAccel < -1 * incrFrict) {
                xVelocity += xAccel;
            }
            if (yAccel > incrFrict || yAccel < -1 * incrFrict) {
                yVelocity += yAccel;
            }

            //Apply some friction
            xVelocity = xVelocity * pcntFrict / 100;
            yVelocity = yVelocity * pcntFrict / 100;
            if (xVelocity > incrFrict) {
                xVelocity -= incrFrict;
            } else if (xVelocity < -1 * incrFrict) {
                xVelocity += incrFrict;
            } else {
                xVelocity = 0;
            }

            if (yVelocity > incrFrict) {
                yVelocity -= incrFrict;
            } else if (yVelocity < -1 * incrFrict) {
                yVelocity += incrFrict;
            } else {
                yVelocity = 0;
            }


            //Move the ball
            x += (xVelocity * velocityToPix);
            y += (yVelocity * velocityToPix);

            //Check for wall collisions
            if (x < (0 + r)) {
                x = 2 * r - x;
                xVelocity *= -1;
                xVelocity = xVelocity * wallLoss / 100; // remove some energy when bouncing
            } else if (x >= (width - r)) {
                x = 2 * (width - r) - x;
                xVelocity *= -1;
                xVelocity = xVelocity * wallLoss / 100; // remove some energy when bouncing
            }

            if (y < (0 + r)) {
                y = 2 * r - y;
                yVelocity *= -1;
                yVelocity = yVelocity * wallLoss / 100; // remove some energy when bouncing
            } else if (y >= (height - r)) {
                y = 2 * (height - r) - y;
                yVelocity *= -1;
                yVelocity = yVelocity * wallLoss / 100; // remove some energy when bouncing
            }
        }

        if (info has :mag && info.mag != null) {
            mag = info.mag;
            var xMag = mag[0];
            var yMag = mag[1] * -1; // Cardinal Y direction is opposite the screen coordinates

            var magMagnitude = Math.sqrt(Math.pow(xMag,2) + Math.pow(yMag,2));

            if (magMagnitude != 0) {
                xMult = xMag / magMagnitude;
                yMult = yMag / magMagnitude;
            } else {
                xMult = 0;
                yMult = 0;
            }
        }

        WatchUi.requestUpdate();
    }

    function kickBall()
    {
        if (mag != null) {
            xVelocity += (xMult * hitForce / velocityToPix).toNumber();
            yVelocity += (yMult * hitForce / velocityToPix).toNumber();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }
}
