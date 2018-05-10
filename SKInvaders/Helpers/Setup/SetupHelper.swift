//
//  SetupHelper.swift
//  Demo Predictor
//
//  Created by Lennart Olsen on 30/04/2018.
//  Copyright © 2018 lennartolsen.net. All rights reserved.
//

import Foundation

import CoreBluetooth

let CONNECT_TO = 2

class SetupHelper {
    let pm = PeripheralManager.sharedInstance
    
    private var predictionCollector : PredictionCollector! = nil
    private var discoveredDevices = [UUID : CBPeripheral]()
    
    var sensorTags = [UUID : SensorTagPeripheral]()
    
    private let delegate : SetupHelperDelegate
    
    private var didCalibrate = [UUID]()
    private var isSetup = [UUID]()
    
    init(delegate : SetupHelperDelegate) {
        self.delegate = delegate
        pm.listenerDelegate = self
    }
    
    func setupListeners(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for (_, device) in self.sensorTags {
                device.attach(observer: self)
                device.setup()
            }
        }
    }
    
    func connected(){
        setupListeners()
        
        predictionCollector = PredictionCollector(devices: sensorTags)
        
        delegate.GotPredictor(predictionCollector: predictionCollector)
    }
}

extension SetupHelper : BluetoothListenerDelegate  {
    
    func didDiscover(peripheralDevice: CBPeripheral) {
        if( SensorTagPeripheral.validateSensorTag(device : peripheralDevice) ){
            self.discoveredDevices[peripheralDevice.identifier] = peripheralDevice
            print("Still searcing, found \(discoveredDevices.count) sensor(s)")
            if( self.discoveredDevices.count == CONNECT_TO ){
                print("Connecting")
                for (uuid, _) in discoveredDevices {
                   _ = pm.connectToDevice(uuid: uuid)
                }
            }
        }
    }
    
    func didConnect(peripheralDevice: CBPeripheral) {
        if SensorTagPeripheral.validateSensorTag(device: peripheralDevice)  {
            sensorTags[peripheralDevice.identifier] = SensorTagPeripheral(device : peripheralDevice)
            print("Connected to sensor, \(sensorTags.count) of \(CONNECT_TO)")
            if(sensorTags.count == CONNECT_TO){
                print("Connected to sensors")
                self.setupListeners()
            }
        }
    }
}

extension SetupHelper : SensorTagDelegate {
    func Ready(uuid : UUID) {
        if(!isSetup.contains(uuid) && sensorTags[uuid] != nil){
            if(uuid.uuidString == "609DF9A1-DC11-A6F3-D511-290C419DA39F"){
                sensorTags[uuid]?.listenForMagnetometer()
            } else {
                sensorTags[uuid]?.listenForGyroscope()
            }
            isSetup.append(uuid)
        }
    }
    
    func ReadyForCalibration(uuid : UUID) {
        if(!didCalibrate.contains(uuid)){
            print("Calibrating", uuid)
            sensorTags[uuid]?.calibrate()
            didCalibrate.append(uuid)
            if(didCalibrate.count == CONNECT_TO){
                connected()
                pm.stopScan()
            }
        }
    }
    
    func Calibrated(values: [[Double]], uuid : UUID) {}
    
    func Errored(uuid: UUID) {}
    
    func Accelerometer(measurement: AccelerometerMeasurement, uuid : UUID) {}
    
    func Magnetometer(measurement: MagnetometerMeasurement, uuid : UUID)  {}
    
    func Gyroscope(measurement: GyroscopeMeasurement, uuid : UUID) {}
    
    
    var id: String {
        get {
            return "SetupHelper"
        }
    }
}
