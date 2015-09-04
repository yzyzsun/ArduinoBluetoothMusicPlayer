//
//  BLEManager.swift
//  ArduinoBluetoothMusicPlayer
//
//  Created by yzyzsun on 2015-09-03.
//  Copyright (c) 2015 yzyzsun. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

let BlunoServiceUUID = CBUUID(string: "DFB0")
let BlunoSerialUUID = CBUUID(string: "DFB1")

enum BlunoCommand: String {
    case Pause = "a"
    case Resume = "b"
    case Backward = "c"
    case Forward = "d"
    case Prev = "e"
    case Next = "f"
    case VolumeUp = "g"
    case VolumeDown = "h"
    case VolumeChange = "i"
    case ModeNormal = "j"
    case ModeShuffle = "k"
    case ModeRepeatList = "l"
    case ModeRepeatSingle = "m"
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ViewController
        switch central.state {
        case .PoweredOn:
            startScanning()
        case .PoweredOff:
            let alert = UIAlertController(title: "蓝牙", message: "您未打开蓝牙，请在控制中心打开蓝牙", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(defaultAction)
            rootViewController.presentViewController(alert, animated: true, completion: nil)
        case .Unsupported:
            let alert = UIAlertController(title: "蓝牙", message: "您的设备不支持蓝牙", preferredStyle: UIAlertControllerStyle.Alert)
            rootViewController.presentViewController(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if (bluno == nil) {
            bluno = peripheral
            centralManager.connectPeripheral(bluno, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        if (bluno == peripheral) {
            rootViewController.appendToLog("Successfully connected to \(bluno.name).\r\n")
            centralManager.stopScan()
            bluno.delegate = self
            bluno.discoverServices([BlunoServiceUUID])
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil {
            rootViewController.appendToLog(error.description)
            return
        }
        for service in bluno.services {
            if service.UUIDString == BlunoServiceUUID {
                bluno.discoverCharacteristics([BlunoSerialUUID], forService: service as! CBService)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil {
            rootViewController.appendToLog(error.description)
            return
        }
        for characteristic in service.characteristics {
            if characteristic.UUIDString == BlunoSerialUUID {
                rootViewController.appendToLog("Ready to take control.\r\n")
                blunoSerial = characteristic as! CBCharacteristic
            }
        }
    }
    
    private var centralManager: CBCentralManager!
    private var bluno: CBPeripheral!
    private var blunoSerial: CBCharacteristic!
    
    private var rootViewController: ViewController!
    
    func startScanning() {
        centralManager.scanForPeripheralsWithServices([BlunoServiceUUID], options: nil)
        rootViewController.appendToLog("Scanning for bluetooth devices...\r\n")
    }
    
    func sendCommand(command: BlunoCommand) {
        bluno.writeValue(command.rawValue.dataUsingEncoding(NSASCIIStringEncoding), forCharacteristic: blunoSerial, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func sendCommand(command: BlunoCommand, var changeVolumeTo volume: UInt8) {
        bluno.writeValue(command.rawValue.dataUsingEncoding(NSASCIIStringEncoding), forCharacteristic: blunoSerial, type: CBCharacteristicWriteType.WithoutResponse)
        bluno.writeValue(NSData(bytes: &volume, length: 1), forCharacteristic: blunoSerial, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
}
