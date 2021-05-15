using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

class PickerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart(state) {
        // make sure that there is a valid color in the object store to
        // prevent null checks in several places
        if(getProperty("color") == null) {
            setProperty("color", Graphics.COLOR_RED);
        }
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new PickerView(), new PickerDelegate() ];
    }

}
