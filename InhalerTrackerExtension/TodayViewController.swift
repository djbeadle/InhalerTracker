//
//  TodayViewController.swift
//  InhalerTrackerExtension
//
//  Created by Daniel Beadle on 2/18/18.
//  Copyright © 2018 Daniel Beadle. All rights reserved.
//

import UIKit
import NotificationCenter
import HealthKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var feedbackImage: UIImageView!
    @IBOutlet weak var stepperDisplay: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var submitButton: UIButton!
    
    var puffCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        // Get the current date / time:
        let inhaleTime = Date()
        
        // Parse date & time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let strDate = dateFormatter.string(from: inhaleTime)
        
        // Define the data type we're using, make sure they're available on this device
        guard let inhalerUsage = HKObjectType.quantityType(forIdentifier: .inhalerUsage) else
        {
            // print("InhalerUsage type not available on this device.")
            return
        }
        
        // Transform the puffCount variable in to a HealthKit quanitity
        let dataPoint = HKQuantity(unit: HKUnit(from: "count"), doubleValue: Double(puffCount))
        
        // Log to HealthKit
        print("Logging the following data to HealthKit from the Today Extension: \(puffCount) puffs at \(strDate)")
        let quantitySample = HKQuantitySample(type: inhalerUsage, quantity: dataPoint, start: inhaleTime, end: inhaleTime)
        let healthStore = HKHealthStore()
        healthStore.save(quantitySample) { (success, error) in
            if let error = error
            {
                print ("Error saving inhaler usage: \(error.localizedDescription)")
                // Can't update the UI from a completion handler
                DispatchQueue.main.async {
                    self.feedbackImage.image = UIImage(named: "failure.png")
                    print("🚫")
                }
                
            } else
            {
                print ("Successfully saved inhaler usage!")
                // Can't update the UI from a completion handler
                DispatchQueue.main.async {
                    self.feedbackImage.image = UIImage(named: "success.png")
                    print("✅")
                }
            }
        }
    }
    
    private func authorizeHealthKit()
    {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    // print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    // print(baseMessage)
                }
                return
            }
            // print("HealthKit Successfully Authorized.")
        }
    }
    @IBAction func stepperChanged(_ sender: UIStepper) {
        // Clear the feedback display
        feedbackImage.image = nil
        
        // Update the counter text field
        puffCount = Int(sender.value)
        stepperDisplay.text = puffCount.description
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        print("The today widget is online, Captain!")
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.noData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.noData)
    }
    
}
