//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Background;
using Toybox.System;
using Toybox.Application.Storage;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system. This indicates a set timer has expired, and
// we should attempt to notify the user.
(:background)
class BackgroundTimerServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    // If our timer expires, it means the application timer ran out,
    // and the main application is not open. Prompt the user to let them
    // know the timer expired.
    function onTemporalEvent() {

        // Use background resources if they are available
        if (Application has :loadResource) {
            Background.requestApplicationWake(Application.loadResource(Rez.Strings.TimerExpired));
        } else {
            Background.requestApplicationWake("Your timer has expired!");
        }

        // Write to Storage, this will trigger onStorageChanged() method in foreground app
        Storage.setValue("1", 1);

        Background.exit(true);
    }
}
