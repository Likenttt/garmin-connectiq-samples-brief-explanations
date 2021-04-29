using Toybox.Communications;
using Toybox.Application.Storage;

class BulkDownloadDelegate extends Communications.SyncDelegate
{
    hidden var mColors; // Array

    hidden var mColorsDownloaded;
    hidden var mColorsToDownload;

    // Initialize
    function initialize() {
        SyncDelegate.initialize();

        mColors = Storage.getValue(ID_COLORS_TO_DOWNLOAD);
        if (mColors == null) {
            mColors = [
                0xFFFFFF,
                0xAAAAAA,
                0x555555,
                0xFF0000,
                0xAA0000,
                0xFF5500,
                0xFFAA00,
                0x00FF00,
                0x00AA00,
                0x00AAFF,
                0x0000FF,
                0xAA00FF,
                0xFF00FF,
            ];
        }

        mColorsDownloaded = 0;
        mColorsToDownload = 0;
    }

    // Called by the system to determine if a sync is needed.
    function isSyncNeeded() {
        return mColors.size() != 0;
    }

    // Called by the system when starting a bulk sync.
    function onStartSync() {
        mColorsToDownload = mColors.size();

        startNextDownload();
    }

    // Called by the system when finishing a bulk sync.
    function onStopSync() {
        Communications.cancelAllRequests();
        Communications.notifySyncComplete(null);
    }

    // Start processing the next download, or terminate syncing.
    function startNextDownload() {
        if (mColors.size() == 0) {
            Communications.notifySyncComplete(null);
        }
        else {
            downloadColor(mColors[0]);
        }
    }

    // Initiate a request to download an image of the given color
    function downloadColor(colorId) {
        var params = {
        };

        var options = {
            :dithering => Communications.IMAGE_DITHERING_NONE
        };

       var deviceSettings = System.getDeviceSettings();

        var downloadUrl = Lang.format("https://dummyimage.com/$1$x$2$/$3$.png", [
            deviceSettings.screenWidth,
            deviceSettings.screenHeight,
            colorId.format("%06X")
        ]);

        // create a request delegate so we can associate colorId with the
        // downloaded image
        var requestDelegate = new BulkDownloadRequestDelegate(self.method(:onDownloadComplete), colorId);
        requestDelegate.makeImageRequest(downloadUrl, params, options);
    }

    // Handle download completion
    function onDownloadComplete(code, data, colorId) {
        if (code == 200) {

            // we could save the image data to Application.Storage, but we don't
            // need to do that in this sample
            // Storage.setValue(colorId, data);

            // download was successful, so remove it from the pending list
            mColors = mColors.slice(1, null);
            Storage.setValue(ID_COLORS_TO_DOWNLOAD, mColors);

            // cache the count of successful downloads
            var successfulDownloads = Storage.getValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS);
            ++successfulDownloads;
            Storage.setValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS, successfulDownloads);

            // update the progress indicator
            ++mColorsDownloaded;
            Communications.notifySyncProgress((100 * mColorsDownloaded) / mColorsToDownload);

            // start the next download, or terminate syncing
            startNextDownload();
        }
        else {
            Communications.notifySyncComplete(Lang.format("Error: $1$", [ code ]));
        }
    }
}
