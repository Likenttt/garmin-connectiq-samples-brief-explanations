//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class ConfirmationDialogView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.mainLayout(dc));
        onUpdate(dc);
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onUpdate(dc) {
        var resultLabel = View.findDrawableById("ResultLabel");
        resultLabel.setText(resultString);

        View.onUpdate(dc);
    }

}
