//
//  SettingsViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra on 11/27/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController
{
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logOutNow(sender: UIButton) {
        PFUser.logOut()
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        navigationItem.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
      self.usernameLabel.text = "Username:   \(PFUser.currentUser().username)"
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.usernameLabel.text = "Username:   \(PFUser.currentUser().username)"
    }
    
}