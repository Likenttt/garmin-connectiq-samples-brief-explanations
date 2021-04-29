using Toybox.Application;
using Toybox.Application.Storage;

const ID_TOTAL_SUCCESSFUL_DOWNLOADS = 's';
const ID_COLORS_TO_DOWNLOAD = 'p';

class BulkDownloadApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // getSyncDelegate is called by the system when a request is made
    // to start a bulk data sync via Communications.startSync()
    function getSyncDelegate() {
        return new BulkDownloadDelegate();
    }

    // Return the initial view of your application here
    function getInitialView() {

        // Initialize the successful download count to 0
        var successfulDownloads = Storage.getValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS);
        if (successfulDownloads == null) {
            Storage.setValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS, 0);
        }

        var view = new BulkDownloadView();
        return [view, new BulkDownloadBehaviorDelegate(view)];
    }

}
