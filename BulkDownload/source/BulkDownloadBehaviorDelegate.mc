using Toybox.Application.Storage;
using Toybox.Communications;
using Toybox.System;
using Toybox.WatchUi;

class BulkDownloadBehaviorDelegate extends WatchUi.BehaviorDelegate
{
    hidden var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    // Handle selection request
    function onSelect() {

        var hasWiFiSupport = false;
        var hasLteSupport = false;

        var possibleConnection = false;

        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.connectionInfo != null) {
            var wifiStatus = deviceSettings.connectionInfo[:wifi];
            if (wifiStatus != null)
            {
                hasWiFiSupport = true;

                if (wifiStatus.state != System.CONNECTION_STATE_NOT_INITIALIZED)
                {
                    possibleConnection = true;
                }
            }

            var lteStatus = deviceSettings.connectionInfo[:lte];
            if (lteStatus != null)
            {
                hasLteSupport = true;

                if (lteStatus.state != System.CONNECTION_STATE_NOT_INITIALIZED)
                {
                    possibleConnection = true;
                }
            }
        }

        if (possibleConnection) {
            Communications.startSync();
            mView.setText([ "Sync", "Complete" ]);
        } else if (hasWiFiSupport && !hasLteSupport) {
            mView.setText([ "WiFi", "Not", "Configured" ]);
        } else if (!hasWiFiSupport && hasLteSupport) {
            mView.setText([ "LTE", "Not", "Configured" ]);
        } else {
            mView.setText([ "WiFi/LTE", "Not", "Configured" ]);
        }

        WatchUi.requestUpdate();
        return true;
    }

    // Handle menu request
    function onMenu() {
        Storage.deleteValue(ID_COLORS_TO_DOWNLOAD);
        Storage.setValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS, 0);
        mView.setText([ "Reset", "Successful" ]);

        WatchUi.requestUpdate();
        return true;
    }
}
