//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;

class PitchCounterView extends WatchUi.View {

    var mLabelCount;
    var mLabelSamples;
    var mLabelPeriod;
    var mPitchCounter;

    function initialize() {
        View.initialize();
        mPitchCounter = new PitchCounterProcess();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        mLabelCount = View.findDrawableById("id_pitch_count");
        mLabelSamples = View.findDrawableById("id_pitch_samples");
        mLabelPeriod = View.findDrawableById("id_pitch_period");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        mPitchCounter.onStart();
    }

    // Update the view
    function onUpdate(dc) {

        mLabelCount.setText("Count: " + mPitchCounter.getCount().toString());
        mLabelSamples.setText("Samples: " + mPitchCounter.getSamples().toString());
        mLabelPeriod.setText("Period: " + mPitchCounter.getPeriod().toString());
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        mPitchCounter.onStop();
    }

}
