//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;

// Store reference to View in which the list lives
var currentView = null;

//! Implementation of a CheckBox using Selectable, with the following rules:
//! 1. A CheckBox is "checked" if selected
//! 2. A CheckBox is only "unchecked" if selected again
//! 3. Only one CheckBox may be highlighted at a time
class Checkbox extends WatchUi.Selectable {
    //! Default state Drawable or color/number
    var stateHighlightedSelected;

    //! Constructor
    function initialize(options) {
        Selectable.initialize(options);

        // Set each state value to a Drawable, color/number, or null
        stateHighlightedSelected = options.get(:stateHighlightedSelected);
    }

    //! Special case - handle unhighlighting of a CheckBox
    function unHighlight() {
        // If we were highlighted, returnt to default state
        if(getState() == :stateHighlighted) {
            setState(:stateDefault);
        }
        // If were were highlighted/selected, move to selected state
        else if(getState() == :stateHighlightedSelected) {
            setState(:stateSelected);
        }
    }

    //! Handle onSelectable() returning stateDefault
    function reset(previousState) {
        // If we were highlighted/selected, or selected, move to selected state
        // We only return to the unchecked state if selected again
        if(previousState == :stateSelected) {
            setState(:stateSelected);
        }
        else if(previousState == :stateHighlightedSelected) {
            setState(:stateSelected);
        }
    }

    //! Handle onSelectable() returning stateHighlighted
    function highlight(previousState) {
        // If we were selected, move to highlighted/selected state,
        // otherwise stay in the highlighted state
        if(previousState == :stateSelected) {
            setState(:stateHighlightedSelected);
        }
    }

    //! Handle onSelectable() returning stateSelected
    function select(previousState) {
        // If we were highlighted, move to highlighted/selected state ("checked")
        if(previousState == :stateHighlighted) {
            setState(:stateHighlightedSelected);
        }
        // If were were highlighted/selected state, move to highlighted state
        else if(previousState == :stateHighlightedSelected) {
            setState(:stateHighlighted);
        }
        // If we were selected, move to default state ("unchecked")
        else if(previousState == :stateSelected) {
            setState(:stateDefault);
        }
    }
}

class CheckBoxList {
    // Store references to our list of CheckBoxes
    hidden var list;

    // Store which CheckBox is actively highlighted
    hidden var currentHighlight;

    //! Constructor
    function initialize(dc) {
        currentHighlight = null;

        // Define size of border between CheckBoxes
        var BORDER_PAD = 2;

        // Define our states for each CheckBox
        var checkBoxDefault = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxDefault});
        var checkBoxHighlighted = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxHighlighted});
        var checkBoxSelected = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxSelected});
        var checkBoxHighlightedSelected = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxHighlightedSelected});
        var checkBoxDisabled = Graphics.COLOR_BLACK;

        // Create our array of Selectables
        var dims = checkBoxDefault.getDimensions();
        list = new[3];

        var slideSymbol, spacing, offset, initX, initY;
        if (dc.getHeight() > dc.getWidth()) {
            slideSymbol = :locY;
            spacing = (dc.getHeight() / 4);
            offset = (dims[1] / 2);
            initY = spacing - offset - BORDER_PAD;
            initX = (dc.getWidth() / 2) - (dims[0] / 2);
        } else {
            slideSymbol = :locX;
            spacing = (dc.getWidth() / 4);
            offset = (dims[0] / 2);
            initX = spacing - offset - BORDER_PAD;
            initY = (dc.getHeight() / 2) - (dims[1] / 2);
        }

        // Create the first check-box
        var options = {
            :stateDefault=>checkBoxDefault,
            :stateHighlighted=>checkBoxHighlighted,
            :stateSelected=>checkBoxSelected,
            :stateDisabled=>checkBoxDisabled,
            :stateHighlightedSelected=>checkBoxHighlightedSelected,
            :locX=>initX,
            :locY=>initY,
            :width=>dims[0],
            :height=>dims[1]
            };
        list[0] = new Checkbox(options);

        // Create the second check-box
        options.put(slideSymbol, 2 * spacing - offset);
        list[1] = new Checkbox(options);

        // Create the third check-box
        options.put(slideSymbol, 3 * spacing - offset + BORDER_PAD);
        list[2] = new Checkbox(options);
    }

    //! Return instance of current list of CheckBoxes
    function getList() {
        return list;
    }

    //! General handler for onSelectable() events
    function handleEvent(instance, previousState) {
        // Handle all cases except disabled (handled implicitly)
        if(instance.getState() == :stateHighlighted) {
            // Only one CheckBox may be highlighted
            if((null != currentHighlight) && !currentHighlight.equals(instance)) {
                currentHighlight.unHighlight();
            }

            // Note which checkbox was highlighted
            currentHighlight = instance;
            instance.highlight(previousState);
        }
        else if(instance.getState() == :stateSelected) {
            instance.select(previousState);
        }
        else if(instance.getState() == :stateDefault) {
            instance.reset(previousState);
        }
    }
}

class CheckBoxView extends WatchUi.View {

    // Storage for our CheckBoxList
    var checkBoxes = null;

    //! Constructor
    function initialize() {
        View.initialize();

        // Initialize global reference
        currentView = self;
    }

    //! Load your resources here
    function onLayout(dc) {
        checkBoxes = new CheckBoxList(dc);
        setLayout(checkBoxes.getList());
    }

    //! Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
    }
}
