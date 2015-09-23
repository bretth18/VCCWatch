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


    NSString BASE = "-4c45-4b43=4942-265a524f5453";
    NSString DATA_SERVICE_UUID = craft(1);
    //TEMPERATURE BLOCKCHAIN

NSString TEMPERATURE_CHARACTERISTIC_UUID = craft(0x11);


NSString TEMPERATURE_SETPOINT_CHARACTERISTIC_UUID = craft(0x21);

NSString TEMPERATURE_BOOST_CHARACTERISTIC_UUID = craft(0x31);

NSString BATTERY_CHARACTERISTIC_UUID = craft(0x41);
NSString LED_CHARACTERISTIC_UUID = craft(0x51);

//META DATA UUID
NSString META_DATA_UUID = craft(2);

//MODEL INFORMATION
NSString MODEL_UUID = craft(0x22);
NSString VERSION_UUID = craft(0x32);
NSString SERIAL_UUID = craft(0x52);

//DATA
NSString MISC_DATA_UUID = craft(3);
NSString HOURS_OF_OP_UUID = craft(0x23);

private String(craft){
        val="%08X";
}

