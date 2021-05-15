//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Ant;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.ActivityRecording;
using Toybox.FitContributor;

class MO2Sensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 31;
    const PERIOD = 8192;
    const MO2_FIELD_ID = 0;

    hidden var chanAssign;
    hidden var fitField;
    hidden var session;

    var data;
    var searching;
    var pastEventCount;
    var deviceCfg;

    class MO2Data {
        var eventCount;
        var utcTimeSet;
        var supportsAntFs;
        var measurementInterval;
        var totalHemoConcentration;
        var previousHemoPercent;
        var currentHemoPercent;

        function initialize() {
            eventCount = 0;
            utcTimeSet = false;
            supportsAntFs = false;
            measurementInterval = 0;
            totalHemoConcentration = 0;
            previousHemoPercent = 0;
            currentHemoPercent = 0;
        }
    }

    class MuscleOxygenDataPage {
        static const PAGE_NUMBER = 1;
        static const AMBIENT_LIGHT_HIGH = 0x3FE;
        static const INVALID_HEMO = 0xFFF;
        static const INVALID_HEMO_PERCENT = 0x3FF;

        enum {
            INTERVAL_25 = 1,
            INTERVAL_50 = 2,
            INTERVAL_1 = 3,
            INTERVAL_2 = 4
        }

        function parse(payload, data) {
            data.eventCount = parseEventCount(payload);
            data.utcTimeSet = parseTimeSet(payload);
            data.supportsAntFs = parseSupportAntfs(payload);
            data.measurementInterval = parseMeasureInterval(payload);
            data.totalHemoConcentration = parseTotalHemo(payload);
            data.previousHemoPercent = parsePrevHemo(payload);
            data.currentHemoPercent = parseCurrentHemo(payload);
        }

        hidden function parseEventCount(payload) {
           return payload[1];
        }

        hidden function parseTimeSet(payload) {
            if (payload[2] & 0x1) {
               return true;
            } else {
               return false;
            }
        }

        hidden function parseSupportAntfs(payload) {
            if (payload[3] & 0x1) {
                return true;
            } else {
                return false;
            }
        }

        hidden function parseMeasureInterval(payload) {
           var interval = payload[3] >> 1;
           var result = 0;
           if (INTERVAL_25 == interval) {
               result = .25;
           } else if (INTERVAL_50 == interval) {
                result = .50;
           } else if (INTERVAL_1 == interval) {
                result = 1;
           } else if (INTERVAL_2 == interval) {
                result = 2;
           }
           return result;
        }

        hidden function parseTotalHemo(payload) {
           return ((payload[4] | ((payload[5] & 0x0F) << 8))) / 100f;
        }

        hidden function parsePrevHemo(payload) {
           return ((payload[5] >> 4) | ((payload[6] & 0x3F) << 4)) / 10f;
        }

        hidden function parseCurrentHemo(payload) {
           return ((payload[6] >> 6) | (payload[7] << 2)) / 10f;
        }
    }

    class CommandDataPage {
        static const PAGE_NUMBER = 0x10;
        static const CMD_SET_TIME = 0x00;

        static function setTime(payload) {
        }

    }

    function initialize() {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX, Ant.NETWORK_PLUS);
        GenericChannel.initialize(method(:onMessage), chanAssign);
        fitField = null;

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 0,                 // Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => 0,
            :messagePeriod => PERIOD,
            :radioFrequency => 57,              // Ant+ Frequency
            :searchTimeoutLowPriority => 10,    // Timeout in 25s
            :searchThreshold => 0} );           // Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        data = new MO2Data();
        searching = true;
        session = ActivityRecording.createSession({:name=>WatchUi.loadResource(Rez.Strings.sessionName)});
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        data = new MO2Data();
        pastEventCount = 0;
        searching = true;
        session.start();

        if(session has :createField) {
            if( null == fitField ) {
                fitField = session.createField
                    (
                    WatchUi.loadResource(Rez.Strings.fitFieldName),
                    MO2_FIELD_ID,
                    FitContributor.DATA_TYPE_FLOAT,
                    { :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>WatchUi.loadResource(Rez.Strings.fitUnitsLabel)}
                    );
            }
        }
    }

    function closeSensor() {
        GenericChannel.close();
        session.stop();
        session.save();
    }

    function setTime() {
        if (!searching && (data.utcTimeSet)) {
            // Create and populat the data payload
            var payload = new [8];
            payload[0] = 0x10;  // Command data page
            payload[1] = 0x00;  // Set time command
            payload[2] = 0xFF;  // Reserved
            payload[3] = 0;     // Signed 2's complement value indicating local time offset in 15m intervals

            // Set the current time
            var moment = Time.now();
            for (var i = 0; i < 4; i++) {
                payload[i + 4] = ((moment.value() >> i) & 0x000000FF);
            }

            // Form and send the message
            var message = new Ant.Message();
            message.setPayload(payload);
            GenericChannel.sendAcknowledge(message);
        }
    }

    function onMessage(msg) {
        // Parse the payload
        var payload = msg.getPayload();

        if (Ant.MSG_ID_BROADCAST_DATA == msg.messageId) {
            if (MuscleOxygenDataPage.PAGE_NUMBER == (payload[0].toNumber() & 0xFF)) {
                // Were we searching?
                if (searching) {
                    searching = false;
                    // Update our device configuration primarily to see the device number of the sensor we paired to
                    deviceCfg = GenericChannel.getDeviceConfig();
                }
                var dp = new MuscleOxygenDataPage();
                dp.parse(msg.getPayload(), data);
                // Check if the data has changed and we need to update the ui
                if (pastEventCount != data.eventCount) {
                    WatchUi.requestUpdate();
                    pastEventCount = data.eventCount;

                    if(session.isRecording() && (fitField != null)) {
                        fitField.setData(data.totalHemoConcentration);
                    }
                }

            }
        } else if (Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) {
            if (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF)) {
                if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF)) {
                    // Channel closed, re-open
                    open();
                } else if (Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF)) {
                    searching = true;
                    WatchUi.requestUpdate();
                }
            } else {
                //It is a channel response.
            }
        }
    }
}