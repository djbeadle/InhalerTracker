//
//  ViewController.swift
//  InhalerTrackerV2
//
//  Created by Daniel Beadle on 2/3/18.
//  Copyright © 2018 Daniel Beadle. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    @IBOutlet weak var outputDisplay: UITextField!
    @IBOutlet weak var puffCounter: UIStepper!
    @IBOutlet weak var inhaleTime: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var outputImage: UIImageView!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet var mainView: UIView!
    
    let successImage = UIImage(named: "success.png")
    let failureImage = UIImage(named: "failure.png")
    
    private let authorizeHealthKitSection = 2
    var puffCount = 1
    var strDate = ""
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authorizeHealthKit()
        
        // Was dark mode turned on in the infoVIew?
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDarkMode), name: NSNotification.Name("DarkModeChanged"), object: nil)

        // Dark mode!
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "darkMode")
        if darkModeEnabled
        {
            // print("Presenting dark mode")
            mainView.backgroundColor = .black
            outputDisplay.textColor = .lightGray
            inhaleTime.setValue(UIColor.lightGray, forKeyPath: "textColor")
            inhaleTime.setValue(false, forKeyPath: "highlightsToday")
            
            self.navigationController?.navigationBar.barTintColor = .darkGray
        }
        else
        {
            // print("Presenting light mode")
            mainView.backgroundColor = .white
            outputDisplay.textColor = .black
            inhaleTime.setValue(UIColor.black, forKeyPath: "textColor")
            inhaleTime.setValue(false, forKeyPath: "highlightsToday")
            
            self.navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    @objc func toggleDarkMode()
    {
        // Dark mode!
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "darkMode")
        if darkModeEnabled
        {
            // print("Turning on dark mode!")
            mainView.backgroundColor = .black
            outputDisplay.textColor = .lightGray
            inhaleTime.setValue(UIColor.lightGray, forKeyPath: "textColor")
            inhaleTime.setValue(false, forKeyPath: "highlightsToday")
            
            self.navigationController?.navigationBar.barTintColor = .darkGray
        }
        else
        {
            // print("Turning on light mode!")
            mainView.backgroundColor = .white
            outputDisplay.textColor = .black
            inhaleTime.setValue(UIColor.black, forKeyPath: "textColor")
            inhaleTime.setValue(false, forKeyPath: "highlightsToday")
            
            self.navigationController?.navigationBar.barTintColor = .white
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func puffCounter(_ sender: UIStepper)
    {
        // clear feedbackDisplay
        outputImage.image = nil
        
        // outputDisplay.text = Int(sender.value).description
        puffCount = Int(sender.value)
        outputDisplay.text = puffCount.description
        // print("Puff Count: \(puffCount)")
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker)
    {
        // clear feedbackDisplay
        outputImage.image = nil
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        // Parse date & time from the picker
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        strDate = dateFormatter.string(from: inhaleTime.date)
        
        // Define the data type we're using, make sure they're available on this device
        guard let inhalerUsage = HKObjectType.quantityType(forIdentifier: .inhalerUsage) else
        {
            // print("InhalerUsage type not available on this device.")
            return
        }
        
        // Transform the puffCount variable in to a HealthKit quanitity
        let dataPoint = HKQuantity(unit: HKUnit(from: "count"), doubleValue: Double(puffCount))
        
        // Log to HealthKit
        // print("Logging the following data to HealthKit: \(puffCount) puffs at \(strDate)")
        let quantitySample = HKQuantitySample(type: inhalerUsage, quantity: dataPoint, start: inhaleTime.date, end: inhaleTime.date)
        
        let healthStore = HKHealthStore()
        healthStore.save(quantitySample) { (success, error) in
            if let error = error
            {
                print ("Error saving inhaler usage: \(error.localizedDescription)")
                // Can't update the UI from a completion handler
                DispatchQueue.main.async {
                    self.outputImage.image = UIImage(named: "failure.png")
                    // self.feedbackDisplay.text = "🚫"
                }
                
            } else
            {
                print ("Successfully saved inhaler usage!")
                // Can't update the UI from a completion handler
                DispatchQueue.main.async {
                    self.outputImage.image = UIImage(named: "success.png")
                    // self.feedbackDisplay.text = "✅"
                }
            }
        }
        
    }
}

