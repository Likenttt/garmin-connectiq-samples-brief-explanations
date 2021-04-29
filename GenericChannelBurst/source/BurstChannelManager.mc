//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Ant;
using Toybox.System;

const ANT_DATA_PACKET_SIZE = 8;

class BurstChannelManager {
    const BURST_TX_MESSAGE_COUNT = 50;

    hidden var _listener;
    hidden var _masterChannel;
    hidden var _slaveChannel;

    //! Constructor
    function initialize() {
        _listener = new TestBurstListener();
        _masterChannel = new BurstChannel(Ant.CHANNEL_TYPE_TX_NOT_RX, _listener);
        _slaveChannel = new BurstChannel(Ant.CHANNEL_TYPE_RX_NOT_TX, _listener);
    }

    //! Sends a burst over the master channel
    function sendBurst() {
        var burst = new Ant.BurstPayload();
        for(var i = 0; i < BURST_TX_MESSAGE_COUNT; i++)
        {
            // Populate a new burst packet
            var data = new [ANT_DATA_PACKET_SIZE];
            for(var j = 0; j < ANT_DATA_PACKET_SIZE; j++)
            {
                data[j] = i;
            }

            // Add the packet to the BurstPayload
            burst.add(data);
        }

        _masterChannel.sendBurst(burst);
    }

    //! Wrapper function that retrieves the current BurstStatistics
    //! @return [BurstStatistics] The BurstStatistics gathered by the TestBurstListener
    function getBurstStatistics() {
        return _listener.burstStatistics;
    }
}

class BurstChannel extends Ant.GenericChannel {
    const DEVICE_NUMBER = 123;
    const DEVICE_TYPE = 1;
    const FREQUENCY = 66;
    const PERIOD_1_HZ = 32768;
    const TRANS_TYPE = 0;

    hidden var _transmissionCounter;

    //! Constructor.
    //! Initializes the channel object, sets the burst listener and opens the channel
    //! @param [Number] channelType See Ant.CHANNEL_TYPE_XXX
    //! @param [TestBurstListener] listener The BurstListener to assign
    function initialize(channelType, listener) {
        // Get the channel
        var chanAssign = new Ant.ChannelAssignment(
                channelType,
                Ant.NETWORK_PUBLIC );
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        var deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => DEVICE_NUMBER,
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANS_TYPE,
            :messagePeriod => PERIOD_1_HZ,
            :radioFrequency => FREQUENCY } );
        GenericChannel.setDeviceConfig( deviceCfg );

        // Set the listener for burst messages
        GenericChannel.setBurstListener(listener);

        // Open the channel
        GenericChannel.open();

        // Reset the transmission counter
        _transmissionCounter = 0;
        }

    //! Ant.Message handler
    //! @param [Message] msg The Message received over the channel
    function onMessage(msg) {
        var payload = msg.getPayload();
        if(Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId)
        {
            if(Ant.MSG_ID_RF_EVENT == payload[0])
            {
                var eventCode = payload[1];
                if(Ant.MSG_CODE_EVENT_TX == eventCode)
                {
                    //Create and populate the data payload
                    var data = new [ANT_DATA_PACKET_SIZE];
                    for(var i = 0; i < ANT_DATA_PACKET_SIZE; i++)
                    {
                        data[i] = _transmissionCounter;
                    }
                    _transmissionCounter++;

                    //Form the message
                    var message = new Ant.Message();
                    message.setPayload(data);

                    // Set the broadcast buffer
                    GenericChannel.sendBroadcast(message);
                }
                else if(Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == eventCode)
                {
                    // Reopen the channel if it closed due to search timeout
                    GenericChannel.open();
                }
            }
        }
    }

}

//! An extension of BurstListener that handles burst related events
class TestBurstListener extends Ant.BurstListener {
    var burstStatistics;

    //! Constructor.
    function initialize() {
        burstStatistics = new BurstStatistics();
        BurstListener.initialize();
    }

    //! Callback when a burst transmission completes successfully
    function onTransmitComplete() {
        burstStatistics.txSuccessCount++;
        System.println("onTransmitComplete");
    }

    //! Callback when a burst transmission fails over the air
    //! @param [Number] errorCode The type of burst failure that occurred, see Ant.BURST_ERROR_XXX
    function onTransmitFail(errorCode) {
        burstStatistics.txFailCount++;
        System.println("onTransmitFail-" + errorCode);
    }

    //! Callback when a burst reception fails over the air
    //! @param [Number] errorCode The type of burst failure that occurred, see Ant.BURST_ERROR_XXX
    function onReceiveFail(errorCode) {
        burstStatistics.rxFailCount++;
        System.println("onReceiveFail-" + errorCode);
    }

    //! Callback when a burst reception completes successfully
    //! @param [BurstPayload] burstPayload The burst data received across the channel
    function onReceiveComplete(burstPayload) {
        burstStatistics.rxSuccessCount++;
        printPayload(burstPayload);
        System.println("onReceiveComplete");
    }

    //! Iterates over a burst paylaod to print each packet
    //! @param [BurstPayload] burstPayload The burst data to display
    hidden function printPayload(burstPayload)
    {
        var itr = new Ant.BurstPayloadIterator(burstPayload);
        var payload = itr.next();
        while( null != payload )
        {
            System.println("payload " + payload);
            payload = itr.next();
        }
    }
}

class BurstStatistics {
    var rxFailCount;
    var rxSuccessCount;
    var txFailCount;
    var txSuccessCount;

    //! Constructor.
    function initialize() {
        rxFailCount = 0;
        rxSuccessCount = 0;
        txFailCount = 0;
        txSuccessCount = 0;
    }
}