//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Graphics;
using Toybox.System;


// A simple line graph drawing class
class LineGraph {
    hidden var graphArray;
    hidden var graphIndex;
    hidden var graphRange;
    hidden var graphMinRange;
    hidden var graphColor;

    // Constructor
    function initialize(size, minRange, color) {
        graphIndex = 0;
        graphRange = [null,null];

        if (size < 2) {
            System.error( "graph size less than 2 is not allowed" );
        }
        graphArray = new [size];
        graphMinRange = minRange;
        graphColor = color;
    }

    // Set graph line color
    function setColor(color) {
        graphColor = color;
    }

    // Set graph line color
    function setMinRange(minRange) {
        graphMinRange = minRange;
    }

    function addItem(value) {
        var updateMin = false;
        var updateMax = false;

        if (value instanceof Number || value instanceof Float) {
            if (graphRange[0] == null) {
                // This is our first value, save as min and max
                graphRange[0] = value;
                graphRange[1] = value;
            }

            // Save value if it is a new minimum
            if (value < graphRange[0]) {
                graphRange[0] = value;
            } else if (graphArray[graphIndex] == graphRange[0]) {
                updateMin = true;
            }
            // Save value if it is a new maximum
            if (value > graphRange[1]) {
                graphRange[1] = value;
            } else if (graphArray[graphIndex] == graphRange[1]) {
                updateMax = true;
            }

            //Fill in new Graph value
            graphArray[graphIndex] = value;
            //Increment and wrap graph index
            graphIndex += 1;
            if (graphIndex == graphArray.size()) {
                graphIndex = 0;
            }

            if(updateMin) {
                var i;
                var min = graphArray[0];
                for (i = 1; i < graphArray.size(); i += 1) {
                    if (graphArray[i] < min) {
                        min = graphArray[i];
                    }
                }
                graphRange[0] = min;
            }

            if (updateMax) {
                var i;
                var max = graphArray[0];
                for (i = 1; i < graphArray.size(); i += 1) {
                    if (graphArray[i] > max) {
                        max = graphArray[i];
                    }
                }
                graphRange[1] = max;
            }
        } else {
            // This isn't allowed
        }

    }

    // Handle the update event
    function draw(dc, topLeft, bottomRight) {
        var min;
        var range;
        var y;
        var x;
        var prev_y;
        var prev_x;
        var drawExtentsX = bottomRight[0] - topLeft[0] + 1;
        var drawExtentsY = bottomRight[1] - topLeft[1] + 1;
        var i;
        var draw_idx = 1;

        var string = "[";
        string += topLeft[0].toString();
        string += ",";
        string += topLeft[1].toString();
        string += "] [";
        string += bottomRight[0].toString();
        string += ",";
        string += bottomRight[1].toString();
        string += "]\n";

        // If the graph range is null, no values have been added yet
        if (graphRange[0] != null) {
            //Set Graph color       !!!no way to preserve color setting right now?
            dc.setColor(graphColor, graphColor);

            //Determine Graph minimum and range
            min = graphRange[0];
            range = graphRange[1] - graphRange[0];
            range = range.toFloat();

            if (range < graphMinRange) {
                min -= (graphMinRange - range) / 2;
                range = graphMinRange;
            }

            prev_x = topLeft[0];
            x = topLeft[0] + drawExtentsX * draw_idx / (graphArray.size() -  1);
            y = null;
            for (i = graphIndex; i < graphArray.size(); i += 1) {
                if(graphArray[i] != null) {
                    prev_y = y;
                    y = bottomRight[1] - ((graphArray[i] - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if (prev_y != null) {
                        dc.drawLine(prev_x, prev_y, x, y);
                        prev_x = x;
                        draw_idx += 1;
                        x = topLeft[0] + drawExtentsX * draw_idx / (graphArray.size() - 1);
                    }
                }
            }
            for (i = 0; i < graphIndex; i += 1) {
                if (graphArray[i] != null) {
                    prev_y = y;
                    y = bottomRight[1] - ((graphArray[i] - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if (prev_y != null) {
                        dc.drawLine(prev_x, prev_y, x, y);
                        prev_x = x;
                        draw_idx += 1;
                        x = topLeft[0] + drawExtentsX * draw_idx / (graphArray.size() - 1);
                    }
                }
            }
        }
    }
}
