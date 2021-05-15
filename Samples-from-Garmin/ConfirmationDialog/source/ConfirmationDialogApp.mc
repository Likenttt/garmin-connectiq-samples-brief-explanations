//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;
using Toybox.WatchUi;

var instructionString;
var resultString;
var dialogHeaderString;
var confirmString;
var cancelString;

class ConfirmationDialogApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        instructionString = WatchUi.loadResource(Rez.Strings.TestInfo);
        resultString = WatchUi.loadResource(Rez.Strings.DefaultResponse);
        dialogHeaderString = WatchUi.loadResource(Rez.Strings.DialogHeader);
        confirmString = WatchUi.loadResource(Rez.Strings.Confirm);
        cancelString = WatchUi.loadResource(Rez.Strings.Cancel);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [new ConfirmationDialogView(), new BaseInputDelegate()];
    }

}