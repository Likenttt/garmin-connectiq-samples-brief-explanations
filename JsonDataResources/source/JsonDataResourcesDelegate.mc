using Toybox.WatchUi;
using Toybox.System;

class BaseInputDelegate extends WatchUi.BehaviorDelegate {
    hidden var mJsonRecordIndex = 0;

    //An array of all defined JSON resource record IDs
    //Note that these do not get loaded into memory until
    //WatchUi.loadResource is called on one of them.
    hidden var mJsonResourceIds =
        [
        Rez.JsonData.arrayResource,
        Rez.JsonData.dictionaryResource,
        Rez.JsonData.mixedArrayResource,
        Rez.JsonData.singleValue,
        Rez.JsonData.dictionaryFromFile,
        Rez.JsonData.arrayFromFile
        ];

    var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onMenu() {

        if (mJsonRecordIndex == (mJsonResourceIds.size()-1)) {
            mJsonRecordIndex = 0;
        } else {
            mJsonRecordIndex += + 1;
        }

        mView.loadJsonRecord(mJsonResourceIds[mJsonRecordIndex]);
        return true;
    }
}