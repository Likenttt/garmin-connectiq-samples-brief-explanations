//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Ant;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Ant;

module AntModule
{
    // Channel configuration
    const CHANNEL_PERIOD = 8070;
    const DEVICE_NUMBER = 1234;
    const DEVICE_TYPE = 120;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 77;

    // Range Constants
    const MIN_BYTE_VALUE = 0x00;
    const MAX_BYTE_VALUE = 0xFF;
    const SEND_DATA_MAX_INDEX = 3;
    const MAX_DATA_LENGTH = 24;
    const NEW_MESSAGE_LENGTH = 8;

    // Encryption-related constants
    const ENCRYPTION_DECIMATION_RATE = 1;
    const ENCRYPTION_ID_SLAVE = 0xAAAAAAAA;
    const ENCRYPTION_ID_MASTER = 0x11111111;
    const ENCRYPTION_KEY = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
    const ENCRYPTION_USER_INFO_STRING = [1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1];

    // Message indexes
    const MESSAGE_ID_INDEX = 0;
    const MESSAGE_CODE_INDEX = 1;

    // See the commented data below for the text representation
    const SEND_DATA = [
        [0x1,0x48,0x65,0x6c,0x6c,0x6f,0x5f,0x5f],
        [0x2,0x57,0x6f,0x72,0x6c,0x64,0x21,0x5f],
        [0x3,0x43,0x6f,0x6e,0x6e,0x65,0x63,0x74],
        [0x4,0x49,0x51,0x5f,0x5f,0x5f,0x5f,0x5f]];
     // [0x01,"H","e","l","l","o","_","_"],
     // [0x02,"W","o","r","l","d","!","_"],
     // [0x03,"C","o","n","n","e","c","t"],
     // [0x04,"I","Q","_","_","_","_","_"]];

    // ASCII Table needed for showing Data byte values.
    const HEX_TO_ASCII = [
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", "!", "\"", "#","$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?",
        "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_",
        "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
        "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "];

    class AntSensor extends Toybox.Ant.GenericChannel {

        var chanAssign;
        var cryptoConfig;
        var data;
        var deviceCfg;
        var encrypted;
        var index;
        var isMaster;
        var searching;

        // Initializes AntSensor, configures and opens channel
        // @param isChannelTypeMaster, a boolean that indicated if the channelshould
        // be a master or a slave
        function initialize( isChannelTypeMaster ) {

            //Initialize class variables
            data = WatchUi.loadResource( Rez.Strings.Uninitialized );
            encrypted = false;
            index = 0;
            isMaster = isChannelTypeMaster;

            // Try to create crypto configs and channel assignments
             try {
                if ( isMaster ) {
                    searching = false;
                    // Create master crypto config
                    cryptoConfig = new Toybox.Ant.CryptoConfig( {
                        :encryptionId => AntModule.ENCRYPTION_ID_MASTER,
                        :encryptionKey => AntModule.ENCRYPTION_KEY,
                        :decimationRate => AntModule.ENCRYPTION_DECIMATION_RATE
                    } );

                    // Create master channel assignment
                    chanAssign = new Toybox.Ant.ChannelAssignment(
                        Toybox.Ant.CHANNEL_TYPE_TX_NOT_RX,
                        Toybox.Ant.NETWORK_PUBLIC );

                } else {
                    searching = true;
                    // Create slave crypto config
                    cryptoConfig = new Toybox.Ant.CryptoConfig( {
                        :encryptionId => AntModule.ENCRYPTION_ID_SLAVE,
                        :encryptionKey => AntModule.ENCRYPTION_KEY,
                        :userInfoString => AntModule.ENCRYPTION_USER_INFO_STRING,
                        :decimationRate => AntModule.ENCRYPTION_DECIMATION_RATE
                    } );

                    // Create slave channel assignment
                    chanAssign = new Toybox.Ant.ChannelAssignment(
                        Toybox.Ant.CHANNEL_TYPE_RX_NOT_TX,
                        Toybox.Ant.NETWORK_PUBLIC);
                }

                // Initialize Channel
                GenericChannel.initialize( method(:onMessage), chanAssign );

                // Set the configuration
                deviceCfg = new Toybox.Ant.DeviceConfig( {
                    :deviceNumber => AntModule.DEVICE_NUMBER,
                    :deviceType => AntModule.DEVICE_TYPE,
                    :transmissionType => AntModule.TRANSMISSION_TYPE,
                    :messagePeriod => AntModule.CHANNEL_PERIOD,
                    :radioFrequency => AntModule.RADIO_FREQUENCY} );
                GenericChannel.setDeviceConfig( deviceCfg );

            } catch( ex ) {
                Toybox.System.println("Error creating the cryto config");
            }
        }

