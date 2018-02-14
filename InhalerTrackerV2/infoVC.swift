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
    @IBOutlet weak var navbar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // More customizations:
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "darkMode")
        if(darkModeEnabled)
        {
            print("Presenting dark mode")
            view.backgroundColor = .black
            bylineText.textColor = .lightGray
            iconCreditText.textColor = .lightGray
            sourceText.textColor = .lightGray
            privacyText.textColor = .lightGray
            darkModeText.textColor = .lightGray
            darkMode.setOn(true, animated: false)
            
            self.navigationController?.navigationBar.barTintColor = .darkGray
        }
        else
        {
            print("Presenting light mode")
            view.backgroundColor = .white
            bylineText.textColor = .black
            iconCreditText.textColor = .black
            sourceText.textColor = .black
            privacyText.textColor = .black
            darkModeText.textColor = .black
            darkMode.setOn(false, animated: false)
            
            self.navigationController?.navigationBar.barTintColor = .white
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
            print("Switching to light mode")
            defaults.set(false, forKey: "darkMode")
            
            view.backgroundColor = .white
            bylineText.textColor = .black
            iconCreditText.textColor = .black
            sourceText.textColor = .black
            privacyText.textColor = .black
            darkModeText.textColor = .black
            
            self.navigationController?.navigationBar.barTintColor = .white

        }
        else
        {
            print("Switching to dark mode")
            defaults.set(true, forKey: "darkMode")
            view.backgroundColor = .black
            bylineText.textColor = .lightGray
            iconCreditText.textColor = .lightGray
            sourceText.textColor = .lightGray
            privacyText.textColor = .lightGray
            darkModeText.textColor = .lightGray
            
            self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        }
        NotificationCenter.default.post(name: Notification.Name("DarkModeChanged"), object: nil)
    }
    
}
