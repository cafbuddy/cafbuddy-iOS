//
//  MySignupViewController.swift
//  CafMate
//
//  Created by Jacob Forster on 11/9/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import Foundation

import UIKit

class MySignUpViewController : PFSignUpViewController
{
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        
        //change the logo
        
        /*label.text = "Caf Buddy"
        label.font = UIFont(name: "HoeflerText-BlackItalic", size: 60)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center*/
        
        
        var hamburger = UIImageView(image: UIImage(named: "cafbuddylogo"))
        self.signUpView.logo = hamburger
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.logInView.logInButton.layer.cornerRadius = 3.0
        //self.logInView.signUpButton.backgroundColor = UIColor.blueColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        //redo the log-in fields
        self.signUpView.signUpButton.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.signUpView.signUpButton.frame.origin.y + 35, CGFloat(BUTTON_WIDTH), self.signUpView.signUpButton.frame.height)
        
        self.signUpView.usernameField.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.signUpView.usernameField.frame.origin.y - 10, CGFloat(BUTTON_WIDTH), self.signUpView.usernameField.frame.height + 10)
        self.signUpView.usernameField.layer.cornerRadius = 4.0
        self.signUpView.passwordField.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.signUpView.passwordField.frame.origin.y + 10, CGFloat(BUTTON_WIDTH), self.signUpView.passwordField.frame.height + 10)
        self.signUpView.passwordField.layer.cornerRadius = 4.0
        self.signUpView.emailField.frame = CGRectMake((screenSize.width - CGFloat(BUTTON_WIDTH))/2, self.signUpView.emailField.frame.origin.y + 30, CGFloat(BUTTON_WIDTH), self.signUpView.emailField.frame.height + 10)
        self.signUpView.emailField.layer.cornerRadius = 4.0
        
        self.signUpView.logo.frame = CGRectMake((CGFloat(screenSize.width) - 200)/2,screenSize.height/120, 200, 200)
        
        self.signUpView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.signUpView.signUpButton.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        self.signUpView.signUpButton.layer.cornerRadius = 4.0
        
        //get rid of dismiss button
        /*self.logInView.logo.frame = CGRectMake(0, 75, screenSize.width, 100)
        self.logInView.logInButton.layer.cornerRadius = 5.0*/
        
        
    }
}
