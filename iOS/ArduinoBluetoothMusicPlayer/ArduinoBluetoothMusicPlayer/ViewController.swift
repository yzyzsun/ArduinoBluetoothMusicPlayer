//
//  ViewController.swift
//  ArduinoBluetoothMusicPlayer
//
//  Created by yzyzsun on 2015-08-28.
//  Copyright (c) 2015 yzyzsun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logView: UITextView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBAction func changeMode(sender: UISegmentedControl) {
    }
    
    @IBAction func changeVolumeBySlider(sender: UISlider) {
    }
    
    @IBAction func changeVolumeByStepper(sender: AnyObject) {
    }
    
    @IBAction func pause() {
        pauseButton.hidden = true;
        resumeButton.hidden = false;
    }
    @IBAction func resume() {
        resumeButton.hidden = true;
        pauseButton.hidden = false;
    }
    
    @IBAction func prev() {
    }
    @IBAction func backward() {
    }
    @IBAction func forward() {
    }
    @IBAction func next() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resumeButton.hidden = true;
    }

}
