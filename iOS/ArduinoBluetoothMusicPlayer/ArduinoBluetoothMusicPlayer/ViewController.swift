//
//  ViewController.swift
//  ArduinoBluetoothMusicPlayer
//
//  Created by yzyzsun on 2015-08-28.
//  Copyright (c) 2015 yzyzsun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bleManager = BLEManager.sharedInstance
    }
    
    var bleManager: BLEManager!
    
    @IBOutlet weak var logView: UITextView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeStepper: UIStepper!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    let ModeMap = [ 0: BlunoCommand.ModeNormal,
                    1: BlunoCommand.ModeShuffle,
                    2: BlunoCommand.ModeRepeatList,
                    3: BlunoCommand.ModeRepeatSingle ]
    
    @IBAction func changeMode(sender: UISegmentedControl) {
        bleManager.sendCommand(ModeMap[sender.selectedSegmentIndex]!)
    }
    
    @IBAction func changeVolumeBySlider(sender: UISlider) {
        volumeStepper.value = Double(sender.value)
        bleManager.sendCommand(BlunoCommand.VolumeChange, changeVolumeTo: UInt8(sender.value))
    }
    @IBAction func changeVolumeByStepper(sender: UIStepper) {
        let volumeUp: Bool = sender.value > Double(volumeSlider.value)
        volumeSlider.value = Float(sender.value)
        if (volumeUp) {
            bleManager.sendCommand(BlunoCommand.VolumeUp)
        } else {
            bleManager.sendCommand(BlunoCommand.VolumeDown)
        }
    }
    
    @IBAction func pause() {
        pauseButton.hidden = true
        resumeButton.hidden = false
        bleManager.sendCommand(BlunoCommand.Pause)
    }
    @IBAction func resume() {
        resumeButton.hidden = true
        pauseButton.hidden = false
        bleManager.sendCommand(BlunoCommand.Resume)
    }
    
    @IBAction func prev() {
        bleManager.sendCommand(BlunoCommand.Prev)
    }
    @IBAction func backward() {
        bleManager.sendCommand(BlunoCommand.Backward)
    }
    @IBAction func forward() {
        bleManager.sendCommand(BlunoCommand.Forward)
    }
    @IBAction func next() {
        bleManager.sendCommand(BlunoCommand.Next)
    }
    
    func appendToLog(message: String) {
        logView.text! += message
    }

}
