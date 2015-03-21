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
    var aboutButton = UIButton()
    var termsOfServiceButton = UIButton()
    var userName = UILabel()

    
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
        
        aboutButton.titleForState(UIControlState.Normal)
        aboutButton.setTitle("About", forState: UIControlState.Normal)
        aboutButton.frame = CGRectMake((screenSize.width - 300)/2, screenSize.height-CGFloat(TAB_BAR_HEIGHT)-30, 145, 25)
        aboutButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        aboutButton.backgroundColor = colorWithHexString(COLOR_COOL_GREY)
        aboutButton.layer.cornerRadius = 3.0
        
        termsOfServiceButton.titleForState(UIControlState.Normal)
        termsOfServiceButton.setTitle("Terms Of Service", forState: UIControlState.Normal)
        termsOfServiceButton.frame = CGRectMake((screenSize.width - 300)/2+155, screenSize.height-CGFloat(TAB_BAR_HEIGHT)-30, 145, 25)
        termsOfServiceButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        termsOfServiceButton.backgroundColor = colorWithHexString(COLOR_COOL_GREY)
        termsOfServiceButton.layer.cornerRadius = 3.0
        
        buttonLogOut.titleForState(UIControlState.Normal)
        buttonLogOut.setTitle("Log Out", forState: UIControlState.Normal)
        buttonLogOut.frame = CGRectMake((screenSize.width - 300)/2, screenSize.height-CGFloat(TAB_BAR_HEIGHT)-85, 300, 50)
        buttonLogOut.titleLabel?.font = UIFont.systemFontOfSize(20)
        buttonLogOut.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        buttonLogOut.layer.cornerRadius = 3.0
        
        //var imageView = UIImageView(frame: CGRectMake((screenSize.width - 200)/2, 100, 200, 200));
        //var image = UIImage(named: "silhouette.jpeg");
        //imageView.image = image;
        //self.view.addSubview(imageView);
        
        userName.frame = CGRectMake(0, CGFloat(NAV_BAR_HEIGHT+10), screenSize.width, 50)
        var currentUser = PFUser.currentUser()
        userName.text = "Current User: \(currentUser.username)"
        userName.font = UIFont.systemFontOfSize(20)
        userName.textAlignment = .Center
        
        self.view.addSubview(buttonLogOut)
        self.view.addSubview(userName)
        self.view.addSubview(aboutButton)
        self.view.addSubview(termsOfServiceButton)
    }
    
    
}