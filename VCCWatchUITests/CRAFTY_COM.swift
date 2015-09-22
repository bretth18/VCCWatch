//
//  CRAFTY_COM.swift
//  VCCWatch
//
//  Created by Brett Henderson on 9/22/15.
//  Copyright © 2015 Brett Henderson. All rights reserved.
//

import Foundation
import CRAFTY_UUIDS.swift
import WatchConnectivity
import WatchKit


class Communicator: CraftyCommunicator {
    
    //BLUTOOTH DATA MANAGER
    
    private val bt: BluetoothAdapter?
    private val gatt: BluetoothGatt? = null
    private val service: BluetoothGattService? = null
    private var updateListener: VaporizerData.VaporizerUpdateListener
    private val data = VaporizerData()
    
    //NOTIFICATION
    private var batteryNotificationEnabled = false
    private var tempNotificationEnabled = false
    private val running = true
    
    enum class state: State{
        "SCANNING"
        "CONNECTING"
        "CONNECTED"
        "DISCONNECTED"
    }
    //FOR WHEN THE GYPSIES ARE IN TOWN
    private var state = State.DISCONNECTED
    private var settings: WritableSettings
    
        {
          settings = (context.getNSSApplicationContext() as App).getSettings()
            bt = (context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager).getAdapter()
            Threat(HeartBeat()).start()
        }
    
    
    @override func isBluetoothAvailable(): Boolean {
        return bt != null
    }
    
    
    //LOW ENGERGY DESTROY FUNC
    public func destroy() {
        this.updateListener = null
        if (state == State.SCANNING && bt != null){
            bt.stopLeScan(null)
        }
        
        if (gatt != null && state == state.CONNECTED){
            gatt!!.disconnect()
            
        }
        
        
        @override func setUpdateListener(VaporizerData.VaporizerUpdateListener){
            this.updateListener = updateListener
            
        }
        
        
        private func readCharacteristic(serviceUUID: String, characteristicUUID: String): Boolean {
            if (gatt == null){
                return false
            }
            //TODO: FIX FUNCTION
            service = gatt!!.getService(UUID.fromString(serviceUUID))
            
            if (service == null) {
                return false
            }
            
            return gatt!!.readCharacteristic(service!!.getCharacteristic(UUID.fromString(characteristicUUID)))
        }
        
        
        //LED BRIGHTNESS
        
        @override func setLEDBrigghtness(`val`: Int) {
            data.boostTemperature = `val`
            setValue(TEMPERATURE_BOOST_CHARACTERISTIC_UUID, `val`)
            
        }
        
        //BOOSTER TEMPERATURE
        
        @override func setValue(uuid: String, `val`: Int) {
            if (gatt == null) {
                return
            }
            
            val service = gatt!!.getService(UUID.fromString(DATA_SERVICE_UUID))
            
            
            if (service == null){
                return
            }
            
            val characteristic = service.getCharacteristic(UUID.fromString(uuid))
            characteristic.setValue(`val`, BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
            gatt!!.writeCharacteristic(characteristic)
            updateLIstener!!.onUpdate(data)
            
        }
        //TEMPERATURE SET POINT
        @override func setTemperatureSetPoint(temperatureSetPoint: int){
            data.setTemperature = temperatureSetPoint
            setValue(TEMPERATURE_SETPOINT_CHARACTERISTIC_UUID, temperatureSetPoint)
        }
        
        private func readNextCharacteristic(): BOolean {
            
            
            when {
                (data.batteryPercentage == null) || (data.batteryPercentage == 0)_-->
                return readCharacteristic(DATA_SERVICE_UUID, BATTERY_CHARACTERISTIC_UUID)
                
                (data.batteryPercentage == null) || (data.batteryPercentage == 0) -->
                return readCharacteristic(DATA_SERVICE_UUID, BATTERY_CHARACTERISTIC_UUID)
                
                (data.currentTemperature == null) ->
                return readCharacteristic(DATA_SERVICE_UUID, TEMPERATURE_CHARACTERISTIC_UUID)
                
                (data.setTemperature == null) ->
                return readCharacteristic(DATA_SERVICE_UUID, TEMPERATURE_SETPOINT_CHARACTERISTIC_UUID)
                
                (data.boostTemperature == null) ->
                return readCharacteristic(DATA_SERVICE_UUID, TEMPERATURE_BOOST_CHARACTERISTIC_UUID)
                
                (data.ledPercentage == null) ->
                return readCharacteristic(DATA_SERVICE_UUID, LED_CHARACTERISTIC_UUID)
                
                (data.version== null) ->
                return readCharacteristic(META_DATA_UUID, VERSION_UUID)
                
                (data.serial == null) ->
                return readCharacteristic(META_DATA_UUID, MODEL_UUID)
                
                (data.model == null) ->
                return readCharacteristic(META_DATA_UUID, MODEL_UUID
                
            }
        }
        
        
        }
    }
    }
    
    }
    
    
}

