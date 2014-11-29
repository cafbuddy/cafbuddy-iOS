//
//  LoginViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra2 on 11/15/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import Foundation
import UIKit
extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

class LogInViewController: UIViewController,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    //@IBOutlet weak var mainTableView: UITableView!
    var mainTableView = UITableView()
    var numMeals = 0
    var meals: [String] = []
    var ifMatched: [Bool] = []
    var startTime: [String] = []
    var endTime: [String] = []
    var matchString: [String] = []
    var mealTimeRange: [String] = []
    var matchId: [String] = []
    var breakfast = "Breakfast"
    var lunch = "Lunch"
    var dinner = "Dinner"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("View Did Load")
        startMealScreen()
    }
    
    func startMealScreen()
    {
        mainTableView.allowsSelection = true
        if var currentUser = PFUser.currentUser()
        {
           
           if var emailVerified = currentUser.objectForKey("emailVerified") as? Bool
           {
                println("Current User is \(currentUser.email)")
                navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
                navigationItem.title = "My Meals"
                navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
                
                self.mainTableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
                
                initInterface()
           }
            else
            {
                showLoginView()
                showEmailNotVerifiedAlert()
            }
        }
        else
        {
            showLoginView()
        }
    }
    func showEmailNotVerifiedAlert()
    {
        let alert = UIAlertView()
        alert.title = "Email Not Verified"
        alert.message = "Please Check and Verify Your Email Before Logging In"
        alert.addButtonWithTitle("Cancel")
        alert.show()
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableFromServer", name:ReloadMealTableNotification, object: nil)

        //println("email verified is \(emailVerified)")
        super.viewDidAppear(animated)
        println("View Did Appear")
        startMealScreen()
    }
    
    func showLoginView()
    {
        let logInViewController:PFLogInViewController = MyLoginViewController()
        logInViewController.delegate = self
        let signUpViewController = MySignUpViewController()
        signUpViewController.delegate = self
        
        
        logInViewController.signUpController = signUpViewController
        presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        if ((username != nil) && (password != nil) && (countElements(username) != 0) && (countElements(password) != 0))
        {
            return true
        }
        
        let alert = UIAlertView()
        alert.title = "Missing Information"
        alert.message = "Make Sure You Fill Out All Your Information"
        alert.addButtonWithTitle("Cancel")
        alert.show()
        
        return false
    }
    
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        
        dismissViewControllerAnimated(true, completion: nil)
        println("User Login Succesful")
        /*
        PFInstallation *installation = [PFInstallation currentInstallation];
        installation[@"user"] = [PFUser currentUser];
        [installation saveInBackground];*/
        let installation = PFInstallation.currentInstallation()
        installation["userId"] = PFUser.currentUser()
        installation.saveInBackground()
        //goToMainFeed()
        updateInterface()
        //reloadTableFromServer()
    }
    
    
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        
        println("Failed to Log In")
        
        
    }
    
    
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: MySignUpViewController!) {
        println("User Dismissed the Sign Up View Controller")
    }
    
    func signUpViewController(signUpController: MySignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        //println(info)
        var message = ""
        var isValid = true
        var emailEnd = ""
        for (key, value) in info {
            let fieldValue: AnyObject? = value
            println("Key is \(key) and values is \(value)")
            
            if key == "username"
            {
                
                var email = value as String
                let emailLength = countElements(email)
                
                if emailLength > 11
                {
                    emailEnd = email[(emailLength-11)...(emailLength-1)]
                }
                else
                {
                    isValid = false
                    message = message+"Sorry Email too short."
                }
                
                if (email.rangeOfString("@") == nil)
                {
                    isValid = false
                    println("Email Invalid does not contain @ sign")
                    message = message+" Email does not contain @ sign."
                    break
                    
                }
                if (emailEnd != "@stolaf.edu" )
                {
                    isValid = false
                    println("Sorry we only accept St Olaf Emails")
                    message = message+" Email Invalid, Sorry we only accept St Olaf Emails."
                    break
                }
                
            }
            if ((fieldValue == nil) || fieldValue?.length == 0) { // check completion
                isValid = false;
                break;
            }
            
            if ((fieldValue == nil) || fieldValue?.length < 8) { // check completion
                isValid = false;
                message = message+" Password needs to be at least 8 characters long."
                break;
            }
            
            
        }
        
        if(!isValid){
            let alert = UIAlertView()
            alert.title = "Error!"
            alert.message = message
            alert.addButtonWithTitle("Cancel")
            alert.show()
        }
        
        /*
        else if (countElements(self.signUpView.usernameField.text!) < 2) {
        NSLog("signup field text less than 2")
        // display alert
        informationComplete = false
        } else if (self.signUpView.passwordField) {
        NSLog("password error ")
        // display alert
        informationComplete = false
        }
        }*/
        return isValid
    }
    
    
    func signUpViewController(signUpController: MySignUpViewController!, didSignUpUser user: PFUser!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: MySignUpViewController!, didFailToSignUpWithError error: NSError!) {
        println("Failed to sign up...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initInterface() {
        var screenWidth = Float(self.view.frame.size.width)
        var screenHeight = Float(self.view.frame.size.height)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.frame = CGRectMake(0,0, CGFloat(screenWidth),CGFloat(screenHeight))
        
        self.view.addSubview(mainTableView)
        
        var floatNumMeals = Float(self.numMeals)
        //var cellHeight = self.view.frame.size.height
        mainTableView.rowHeight = (mainTableView.frame.size.height - CGFloat(NAV_BAR_HEIGHT) - CGFloat(STATUS_BAR_HEIGHT) - CGFloat(49))/3
        //mainTableView.rowHeight = CGFloat( cellheight - 69)/CGFloat(floatNumMeals)
        
        //updateInterface()
        reloadTableFromServer()
    }
    
    func reloadTableFromServer() {
        var userObjectID = PFUser.currentUser().objectId
        //println(userObjectID)
        //println("Something should print")
        PFCloud.callFunctionInBackground("getMealsToday", withParameters:["objectID":userObjectID]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                //println("Something should print")
                //println(result)
                //var test = "{\"firstName\":\"John\", \"lastName\":\"Doe\"}"
                let testData = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let jsonObject = JSON(data: testData!, options: nil, error: nil)
                //println(jsonObject[0]["createdAt"].stringValue)
                
                //Empty All Arrays
                
                self.meals = []
                self.ifMatched = []
                self.startTime = []
                self.endTime = []
                self.matchString = []
                self.mealTimeRange = []
                self.matchId = []

                //println("NumMeals is \(self.numMeals)")
                for (var i=0;i<jsonObject.count;i++)
                {
                    self.numMeals = jsonObject.count
                    var meal = jsonObject[i]["type"].stringValue
                    self.matchId.append(jsonObject[i]["matchId"].stringValue)//Adding Found matchIds to array
                    if meal=="0" {
                        self.meals.append(self.breakfast)
                    } else if meal=="1" {
                        self.meals.append(self.lunch)
                    } else if meal=="2" {
                        self.meals.append(self.dinner)
                    }
                    
                    if !(jsonObject[i]["matched"].stringValue=="true") {
                        self.ifMatched.append(false)
                        var sTime = jsonObject[i]["start"]["iso"].stringValue
                        var formatterS = NSDateFormatter()
                        formatterS.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        var dateS = formatterS.dateFromString(sTime)
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT)
                        formatterS.dateFormat = "hh:mm a"
                        var localSTime = formatterS.stringFromDate(dateS!)
                        self.startTime.append(localSTime)
                        var eTime = jsonObject[i]["end"]["iso"].stringValue
                        var formatterE = NSDateFormatter()
                        formatterE.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatterE.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        var dateE = formatterE.dateFromString(eTime)
                         formatterE.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT)
                        formatterE.dateFormat = "hh:mm a"
                        var localETime = formatterE.stringFromDate(dateE!)
                        self.endTime.append(localETime)
                        self.matchString.append("Finding Match")
                        self.mealTimeRange.append("\(self.startTime[i]) - \(self.endTime[i])")
                    }
                    else {
                        var sTime = jsonObject[i]["start"]["iso"].stringValue
                        var formatterS = NSDateFormatter()
                        formatterS.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        var dateS = formatterS.dateFromString(sTime)
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT)
                        formatterS.dateFormat = "hh:mm a"
                        var localSTime = formatterS.stringFromDate(dateS!)
                        /*
                        var sTime = jsonObject[i]["start"]["iso"].stringValue
                        var formatterS = NSDateFormatter()
                        formatterS.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        var dateS = formatterS.dateFromString(sTime)
                        formatterS.dateFormat = "hh:mm a"
                        var localSTime = formatterS.stringFromDate(dateS!)
                        */
                        self.startTime.append(localSTime)
                        self.endTime.append("")
                        self.ifMatched.append(true)
                        self.matchString.append("Match Found")
                        self.mealTimeRange.append("")
                    }
                }
                //println("Here is the meals array \(self.meals)")
                //println("Here is the startTime array \(self.startTime)")
                //println("Here is the endTime array \(self.endTime)")
                println(" ifMatched.count = \(self.ifMatched.count)")
                //self.mainTableView.reloadData()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.mainTableView.reloadData()
                })
                //println("Tried to Call Reload Data")
            }
            else{
                println("error")
            }
        }
    }
    
    func updateInterface() {
        ///ADD UPDATE INTERFACE CODE HERE
        var currentUser = PFUser.currentUser()
        
        
        if(currentUser == nil ){
            
        }
        else{
            var emailVerified = currentUser.objectForKey("emailVerified") as Bool
            if(emailVerified){
                navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
                navigationItem.title = "My Meals"
                navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
                
                self.mainTableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
                initInterface()
            }
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("here")
        //println("Num Rows in selection numMeals = \(self.numMeals)")
        return countElements(ifMatched)
        //return self.numMeals
        //return 4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                    //let chatVC = ChatViewController()
                    //self.presentViewController(chatVC, animated: true, completion: nil)
         if (ifMatched[indexPath.row]==true) {
        let chatVC = ChatViewController(myMatchId: self.matchId[indexPath.row])
        UIView.beginAnimations("ShowDetails", context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(0.5)
        navigationController?.pushViewController(chatVC, animated: false)
        let theView = navigationController?.view
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: theView!, cache: false)
        //UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp, forView: theView!, cache: false)
        UIView.commitAnimations()
        mainTableView.allowsSelection = false
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var customcell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomTableViewCell
        
        //var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as CustomTableViewCell
        
        //customcell.whichMeal.text = self.meals[indexPath.row]
        
        //customcell.loadItem("test test s df s dfsdf")
        
        //        println(self.meals.count)
        
        if (ifMatched[indexPath.row]==true) {
            
            customcell.loadItem("\(self.meals[indexPath.row])",rangeOfTIme: "",timeOfMeal: "\(self.startTime[indexPath.row])",matching: "\(self.matchString[indexPath.row])")
            
            
        } else {
            
            customcell.loadItem("\(self.meals[indexPath.row])",rangeOfTIme: "\(self.mealTimeRange[indexPath.row])",timeOfMeal: "",matching: "\(self.matchString[indexPath.row])")
            
        }
        
        return customcell
    }

}