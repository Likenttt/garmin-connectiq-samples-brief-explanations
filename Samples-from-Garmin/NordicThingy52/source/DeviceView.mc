using Toybox.WatchUi;
using Toybox.StringUtil as Util;

class DeviceView extends WatchUi.View {
    private var _dataModel;

    function initialize( dataModel ) {
        View.initialize();

        _dataModel = dataModel;
    }

    function onUpdate(dc) {
        var bkgnd;
        var statusString;

        if( _dataModel.isConnected() ) {
            statusString = "Connected";
        } else {
            statusString = "Disconnected";
        }

        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_WHITE );
        dc.clear();

        dc.drawText( dc.getWidth() / 2,
            15,
            Graphics.FONT_SMALL,
            statusString,
            Graphics.TEXT_JUSTIFY_CENTER);

        if( _dataModel.isConnected() ) {
            drawIndicator(
                dc,
                Rez.Drawables.TempInd,
                _dataModel.getActiveProfile().getTemperature(),
                "%.2f",
                "°C",
                0);

            drawIndicator(
                dc,
                Rez.Drawables.PressureInd,
                _dataModel.getActiveProfile().getPressure(),
                "%.2f",
                "hPa",
                1);

            drawIndicator(
                dc,
                Rez.Drawables.HumidityInd,
                _dataModel.getActiveProfile().getHumidity(),
                "%d",
                "%",
                2);

            drawIndicator(
                dc,
                Rez.Drawables.Co2Ind,
                _dataModel.getActiveProfile().getEco2(),
                "%d",
                "ppm",
                3);
            drawIndicator(
                dc,
                Rez.Drawables.LeafInd,
                _dataModel.getActiveProfile().getTvoc(),
                "%d",
                "ppb",
                4);
        }
    }

    private function drawIndicator( dc, bitmap, value, format, units, cell ) {
        var gridOffset = dc.getFontHeight( Graphics.FONT_SMALL ) + 15;
        var cellHeight = (dc.getHeight() - (2 * gridOffset)) / 2;

        var cellWidth;
        var cellY;
        var cellX;
        var cellXOffset;

        if( cell < 3 ) {
            cellWidth = dc.getWidth() / 3;
            cellY = gridOffset;
            cellXOffset = 0;
        }
        else {
            cell -= 3;
            cellXOffset = dc.getWidth() / 6;
            cellWidth = ( dc.getWidth() - ( 2 * cellXOffset ) ) / 2;
            cellY = gridOffset + cellHeight;
        }

        cellX = cellXOffset + ( cellWidth * cell );

        var image = WatchUi.loadResource( bitmap );
        var label = "";
        if( value != null ) {
            label += value.format(format);
        }

        var imageOffset = cellX + ( cellWidth / 2 ) - ( image.getWidth() / 2 );

        dc.drawBitmap( imageOffset,
            cellY,
            image);

        dc.drawText( cellX + ( cellWidth /2 ),
            cellY + image.getHeight() - 5,
            Graphics.FONT_SYSTEM_XTINY,
            label,
            Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText( cellX + ( cellWidth /2 ),
            cellY + image.getHeight() + dc.getFontHeight( Graphics.FONT_SYSTEM_XTINY ) - 8,
            Graphics.FONT_SYSTEM_XTINY,
            units,
            Graphics.TEXT_JUSTIFY_CENTER);
    }
}
