//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;

class EncryptionApp extends Toybox.Application.AppBase {

    // Initializes Encryption Application
    function initialize() {
        AppBase.initialize();
    }

    // Pushes initial view for app
    function getInitialView() {
        return [ new EncryptionView(), new EncryptionDelegate() ];
    }

}
