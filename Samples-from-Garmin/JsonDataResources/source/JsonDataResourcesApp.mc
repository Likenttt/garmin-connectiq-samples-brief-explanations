using Toybox.Application;

class JsonDataResourcesApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        var mainView = new JsonDataResourcesView();
        var intputDelegate = new BaseInputDelegate(mainView);

        return [ mainView, intputDelegate ];
    }

}