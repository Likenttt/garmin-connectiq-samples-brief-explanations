//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class GenericChannelBurstDelegate extends WatchUi.BehaviorDelegate {

    hidden var _channelManager;

    //! Constructor.
    //! @param [BurstChannelManager] aChannelManager The channel manager in use
    function initialize(aChannelManager) {
        _channelManager = aChannelManager;
        BehaviorDelegate.initialize();
    }

    //! Sends a burst message when the menu button is pressed
    function onMenu() {
        _channelManager.sendBurst();
        return true;
    }

}