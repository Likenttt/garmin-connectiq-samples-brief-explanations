//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.UserProfile;

class UserProfileSectionTwoView extends WatchUi.View {

    var mSleepTimePrefixStr = null;
    var mRunStepLengthPrefixStr = null;
    var mWalkStepLengthPrefixStr = null;
    var mRestingHeartRatePrefixStr = null;
    var mHeartRateUnitsStr = null;
    var mStepLengthUnitsStr = null;
    var mNotSetStr = null;

    function initialize() {
        View.initialize();

        mSleepTimePrefixStr = WatchUi.loadResource(Rez.Strings.SleepTimePrefix);
        mRunStepLengthPrefixStr = WatchUi.loadResource(Rez.Strings.RunningStepLengthPrefix);
        mWalkStepLengthPrefixStr = WatchUi.loadResource(Rez.Strings.WalkingStepLengthPrefix);
        mRestingHeartRatePrefixStr = WatchUi.loadResource(Rez.Strings.RestingHeartRatePrefix);
        mStepLengthUnitsStr = WatchUi.loadResource(Rez.Strings.MMUnits);
        mNotSetStr = WatchUi.loadResource(Rez.Strings.ItemNotSet);
        mHeartRateUnitsStr = WatchUi.loadResource(Rez.Strings.BPMUnits);
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.SectionTwoLayout(dc));
    }

    function onUpdate(dc) {
        var profile = UserProfile.getProfile();

        if (profile != null) {
            var hours;
            var minutes;
            var seconds;
            var string = mSleepTimePrefixStr;

            if ((profile.sleepTime != null) && (profile.sleepTime.value() != null)) {
                hours = profile.sleepTime.divide(SECONDS_PER_HOUR).value();
                minutes = (profile.sleepTime.value() - (hours * SECONDS_PER_HOUR)) / SECONDS_PER_MINUTE;
                seconds = profile.sleepTime.value() - ( hours * SECONDS_PER_HOUR ) - ( minutes * SECONDS_PER_MINUTE);
                string += hours.format("%02u") + ":" + minutes.format("%02u") + ":" + seconds.format("%02u");
            } else {
                string += mNotSetStr;
            }
            findDrawableById("SleepTimeLabel").setText(string);

            string = mRunStepLengthPrefixStr;
            if (profile.runningStepLength != null) {
                string += profile.runningStepLength.toString() + mStepLengthUnitsStr;
            } else {
                string += mNotSetStr;
            }

            findDrawableById("RunStepLengthLabel").setText(string);

            string = mWalkStepLengthPrefixStr;
            if (profile.walkingStepLength != null) {
                string += profile.walkingStepLength.toString() + mStepLengthUnitsStr;
            } else {
                string += mNotSetStr;
            }
            findDrawableById("WalkStepLengthLabel").setText(string);

            string = mRestingHeartRatePrefixStr;
            if (profile.restingHeartRate != null) {
                string += profile.restingHeartRate.toString() + mHeartRateUnitsStr;
            } else {
                string += mNotSetStr;
            }
            findDrawableById("RestingHeartRateLabel").setText(string);
        }

        View.onUpdate(dc);
    }
}
