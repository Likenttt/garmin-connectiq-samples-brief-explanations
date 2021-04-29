using Toybox.Graphics;
using Toybox.Math;
using Toybox.WatchUi;

class ColorWheel extends WatchUi.Drawable {

    var mColors;
    var mIndex;

    function initialize(options) {
        Drawable.initialize(options);
        mColors = options[:colors];
        if(options.hasKey(:index)) {
            mIndex = options[:index];
        }
        else {
            mIndex = 0;
        }
    }

    function draw(dc) {
        var index = mIndex;
        var angle = ( Math.PI * 2 ) / mColors.size();
        var startAngle = Math.PI * ( 3 / 2.0 ) - ( angle / 2.0 );

        // draw the wheel
        for(var i = 0; i < mColors.size(); ++i) {
            if(index == mColors.size()) {
                index = 0;
            }

            dc.setColor(mColors[index], mColors[index]);
            drawArc(dc, dc.getHeight()/2, dc.getWidth()/2, dc.getHeight() / 2 - 5, (i * angle) + startAngle, ((i + 1 ) * angle) + startAngle, true);
            ++index;
        }

        // highlight the selected one
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        drawArc(dc, dc.getHeight()/2, dc.getWidth()/2, dc.getHeight() / 2 - 5, startAngle, startAngle + angle, false);
    }

    function drawArc(dc, centerX, centerY, radius, startAngle, endAngle, fill) {
        var points = new [30];
        var halfHeight = dc.getHeight() / 2;
        var halfWidth = dc.getWidth() / 2;
        var radius2 = ( halfHeight > halfWidth ) ? halfWidth : halfHeight;
        var arcSize = points.size() - 2;
        for(var i = arcSize; i >= 0; --i) {
            var angle = ( i / arcSize.toFloat() ) * ( endAngle - startAngle ) + startAngle;
            points[i] = [halfWidth + radius * Math.cos(angle), halfHeight + radius * Math.sin(angle)];
        }
        points[points.size() - 1] = [halfWidth, halfHeight];

        if(fill) {
            dc.fillPolygon(points);
        }
        else {
            for(var i = 0; i < points.size() - 1; ++i) {
                dc.drawLine(points[i][0], points[i][1], points[i+1][0], points[i+1][1]);
            }
            dc.drawLine(points[points.size()-1][0], points[points.size()-1][1], points[0][0], points[0][1]);
        }
    }

    function setColor(index) {
        mIndex = index;
    }

    function getColor(index) {
        return mColors[index];
    }

    function getNumberOfColors() {
        return mColors.size();
    }

    function getColorIndex(color) {
        for(var i = mColors.size() - 1; i >= 0; --i) {
            if(color==mColors[i]) {
                return i;
            }
        }
        return -1;
    }
}
