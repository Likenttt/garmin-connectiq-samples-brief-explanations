using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Storage;

class BulkDownloadView extends WatchUi.View {

    hidden var mLines;

    function initialize() {
        View.initialize();
        mLines = [ "Start/Stop to Sync", "Menu to Reset" ];
    }

    // Display text and successful download count
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var font = Graphics.FONT_SMALL;
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var dy = dc.getFontHeight(font);

        cy -= (mLines.size() * dy) / 2;
        for (var i = 0; i < mLines.size(); ++i) {
            dc.drawText(cx, cy, font, mLines[i], Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            cy += dy;
        }

        var successfulDownloads = Storage.getValue(ID_TOTAL_SUCCESSFUL_DOWNLOADS);
        if (successfulDownloads > 0) {
            var downloadStatus = Lang.format("$1$ downloaded", [ successfulDownloads ]);
            dc.drawText(cx, cy, font, downloadStatus, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    // Set an array of String to display
    function setText(displayText) {
        mLines = displayText;
        WatchUi.requestUpdate();
    }
}
