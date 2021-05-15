using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

class JsonDataResourcesView extends WatchUi.View {

    hidden var mCurLoadedJsonResource = null;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        //Clear the view
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var headerText = "Press Menu";
        dc.drawText(dc.getWidth()/2,0, Graphics.FONT_XTINY, headerText, Graphics.TEXT_JUSTIFY_CENTER);

        if(null != mCurLoadedJsonResource) {
            //Draw the current loaded JSON record as text on the screen
            dc.drawText(0, dc.getFontHeight(Graphics.FONT_XTINY) + 2, Graphics.FONT_XTINY, getDisplayString(mCurLoadedJsonResource), Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    //Get a displayable string for the current object
    function getDisplayString(item) {
        var displayString = null;
        if(item instanceof Toybox.Lang.Array) {
            displayString = getArrayDisplayString(item);
        } else if(item instanceof Toybox.Lang.Dictionary) {
            displayString = getDictionaryDisplayString(item);
        } else {
            displayString = "Simple Value\n";
            displayString += item.toString();
        }

        return displayString;
    }

    //Get a display string for an array
    function getArrayDisplayString(array) {
        var displayString = "Array JSON Resource\n";
        displayString += "[\n";
        for(var index = 0; index < array.size(); index++) {

            displayString += array[index].toString();

            if(index < (array.size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "]\n";

        return displayString;
    }

    //Get a display string for a dictionary
    function getDictionaryDisplayString(dictionary) {
        var displayString = "Dictionary JSON Resource\n";
        displayString += "{\n";
        for(var index = 0; index < dictionary.keys().size(); index++) {
            var key = dictionary.keys()[index];
            var value = dictionary[key];

            displayString += key + "=>" + value.toString();

            if(index < (dictionary.keys().size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "}\n";

        return displayString;
    }

    //Load a JSON resource record into mCurLoadedResource
    function loadJsonRecord(resourceId) {
        mCurLoadedJsonResource = WatchUi.loadResource(resourceId);
        WatchUi.requestUpdate();
    }

}
