//
//  SensorTagDelegate.swift
//  SensorTagRaider
//
//  Created by Lennart Olsen on 04/02/2018.
//  Copyright © 2018 lennartolsen.net. All rights reserved.
//

import Foundation

protocol SensorTagDelegate: ObserverProtocol {
    func Ready(uuid: UUID) /** Called when all characteristics are read, device is not yet listenting **/
    
    func Errored(uuid: UUID)
    
    func Accelerometer(measurement : AccelerometerMeasurement, uuid : UUID)
    
    func Magnetometer(measurement : MagnetometerMeasurement, uuid : UUID)
    
    func Gyroscope(measurement : GyroscopeMeasurement, uuid : UUID)
    
    func ReadyForCalibration(uuid: UUID) /** First values are in, we can calibrate it **/
    
    func Calibrated(values : [[Double]], uuid : UUID) /** Called when calibration is complete **/
}
