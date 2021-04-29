//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Graphics;

class PageIndicator {

    enum {
        ALIGN_BOTTOM_RIGHT,
        ALIGN_BOTTOM_LEFT,
        ALIGN_BOTTOM_CENTER,
        ALIGN_TOP_RIGHT,
        ALIGN_TOP_LEFT,
        ALIGN_TOP_CENTER
    }

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
            y = dc.getHeight() - height - mMargin;
        } else if (mAlignment == ALIGN_BOTTOM_LEFT) {
            x = 0 + mMargin;
            y = dc.getHeight() - height - mMargin;
        } else if (mAlignment == ALIGN_BOTTOM_CENTER) {
            x = (dc.getWidth() / 2) - (width / 2);
            y = dc.getHeight() - height - mMargin;
        }  else if (mAlignment == ALIGN_TOP_RIGHT) {
            x = dc.getWidth() - width - mMargin;
            y = 0 + mMargin;
        } else if (mAlignment == ALIGN_TOP_LEFT) {
            x = 0 + mMargin;
            y = 0 + mMargin;
        } else if (mAlignment == ALIGN_TOP_CENTER) {
            x = (dc.getWidth() / 2) - (width / 2);
            y = 0 + mMargin;
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
