//
//  PedometerViewController.swift
//  CMAttitude
//
//  Created by BJ Miller on 1/7/15.
//  Copyright (c) 2015 Six Five Software, LLC. All rights reserved.
//

import UIKit
import CoreMotion

class PedometerViewController: UIViewController {

    @IBOutlet weak var stepsTodayLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var radialView: MDRadialProgressView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    let dailyGoal = 5000
    let pedometer = CMPedometer()
    let dateFormatter = NSDateFormatter()
    
    var stepsToday = 0
    var lastUpdated = NSDate()
    var lastDistance = 0.0
    
    var midnight: NSDate {
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        return cal.startOfDayForDate(NSDate())
    }
    
    var progress: Int {
        return (stepsToday * 100) / dailyGoal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalLabel.text = "Daily goal: \(dailyGoal) steps"
        
        setupRadialProgressView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        handlePedometer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        pedometer.stopPedometerUpdates()
        
        super.viewWillDisappear(animated)
    }
    
    func handlePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startPedometerUpdatesFromDate(midnight) { [weak self] data, error in
            
                let meters = data.distance.doubleValue
                let distanceFormatter = NSLengthFormatter()
                
                let timeDelta = data.endDate.timeIntervalSinceDate(self?.lastUpdated ?? NSDate())
                let distanceDelta = meters - (self?.lastDistance ?? 0.0)
                let rate = distanceDelta / timeDelta
                
                self?.lastUpdated = NSDate()
                self?.lastDistance = meters
                
                dispatch_async(dispatch_get_main_queue()) {
                    self?.stepsToday = data.numberOfSteps.integerValue
                    self?.stepsTodayLabel.text = "\(self?.stepsToday ?? 0) steps taken today"
                    self?.distanceLabel.text = "\(distanceFormatter.stringFromMeters(meters))"
                    self?.rateLabel.text = "\(distanceFormatter.stringFromMeters(rate)) / s"
                    self?.drawCircle(self?.progress ?? 0)
                }
            }
        }
    }
    
    // Radial progress view
    func setupRadialProgressView() {
        self.radialView.progressTotal = 100
        self.radialView.progressCounter = 0
        self.radialView.theme.completedColor = UIColor.darkGrayColor()
        self.radialView.theme.incompletedColor = UIColor.clearColor()
        self.radialView.theme.thickness = 15
        self.radialView.theme.sliceDividerHidden = true
        self.radialView.theme.centerColor = self.radialView.theme.incompletedColor
    }
 
    func drawCircle(progress: Int) {
        if progress >= 100 {
            radialView.theme.completedColor = UIColor.greenColor()
        }
        radialView.progressCounter = UInt(progress)
        radialView.label.text = "\(progress)%"
    }

}
