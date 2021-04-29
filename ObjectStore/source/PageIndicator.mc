//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Graphics;

class PageIndicator {

    var ALIGN_BOTTOM_RIGHT = 0;
    var ALIGN_BOTTOM_LEFT = 1;
    var ALIGN_TOP_RIGHT = 2;
    var ALIGN_TOP_LEFT = 3;

    var mSize, mSelectedColor, mNotSelectedColor, mAlignment, mMargin;

    function setup(size, selectedColor, notSelectedColor, alignment, margin) {
        mSize = size;
        mSelectedColor = selectedColor;
        mNotSelectedColor = notSelectedColor;
        mAlignment = alignment;
        mMargin = margin;
    }

    function draw(dc, selectedIndex) {
        var height = 10;
        var width = mSize * height;
        var x = 0;
        var y = 0;

        if (mAlignment == ALIGN_BOTTOM_RIGHT) {
            x = dc.getWidth() - width - mMargin;
            y = dc.getHeight() - (height / 2) - mMargin;

        } else if (mAlignment == ALIGN_BOTTOM_LEFT) {
            x = 0 + mMargin;
            y = dc.getHeight() - (height / 2) - mMargin;

        } else if (mAlignment == ALIGN_TOP_RIGHT) {
            x = dc.getWidth() - width - mMargin;
            y = 0 + mMargin + (height / 2);

        } else if (mAlignment == ALIGN_TOP_LEFT) {
            x = 0 + mMargin;
            y = 0 + mMargin + (height / 2);
        } else {
            x = 0;
            y = 0;
        }

        for (var i=0; i<mSize; i+=1) {
            if (i == selectedIndex) {
                dc.setColor(mSelectedColor, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(mNotSelectedColor, Graphics.COLOR_TRANSPARENT);
            }

            var tempX = (x + (i * height)) + height / 2;
            dc.fillCircle(tempX, y, height / 2);
        }
    }

}
