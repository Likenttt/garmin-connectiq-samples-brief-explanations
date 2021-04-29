//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.UserProfile;

const SECONDS_PER_HOUR = 3600;
const SECONDS_PER_MINUTE = 60;

class UserProfileSectionOneView extends WatchUi.View {

    var mWeightPrefixStr = null;
    var mWeightUnitsStr = null;
    var mHeightPrefixStr = null;
    var mGenderPrefixStr = null;
    var mFemaleStr = null;
    var mMaleStr = null;
    var mHeightUnitsStr = null;
    var mWakeTimePrefixStr = null;
    var mItemNotSetStr = null;

    function initialize() {
        View.initialize();

        mWeightPrefixStr = WatchUi.loadResource(Rez.Strings.WeightPrefix);
        mWeightUnitsStr = WatchUi.loadResource(Rez.Strings.GramUnits);
        mHeightPrefixStr = WatchUi.loadResource(Rez.Strings.HeightPrefix);
        mGenderPrefixStr = WatchUi.loadResource(Rez.Strings.GenderSpecifierPrefix);
        mFemaleStr = WatchUi.loadResource(Rez.Strings.GenderFemale);
        mMaleStr = WatchUi.loadResource(Rez.Strings.GenderMale);
        mHeightUnitsStr = WatchUi.loadResource(Rez.Strings.CMUnits);
        mWakeTimePrefixStr = WatchUi.loadResource(Rez.Strings.WakeTimePrefix);
        mItemNotSetStr = WatchUi.loadResource(Rez.Strings.ItemNotSet);
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.SectionOneLayout(dc));
    }

    function onUpdate(dc) {
        var profile = UserProfile.getProfile();

        if (profile != null) {
            var hours;
            var minutes;
            var seconds;
            var string = mWeightPrefixStr + profile.weight.toString() + mWeightUnitsStr;

            findDrawableById("WeightLabel").setText(string);

            string = mGenderPrefixStr;
            if (profile.gender == 0) {
                string += mFemaleStr;
            } else {
                string += mMaleStr;
            }
            findDrawableById("GenderLabel").setText(string);

            string = mHeightPrefixStr + profile.height.toString() + mHeightUnitsStr;
            findDrawableById("HeightLabel").setText(string);

            string = mWakeTimePrefixStr;
            if ((profile.wakeTime != null) && (profile.wakeTime.value() != null)) {
                hours = profile.wakeTime.divide(SECONDS_PER_HOUR).value();
                minutes = (profile.wakeTime.value() - (hours * SECONDS_PER_HOUR)) / SECONDS_PER_MINUTE;
                seconds = profile.wakeTime.value() - (hours * SECONDS_PER_HOUR) - (minutes * SECONDS_PER_MINUTE);
                string += hours.format("%02u") + ":" + minutes.format("%02u") + ":" + seconds.format("%02u");
            } else {
                string += mItemNotSetStr;
            }
            findDrawableById("WakeTimeLabel").setText(string);
        }
        View.onUpdate(dc);
    }
}
