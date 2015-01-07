//
//  ViewController.swift
//  CMAttitude
//
//  Created by BJ Miller on 1/7/15.
//  Copyright (c) 2015 Six Five Software, LLC. All rights reserved.
//

import UIKit
import CoreMotion

let RadToDeg = 57.2957795

class AttitudeViewController: UIViewController {

    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        motionManager.deviceMotionUpdateInterval = 0.01
        handleAttitude()
    }

    func handleAttitude() {
        if motionManager.deviceMotionAvailable {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                
                [weak self]
                
                data, error in // (data: CMDeviceMotion!, error: NSError!) in
                
                self?.rollLabel.text = String(format: "%.2f°", data.attitude.roll * RadToDeg)
                self?.pitchLabel.text = String(format: "%.2f°", data.attitude.pitch * RadToDeg)
                self?.yawLabel.text = String(format: "%.2f°", data.attitude.yaw * RadToDeg)
            }
        }
    }

}

