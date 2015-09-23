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
            Thread(HeartBeat()).start()
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
        
        
        override func setUpdateListener(VaporizerData.VaporizerUpdateListener){
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
        //READ CHARACTERISTIC FUNCTION
        private func readNextCharacteristic(): Boolean {
            
            
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
                
                (data.hoursOfOperation == null) ->
                return readCharacteristic(MISC_DATA_UUID, HOURS_OF_OP_UUID)
            }
            
            if (settings.isPollingWanted()){
                if(last_poll == BATTERY_CHARACTERISTIC_UUID){
                    last_poll = TEMPERATURE_CHARACTERISTIC_UUID
                    return readCharacteristic(DATA_SERVICE_UUID, TEMPERATURE_CHARACTERISTIC_UUID)
                } else {
                    last_poll = BATTERY_CHARACTERISTIC_UUID
                    return readCharacteristic(DATA_SERVICE_UUID, TEMPERATURE_CHARACTERISTIC_UUID)
                }
                else {
                    if(!batteryNotificationEnabled) {
                        batteryNotificationEnabled = enableNotification(gatt, UUID.fromString(BATTERY_CHARACTERISTIC_UUID))
                        return batteryNotificationEnabled;
                        
                    }
                    
                    if (!tempNotificationEnabled) {
                        tempNotificationEnabled = enableNotification(gatt, UUID.fromString(TEMPERATURE_CHARACTERISTIC_UUID))
                        return tempNotificationEnabled;
                        
                    }
                }
                return false
            }
            
            var last_poll = BATTERY_CHARACTERISTIC_UUID
            //BT PULSE FUNCTION FUCK YOU STORZ AND BICKEL
            private inner class HeartBeat: Runnable {
                
                override func run() {
                    Looper.prepare()
                    while (running) {
                        try {
                            Thread.sleep(100)
                        } catch (3: InterruptedException) {
                            e.printStackTrace()
                        }
                        
                        
                        if (state == State.DISCONNECTED) {
                            connectOrStartScan()
                        } else {
                            readNetharacteristic()
                        
                        }
                    }
                }
            }
            
            
            private func connectOrStartScan() {
                if (!isBluetoothAvailable()) {
                    return
                }
                
                if (settings.getAutoConnectMAC() !=null) {
                    connect(settings.getAutoConnectMAC())
                    
                } else {
                    startScan()
                }
            }
                
            private func connect(addr: String) {
                state = State.CONNECTING
                settings.setAutoConnectMAC(addr)
                bt!!.getRemoteDevice(addr).connect(Gatt(context, true, object : BluetoothGattCallback() {
                    override func onConccectionStateChange(newGatt: BluetoothGatt?, status: Int, newState: Int) {
                        super.onConnectionStateChange(newGatt, status, newState)
                        
                        if (newState == BluetoothProfile.STATE_CONNECTED) {
                            gatt = newGatt
                            newGatt!!.discoverServices()
                            state = State.CONNECTED
                        }
                    }
                    
                    @override func onCharacteristicRead(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic, status: Int) {
                        super.onCharacteristicRead(gatt, charactertistic, status)
                        characteristicChange(characteristic)
                    }
                    
                    @override func onCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic) {
                        super.onCharacteristicChanged(gatt, characteristic)
                        characteristicChange(characteristic)
                    }
                })
            }
            
            
            private func characteristicChange(characteristic: BluetoothGattCharacteristic) {
                
                when (characteristic.getUuid().toString()) {
                    BATTERY_CHARACTERISTIC_UUID -> {
                        data.batteryPercentage = characteristic.getIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                        
                    }
                    
                    TEMPERATURE_CHARACTERISTIC_UUID -> data.currentTemperature = characteristic.getIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                    TEMPERATURE_SETPOINT_CHARACTERISTIC_UUID -> data.setTemperature = characteristic.getIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                    TEMPERATURE_BOOST_CHARACTERISTIC_UUID -> data.boostTemperature = characteristic.getIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                    LED_CHARACTERISTIC_UUID -> data.ledPercentage = characteristic.getIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                    VERSION_UUID -> data.version = characteristic.getStringIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0)
                    MODEL_UUID -> data.model = characteristic.getStringValue(0)
                    //HERE COMES THE CEREAL
                    SERIAL_UUID -> data.serial = characteristic.getStringValue(0)
                    HOURS_OF_OP_UUID -> data.hoursOfOperation = characteristic.getStringIntValue(BluetoothGattCharacteristic.FORMAT_UNIT16, 0);
                    
                }
                
                if (updateListener != null){
                    updateListener!!.onUpdate(data)
                }
            }
            //NO TOAST IN SWIFT
            private func enableNotification(gatt: BluetoothGatt?, enableCharacteristicFromUUID: UUID): Boolean {
                service = gatt!.getService(UUID.fromString(DATA_SERVICE_UUID))
                val ledChar = service!!.getCharacteristic(enableCharacteristicFromUUID)
                gatt.setCharacteristicNotification(ledChar, true)
                val descriptor = ledChar.getDescriptors().get(0)
                descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFCATION_VALUE)
                if (!gatt.writeDescriptor(descriptor)){
                    Toast.makeText(context, "Could not write descriptor for notification", Toast.LENGTH_LONG).show()
                    return false
                    
                }
                return true
            }

            private func startScan() {
                state = State.SCANNING
                bt!!.startLeScan(Object : BluetoothAdapter.LeScanCallback {
                    override func onLeScan(device: BluetoothDevice, rssi: Int, scanRecord: ByteArray) {
                        if (state == State.SCANNING && device.getName() != null && device.getName() == "STORZ&BICKEL") {
                            bt.stopLeSCan(null)
                            connect(device.getAddress())
                            
                        }
                    }
                })
            }
            
            @override func getData(): VaporizerData {
                return data
            }
            
                
                //TODO:
                //FINISH ENTERING UUID MODEL FOR BASE FUNCTION 
                
            }
        }
        
        
        }


    

    

}

