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
    
    let dailyGoal = 5000
    let pedometer = CMPedometer()
    
    var stepsToday = 0
    
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
    
    func setupRadialProgressView() {
        self.radialView.progressTotal = 100
        self.radialView.progressCounter = 0
        self.radialView.theme.completedColor = UIColor.darkGrayColor()
        self.radialView.theme.incompletedColor = UIColor.clearColor()
        self.radialView.theme.thickness = 15
        self.radialView.theme.sliceDividerHidden = true
        self.radialView.theme.centerColor = self.radialView.theme.incompletedColor
    }

    func handlePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startPedometerUpdatesFromDate(midnight) { [weak self] data, error in
            
                dispatch_async(dispatch_get_main_queue()) {
                    self?.stepsToday = data.numberOfSteps.integerValue
                    self?.stepsTodayLabel.text = "\(self?.stepsToday ?? 0) steps taken today"
                    self?.drawCircle(self?.progress ?? 0)
                }
            }
        }
    }
    
    func drawCircle(progress: Int) {
        if progress >= 100 {
            radialView.theme.completedColor = UIColor.greenColor()
        }
        radialView.progressCounter = UInt(progress)
        radialView.label.text = "\(progress)%"
    }

}
