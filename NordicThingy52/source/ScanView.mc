using Toybox.WatchUi;
using Toybox.Graphics;

class ScanView extends WatchUi.View {
    hidden var _scanDataModel;

    function initialize( scanDataModel ) {
        View.initialize();

        _scanDataModel = scanDataModel;
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        var displayResult = _scanDataModel.getDisplayResult();

        var str = "Device: "
            + _scanDataModel.getDisplayIndex()
            + "/"
            + _scanDataModel.getResultCount();

        if( null != displayResult ) {
            str += "\nName:\n"
                + displayResult.getDeviceName()
                + "\nRSSI: "
                + displayResult.getRssi() + " dbm";
        }

        var strDimen = dc.getTextDimensions( str, Graphics.FONT_SMALL );
        var textOffset = dc.getHeight() / 2;
        textOffset -= strDimen[1] / 2;

        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_WHITE );
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2,
            textOffset,
            Graphics.FONT_SMALL,
            str,
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