        // Opens the generic channel
        function open() {
            GenericChannel.open();
        }

        // Enables encryption for master and decryption for slave
        function enableEncryption() {
            try {
                if ( ( !searching ) && ( !encrypted ) ){
                    GenericChannel.enableEncryption( cryptoConfig );
                    encrypted = true;
                } else {
                    Toybox.System.println("Failed to enable encryption, still searching");
                }
            } catch ( ex instanceof EncryptionInvalidSettingsException ) {
                Toybox.System.println("Failed to enable encryption, cryptoConfig has an invalid parameter");
            } catch ( ex instanceof UnableToAcquireEncryptedChannelException ) {
                Toybox.System.println("Failed to enable encryption, please ensure you are not using more encrypted channels than are available");
            } catch ( ex ) {
                Toybox.System.println("Failed to enable encryption, reason unknown");
            }
        }

        // Disables encryption for master and decryption for slave
        function disableEncryption() {
            try {
                if ( encrypted ) {
                    GenericChannel.disableEncryption();
                    encrypted = false;
                }
            } catch ( ex instanceof EncryptionInvalidSettingsException ) {
                Toybox.System.println("Failed to disable encryption as cryptoConfig has an invalid parameter");
            } catch ( ex ) {
                Toybox.System.println("Failed to disable encryption, reason unknown");
            }
        }

        // On Ant Message, parses message
        // @param msg, a Toybox.Ant.Message object
        function onMessage( msg ) {
            // Parse the payload
            var payload = msg.getPayload();
            if ( Toybox.Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId ) {
                if ( Toybox.Ant.MSG_ID_RF_EVENT == payload[MESSAGE_ID_INDEX] ) {
                    switch(payload[MESSAGE_CODE_INDEX]) {
                        case Toybox.Ant.MSG_CODE_EVENT_CHANNEL_CLOSED:
                            // Channel closed, re-open
                            open();
                            break;
                        case Toybox.Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH:
                            searching = true;
                            break;
                        case Toybox.Ant.MSG_CODE_EVENT_CRYPTO_NEGOTIATION_FAIL:
                            encrypted = false;
                            break;
                         case Toybox.Ant.MSG_CODE_EVENT_CRYPTO_NEGOTIATION_SUCCESS:
                            encrypted = true;
                            break;
                         case Toybox.Ant.MSG_CODE_EVENT_TX:
                            // Update data and send out the next part of the message
                             var message = new Toybox.Ant.Message();
                             index++;
                             if ( SEND_DATA_MAX_INDEX < index ) {
                                 index = 0;
                             }
                             var toSend = AntModule.SEND_DATA[index];
                             updateData( toSend );
                             message.setPayload( toSend );
                             GenericChannel.sendBroadcast( message );
                             break;
                    }
                }
            } else if ( Toybox.Ant.MSG_ID_BROADCAST_DATA == msg.messageId ) {
                if ( searching ) {
                    searching = false;
                }
                // Update data to received message
                updateData( payload );
                //Update the UI
                WatchUi.requestUpdate();
            }
        }

        // Adds the new message to data
        // Maintains data stays within MAX_DATA_LENGTH
        // @param bArray, a byte array with the message you want to add to data
        function updateData( bArray ) {
            if ( data.length() >= MAX_DATA_LENGTH ) {
                data = data.substring( NEW_MESSAGE_LENGTH, MAX_DATA_LENGTH );
            }
            data = data + DecodeByteToASCII( bArray );
        }

        // @param bytes, a byte array
        // @return an ascii string equivalent to the given byte array
        function DecodeByteToASCII( bytes ) {
            var str = "";
            for ( var i = 0; i < bytes.size(); i++ ) {
                if ( ( MIN_BYTE_VALUE <= bytes[i] ) && ( bytes[i] <= MAX_BYTE_VALUE ) ) {
                    str += HEX_TO_ASCII[bytes[i]];
                } else {
                    str += "-";
                }
            }
            return str;
        }
    }
}