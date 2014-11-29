//
//  SettingsViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra2 on 11/27/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController
{
    let logOutButton = UIButton()
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        navigationItem.title = "Adjust Settings"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        logOutButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        logOutButton.setTitle("Log Out", forState: .Normal)
        logOutButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
        logOutButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        logOutButton.addTarget(self, action: "logOutUser", forControlEvents: UIControlEvents.TouchUpInside)
        logOutButton.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 30)
      self.view.addSubview(logOutButton)
    }
    
    func logOutUser()
    {
        PFUser.logOut()
        self.tabBarController?.selectedIndex = 0
    }
}