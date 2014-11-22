//
//  MyLoginViewController.swift
//  CafMate
//
//  Created by Joseph Peterson on 11/8/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import UIKit

class MyLoginViewController : PFLogInViewController,PFLogInViewControllerDelegate
{
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        
        //change the logo
        
        label.text = "Caf Buddy"
        label.font = UIFont(name: "HoeflerText-BlackItalic", size: 60)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        self.logInView.logo = label
        
        //get rid of the dismiss button
        self.logInView.dismissButton.enabled = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!(PFUser.currentUser() != nil))
        {
            let logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            logInViewController.facebookPermissions = ["friends_about_me"]
            logInViewController.fields = PFLogInFields.Facebook | PFLogInFields.DismissButton
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //redo the log-in fields
        self.logInView.logInButton.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.logInView.logInButton.frame.origin.y - 5, CGFloat(BUTTON_WIDTH), self.logInView.logInButton.frame.height)
        
        self.logInView.usernameField.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.logInView.usernameField.frame.origin.y - 30, CGFloat(BUTTON_WIDTH), self.logInView.usernameField.frame.height + 10)
        self.logInView.usernameField.layer.cornerRadius = 4.0
        self.logInView.passwordField.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.logInView.passwordField.frame.origin.y - 10, CGFloat(BUTTON_WIDTH), self.logInView.passwordField.frame.height + 10)
        self.logInView.passwordField.layer.cornerRadius = 4.0
        
        //get rid of dismiss button
        self.logInView.dismissButton.frame = CGRectMake(-100, -100, 0,0)
        self.logInView.logo.frame = CGRectMake(0, 75, screenSize.width, 100)
        self.logInView.logInButton.layer.cornerRadius = 4.0
        
        self.logInView.logInButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.logInButton.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        
        self.logInView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.signUpButton.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        self.logInView.signUpButton.layer.cornerRadius = 4.0
        
        
    }
}