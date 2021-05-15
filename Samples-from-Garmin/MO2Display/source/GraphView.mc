//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

class GraphView extends WatchUi.View {

    hidden var mIndex;
    hidden var mIndicator;
    hidden var mSensor;
    hidden var mFonts;
    hidden var mTotalGraph;
    hidden var mCurrentGraph;

    function initialize(sensor, index) {
        WatchUi.View.initialize();

        mIndex = index;

        mIndicator = new PageIndicator();
        var size = 4;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = mIndicator.ALIGN_BOTTOM_RIGHT;
        mIndicator.setup(size, selected, notSelected, alignment, 0);

        mTotalGraph = new LineGraph(30, 10, Graphics.COLOR_RED);
        mCurrentGraph = new LineGraph(30, 1, Graphics.COLOR_BLUE);
        mFonts = [Graphics.FONT_SMALL, Graphics.FONT_MEDIUM, Graphics.FONT_LARGE];

        mSensor = sensor;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        mTotalGraph.addItem(mSensor.data.totalHemoConcentration.toFloat());
        mCurrentGraph.addItem(mSensor.data.currentHemoPercent.toFloat());

        if (mSensor.data.totalHemoConcentration != null) {
            var totalString = mSensor.data.totalHemoConcentration.format("%0.2f");
            var font = pickFont( dc, totalString, width / 4 );
            var fWidth = dc.getTextWidthInPixels(totalString, font);

            //Draw HR value with drop shadow
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2) + 1, (height / 2) - 4 + 1, font, totalString, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2, (height / 2) - 4, font, totalString, Graphics.TEXT_JUSTIFY_CENTER);
            var numberXPos = (width/2) + 1 + ( fWidth/2 );

            totalString = "Total";
            font = pickFont(dc, totalString, width/5);
            //Draw with drop shadow
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2) + 1, (height / 3) + 1, font, totalString, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2), (height / 3), font, totalString, Graphics.TEXT_JUSTIFY_CENTER);

            //use smallest font for "g / dl"
            font = mFonts[0];
            totalString = "g / dl";
            //Draw with drop shadow
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(numberXPos + 2 + 1, (height / 2) - 4 + 1, font, totalString, Graphics.TEXT_JUSTIFY_LEFT);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(numberXPos + 2, (height / 2) - 4, font, totalString, Graphics.TEXT_JUSTIFY_LEFT);

            //We should have thick lines eventually... this is a hack for now.
            mTotalGraph.draw(dc, [(width / 4) + 2, 3], [width - 3, (height / 2) - 3]);
            mTotalGraph.draw(dc, [(width / 4) + 2 + 1, 3], [width - 3 + 1, (height / 2) - 3]);
            mTotalGraph.draw(dc, [(width / 4) + 2, 3 + 1], [width - 3, (height / 2) - 3 + 1]);
            mTotalGraph.draw(dc, [(width / 4) + 2 + 1, 3 + 1], [width - 3 + 1, (height / 2) - 3 + 1]);
        }

        if (mSensor.data.currentHemoPercent != null) {
            var currentString = mSensor.data.currentHemoPercent.format("%0.1f");
            var font = pickFont(dc, currentString, width / 4);
            var fWidth = dc.getTextWidthInPixels(currentString, font);
            var numberFHeight = dc.getFontHeight(font);
            var numberYPos = height - numberFHeight + 1;

            //Draw mSensor.data.currentHemoPercent value with drop shadow
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2)+1, numberYPos, font, currentString, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2), numberYPos - 1, font, currentString, Graphics.TEXT_JUSTIFY_CENTER);
            var numberXPos = (width/2) + 1 + ( fWidth/2 );

            currentString = "Current";
            font = pickFont(dc, currentString, width/5);
            var fHeight = dc.getFontHeight(font);

            //Draw with drop shadow
            dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.drawText((width/2)+1, height - (fHeight + (numberFHeight-1)) + 1, font, currentString, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2, height - (fHeight + (numberFHeight-1)), font, currentString, Graphics.TEXT_JUSTIFY_CENTER);

            //use smallest font for "percent"
            font = mFonts[0];
            currentString = "%";
            fHeight = dc.getFontHeight(font);

            //Draw with drop shadow
            dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(numberXPos + 2 + 1, numberYPos, font, currentString, Graphics.TEXT_JUSTIFY_LEFT);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(numberXPos + 2, numberYPos - 1, font, currentString, Graphics.TEXT_JUSTIFY_LEFT);

            //We should have thick lines eventually... this is a hack for now.
            mCurrentGraph.draw(dc, [(width / 4) + 2, height / 2], [width - 3, height - 3]);
            mCurrentGraph.draw(dc, [(width / 4) + 2 + 1, height / 2], [width - 3 + 1, height - 3]);
            mCurrentGraph.draw(dc, [(width / 4) + 2, height / 2 + 1], [width - 3, height - 3 + 1]);
            mCurrentGraph.draw(dc, [(width / 4) + 2 + 1, height / 2 + 1], [width - 3 + 1, height - 3 + 1]);
        }

        // Draw the page indicator
        mIndicator.draw(dc, mIndex);
    }

    function pickFont(dc, string, width) {
        var i = mFonts.size() - 1;

        while (i > 0) {
            if (dc.getTextWidthInPixels(string, mFonts[i]) <= width) {
                return mFonts[i];
            }
            i -= 1;
        }

        return mFonts[0];
    }
}
