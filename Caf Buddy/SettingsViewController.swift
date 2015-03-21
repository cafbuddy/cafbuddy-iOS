//
//  SettingsViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra on 11/27/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import Foundation
import UIKit



/*



Lets make this a table maybe and add in an "about us", version information, and terms of service sections to the app.

Then find a transparent silhouette and make it small...



*/



class SettingsViewController: UIViewController
{
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var buttonLogOut = UIButton()

    
    override func viewDidLoad() {
        //navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        //navigationItem.title = "Settings"
        //navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        navigationItem.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
      //self.usernameLabel.text = "Username:   \(PFUser.currentUser().username)"
        
        initInterface()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.usernameLabel.text = "Username:   \(PFUser.currentUser().username)"
    }
    
    func initInterface() {
        self.view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        
        buttonLogOut.titleForState(UIControlState.Normal)
        buttonLogOut.setTitle("Log Out", forState: UIControlState.Normal)
        buttonLogOut.frame = CGRectMake((screenSize.width - 300)/2, screenSize.height - 130, 300, 50)
        buttonLogOut.titleLabel?.font = UIFont.systemFontOfSize(20)
        buttonLogOut.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        buttonLogOut.layer.cornerRadius = 3.0
        
        //var imageView = UIImageView(frame: CGRectMake((screenSize.width - 200)/2, 100, 200, 200));
        //var image = UIImage(named: "silhouette.jpeg");
        //imageView.image = image;
        //self.view.addSubview(imageView);
        
        var userName = UILabel(frame: CGRectMake(140,275,100,500))
        var currentUser = PFUser.currentUser()
        userName.text = "\(currrentUser.email)"
        userName.font = UIFont.italicSystemFontOfSize(20)
        
        self.view.addSubview(buttonLogOut)
        self.view.addSubview(userName)
    }
    
    
}