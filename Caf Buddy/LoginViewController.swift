//
//  LoginViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra on 11/15/14.
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

let BREAKFAST = "Breakfast"
let LUNCH = "Lunch"
let DINNER = "Dinner"

class LogInViewController: UIViewController,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    //@IBOutlet weak var mainTableView: UITableView!
    var mainTableView = UITableView()
    var mealsArrayU = NSMutableArray()
    var mealsArrayP = NSMutableArray()
    var numMeals = 0
    var showChatScreen = false
    var chatScreenMatchId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        println("View Did Load")
        startMealScreen()
        
    }
    
    init(chatScreen:Bool,matchId:String)
    {
        let alert = UIAlertView()
        alert.title = "New Message"
        alert.message = "You got a new message from your buddy!"
        alert.addButtonWithTitle("Cancel")
        alert.show()
        showChatScreen = chatScreen
        chatScreenMatchId = matchId
       super.init(nibName: nil, bundle: nil)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func startMealScreen()
    {
        println("Start Meal Screen Called")
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
    
    func showChatViewController(matchId:String)
    {
        let chatVC = ChatViewController(myMatchId: matchId )
        navigationController?.pushViewController(chatVC, animated: false)
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableFromServer", name:ReloadMealTableNotification, object: nil)
        //println("email verified is \(emailVerified)")
        super.viewDidAppear(animated)
        println("View Did Appear Called")
        if(showChatScreen){
            showChatViewController(chatScreenMatchId) }
        else{
            startMealScreen()
        }
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
    // MARK: Login View Controller Delegate Methods

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
        //updateInterface()
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
        mainTableView.rowHeight = (mainTableView.frame.size.height - CGFloat(NAV_BAR_HEIGHT) - CGFloat(STATUS_BAR_HEIGHT) - CGFloat(49))/5
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
                
                self.mealsArrayU.removeAllObjects()
                self.mealsArrayP.removeAllObjects()
                //println("NumMeals is \(self.numMeals)")
                for (var i=0;i<jsonObject.count;i++)
                {
                    self.numMeals = jsonObject.count
                    var meal = jsonObject[i]["type"].stringValue
                    
                    
                    var mealItem = Dictionary<String, String>()
                    mealItem["matchId"] = jsonObject[i]["matchId"].stringValue//Adding Found matchIds to array
                    if meal=="0" {
                        mealItem["meals"] = BREAKFAST
                    } else if meal=="1" {
                        mealItem["meals"] = LUNCH
                    } else if meal=="2" {
                        mealItem["meals"] = DINNER
                    }
                    mealItem["mealId"] = jsonObject[i]["objectId"].stringValue
                    if !(jsonObject[i]["matched"].stringValue=="true") {
                        mealItem["ifMatched"] = "false"
                        var sTime = jsonObject[i]["start"]["iso"].stringValue
                        var formatterS = NSDateFormatter()
                        formatterS.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        var dateS = formatterS.dateFromString(sTime)
                        formatterS.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT)
                        formatterS.dateFormat = "hh:mm a"
                        var localSTime = formatterS.stringFromDate(dateS!)
                        mealItem["startTime"] = localSTime
                        var eTime = jsonObject[i]["end"]["iso"].stringValue
                        var formatterE = NSDateFormatter()
                        formatterE.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatterE.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        var dateE = formatterE.dateFromString(eTime)
                         formatterE.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT)
                        formatterE.dateFormat = "hh:mm a"
                        var localETime = formatterE.stringFromDate(dateE!)
                        mealItem["endTime"] = localETime
                        mealItem["matchString"] = "Finding Match"
                        mealItem["mealTimeRange"] = "\(localSTime) - \(localETime)"
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
                        mealItem["startTime"] =  localSTime
                        mealItem["endTime"] = ""
                        mealItem["ifMatched"] = "true"
                        mealItem["matchString"] = "Match Found"
                        mealItem["mealTimeRange"] = ""
                    }
                    
                    if (jsonObject[i]["matched"].stringValue=="true")
                    {
                        self.mealsArrayU.addObject(mealItem)
                    }
                    else if(jsonObject[i]["matched"].stringValue=="false")
                    {
                        self.mealsArrayP.addObject(mealItem)
                    }
                }
                //println(self.mealsArrayU)
                //println("Pause")
                //println(self.mealsArrayP)
                self.mainTableView.reloadData()
                //self.updateInterface()
                /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.mainTableView.reloadData()
                })*/
                
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
        return 2
    }
    

    // MARK: Table Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
        if mealsArrayU.count == 0 {
            return 1}
        return mealsArrayU.count
        }
        if mealsArrayP.count == 0 { return 1}
        return mealsArrayP.count
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if indexPath.section == 1
        {
            if mealsArrayP.count == 0 { return false}
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            var query = PFQuery(className:"Meals")
            query.whereKey("objectId", equalTo: mealsArrayP[indexPath.row]["mealId"] as String)
            mealsArrayP.removeObjectAtIndex(indexPath.row)
            self.mainTableView.reloadData()
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(objects.count) scores.")
                    // Do something with the found objects
                    for object in objects {
                        NSLog("%@", object.objectId)
                        object.deleteInBackgroundWithBlock({
                            (succeeded: Bool, error: NSError!) in
                            if succeeded
                            {
                                //self.reloadTableFromServer()
                            }
                        })
                    }
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        }
    }

    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //if first section
        if (section == 0) {
            return "Upcoming Meals"
        }
        
        //if second section
        return "Pending Matches"
    }*/
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        /* Create custom view to display section header... */
        var label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.textAlignment = NSTextAlignment.Center
        label.frame = CGRectMake(0, 0, tableView.frame.size.width, 50)
        var string = "Test"
        if (section == 0) {
            string = "Upcoming Meals"
        }
        else{
        //if second section
        string = "Pending Matches"
        }
        /* Section header is in 0th index... */
        label.text = string
        view.addSubview(label)
        view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        return view;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        var mealsArray:NSMutableArray!
        if (indexPath.section == 0) {mealsArray = mealsArrayU
            if mealsArrayU.count == 0 {
                return}
        }
        else {mealsArray = mealsArrayP
            if mealsArrayP.count == 0 {
                return}
        }
        
        if( mealsArray[indexPath.row]["ifMatched"] as String == "true" )
         {
        //let chatVC = ChatViewController(myMatchId: mealsArray[indexPath.row]["matchId"] as String )
        let chatVC = ChatViewControllerTest(myMatchId: mealsArray[indexPath.row]["matchId"] as String )
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var customcell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as CustomTableViewCell
        
        
        
        var mealsArray:NSMutableArray!
        if (indexPath.section == 0) {mealsArray = mealsArrayU
            if mealsArrayU.count == 0
            {
                customcell.loadItem("You have",rangeOfTime: "",timeOfMeal: "NO",matching: "Upcoming Meals!!")
                return customcell
            }
        }
        else {mealsArray = mealsArrayP
        
            if mealsArrayP.count == 0
            {
                customcell.loadItem("You have",rangeOfTime: "",timeOfMeal: "NO",matching: "Pending Matches!!")
                return customcell
            }
        }
        println(mealsArray)
        customcell.whichMeal.text = mealsArray[indexPath.row]["meals"] as? String
        var tempMealType = mealsArray[indexPath.row]["meals"] as String
        var tempStartTime = mealsArray[indexPath.row]["startTime"] as String
        var tempMatchingString = mealsArray[indexPath.row]["matchString"] as String!
        var tempMealRange = mealsArray[indexPath.row]["mealTimeRange"] as String
        if (mealsArray[indexPath.row]["ifMatched"] as String == "true") {
            customcell.loadItem("\(tempMealType)",rangeOfTime: "",timeOfMeal: "\(tempStartTime)",matching: "\(tempMatchingString)")
        } else {
            customcell.loadItem("\(tempMealType)",rangeOfTime: "\(tempMealRange)",timeOfMeal: "",matching: "\(tempMatchingString)")
        }
        return customcell
    }

}