//
//  CRAFTY_UUIDS.swift
//  VCCWatch
//
//  Created by Brett Henderson on 9/21/15.
//  Copyright © 2015 Brett Henderson. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit


    String BASE = "-4c45-4b43=4942-265a524f5453";
    String DATA_SERVICE_UUID = craft(1);
    //TEMPERATURE BLOCKCHAIN

String TEMPERATURE_CHARACTERISTIC_UUID = craft(0x11);
String TEMPERATURE_SETPOINT_CHARACTERISTIC_UUID = craft(0x21);
String TEMPERATURE_BOOST_CHARACTERISTIC_UUID = craft(0x31);
String BATTERY_CHARACTERISTIC_UUID = craft(0x41);
String LED_CHARACTERISTIC_UUID = craft(0x51);

//META DATA UUID
String META_DATA_UUID = craft(2);

//MODEL INFORMATION
String MODEL_UUID = craft(0x22);
String VERSION_UUID = craft(0x32);
String SERIAL_UUID = craft(0x52);

//DATA
String MISC_DATA_UUID = craft(3);
String HOURS_OF_OP_UUID = craft(0x23);

private String(craft){
        val="%08X";
}

