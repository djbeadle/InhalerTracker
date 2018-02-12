//
//  infoVC.swift
//  InhalerTrackerV2
//
//  Created by Daniel Beadle on 2/11/18.
//  Copyright © 2018 Daniel Beadle. All rights reserved.
//

import Foundation
import UIKit

class infoVC: UIViewController{
    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var darkMode: UISwitch!
    
    @IBOutlet weak var bylineText: UITextView!
    @IBOutlet weak var iconCreditText: UITextView!
    @IBOutlet weak var sourceText: UITextView!
    @IBOutlet weak var privacyText: UITextView!
    @IBOutlet weak var darkModeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // More customizations:
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "darkMode")
        if(darkModeEnabled)
        {
            view.backgroundColor = .black
            bylineText.textColor = .white
            iconCreditText.textColor = .white
            sourceText.textColor = .white
            privacyText.textColor = .white
            darkModeText.textColor = .white
            darkMode.setOn(true, animated: false)
        }
        else
        {
            view.backgroundColor = .white
            bylineText.textColor = .black
            iconCreditText.textColor = .black
            sourceText.textColor = .black
            privacyText.textColor = .black
            darkModeText.textColor = .black
            darkMode.setOn(false, animated: false)
        }
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeUIMode(_ sender: UISwitch) {
        print("Changing UI Mode!")
        
        // Update the user defaults:
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "darkMode")
        if (darkModeEnabled)
        {
            defaults.set(false, forKey: "darkMode")
            
            view.backgroundColor = .white
            bylineText.textColor = .black
            iconCreditText.textColor = .black
            sourceText.textColor = .black
            privacyText.textColor = .black
            darkModeText.textColor = .black
        }
        else
        {
            defaults.set(true, forKey: "darkMode")
            
            view.backgroundColor = .black
            bylineText.textColor = .white
            iconCreditText.textColor = .white
            sourceText.textColor = .white
            privacyText.textColor = .white
            darkModeText.textColor = .white
        }
        
        
        NotificationCenter.default.post(name: Notification.Name("DarkModeChanged"), object: nil)

        
    }
    
}
