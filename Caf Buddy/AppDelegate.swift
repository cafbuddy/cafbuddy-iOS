//
//  AppDelegate.swift
//  Caf Buddy
//
//  Created by Armaan Bindra on 11/9/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import UIKit
import AVFoundation
let ReloadMealTableNotification = "ReloadMealTableNotification"
let ReloadChatTableNotification = "ReloadChatTableNotification"
let LoadChatViewControllerNotification = "LoadChatViewControllerNotification"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var payload = NSDictionary()
    var audioPlayer = AVAudioPlayer()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("APIKey", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let ApiKey = dict.objectForKey("AppId") as String
            let ClientKey = dict.objectForKey("ClientKey") as String
            println(ApiKey)
            println(ClientKey)
            Parse.setApplicationId(ApiKey, clientKey:ClientKey)
        }
        
        UITabBar.appearance().selectedImageTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        let types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        println(window?.rootViewController?.description)
        if let notificationPaylod =  launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary
        {

            let myMatchId = notificationPaylod.objectForKey("matchId") as? String
            
            launchChatScreen(myMatchId!)
        }
        

        return true
    }
    
    func launchChatScreen(myMatchId:String)
    {
        let chatVC = LogInViewController(chatScreen: true, matchId: myMatchId)
        let tabController = window?.rootViewController
        tabController?.presentViewController(chatVC, animated: false, completion: nil)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        println("called register for remote notification")
        var currentInstallation: PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        //currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        println(error.localizedDescription)
    }
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]!) {
        
        //println("received remote notification \(userInfo)")
        let dict = userInfo as NSDictionary
        if(dict.objectForKey("pushType") as String == "Chat")
        {
            let aps: AnyObject? = dict.objectForKey("aps")
            let recievedMessage = aps?.objectForKey("alert") as String
            let recievedMatchId = dict.objectForKey("matchId") as String
            var chatSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("MealChat", ofType: "wav")!)
            audioPlayer = AVAudioPlayer(contentsOfURL: chatSound, error: nil)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            //println(recievedMessage)
            //println(recievedMatchId)
            
            //DataModel.addMessageToPlist("buddy", message: recievedMessage, matchId: recievedMatchId)
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: ReloadChatTableNotification, object: self))
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: ReloadMealTableNotification, object: self))
            PFPush.handlePush(userInfo)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

