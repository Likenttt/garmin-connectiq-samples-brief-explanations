using Toybox.WatchUi as Ui;

class MapSampleMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( item == :view_map ) {
            var mapview = new MapSampleMapView();
            Ui.pushView(mapview, new MapSampleMapDelegate(mapview), Ui.SLIDE_UP);
        }
        if( item == :track_map ) {
            var trackview = new MapSampleTrackView();
            Ui.pushView(trackview, new MapSampleMapDelegate(trackview), Ui.SLIDE_UP);
        }
        else {
            WatchUi.requestUpdate();
        }
    }
}