//
//  GyroscopeViewController.swift
//  CMAttitude
//
//  Created by BJ Miller on 1/7/15.
//  Copyright (c) 2015 Six Five Software, LLC. All rights reserved.
//

import UIKit
import CoreMotion

class GyroscopeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    let motionManager = CMMotionManager()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        motionManager.deviceMotionUpdateInterval = 0.01
        handleImageRotation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        motionManager.stopDeviceMotionUpdates()
        
        super.viewWillDisappear(animated)
    }

    func handleImageRotation() {
        if motionManager.deviceMotionAvailable {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                
                [weak self]
                
                data, error in // (data: CMDeviceMotion!, error: NSError!) in
                
                let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
                self?.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                
            }
        }
    }

}
