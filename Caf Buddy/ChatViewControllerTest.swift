//
//  ChatViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra on 11/24/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import UIKit
import AVFoundation


class ChatViewControllerTest: JSQMessagesViewController, UIAlertViewDelegate {
    
    var user: User?
    
    private var messages: Array<JSQMessageData> = []
    private var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    private var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleBlueColor())
    private var systemBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    private var avatars = [String: UIImage]()
    
    private var typing = false
    private var stopTypingTimer: NSTimer?
    
    var matchId = ""
    var friendId = ""
    var userId = ""
    var chatLoadTimer:NSTimer!
    var messageCount =  0
    var audioPlayer = AVAudioPlayer()
    var startCounter = 0
    
    init(myMatchId:String) {
        matchId = myMatchId
        userId = PFUser.currentUser().objectId
        
        println("My match ID is \(matchId)")
        super.init(nibName: nil, bundle: nil)
        user = User()
        user?.username = userId
        self.hidesBottomBarWhenPushed = true
        getFriendUserId()
        var chatSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("MealChat", ofType: "wav")!)
        audioPlayer = AVAudioPlayer(contentsOfURL: chatSound, error: nil)
        //self.inputToolbar.contentView.leftBarButtonItemWidth = 70.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadChatTable", name:ReloadChatTableNotification , object: nil)
        if let username = self.user?.username {
            var image = JSQMessagesAvatarFactory.avatarWithUserInitials(avatarLetters(username),
                backgroundColor: UIColor(white: CGFloat(0.85), alpha: 1),
                textColor: UIColor(white: 0.6, alpha: 1),
                font: UIFont.systemFontOfSize(14),
                diameter: UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width))
            self.avatars[username] = image
        }
        
        var systemAvatar = JSQMessagesAvatarFactory.avatarWithImage(UIImage(named: "SHIP"),
            diameter: UInt(self.collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        self.avatars["System"] = systemAvatar
        
        setupUI()
        //Call Method to Load Messages
        reloadChatTable()
        //chatLoadTimer = NSTimer(timeInterval: 4.0, target: self, selector: "reloadChatTable", userInfo: nil, repeats: true)
        
    }
    
    func setupUI() {
        navigationItem.title = "My Buddy"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "options")
        self.inputToolbar.contentView.leftBarButtonItem.removeFromSuperview()
        let temp = self.inputToolbar.contentView.textView.frame
        //self.inputToolbar.contentView.textView.frame = CGRectMake(0, temp.origin.y, temp.width, temp.height)
    }
    
    func options() {
        //UIAlertView(title: "Log out", message: "Are you sure you want to log out?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
    }
    
    
    func reloadChatTable()
    {
        println("reloadChatTable Called")
        var query = PFQuery(className:"Chat")
        query.whereKey("matchId", equalTo:matchId)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) chat items.")
                // Do something with the found objects
                self.messages  = []
                for object in objects {
                    let senderID = object["Sender"] as String!
                    var sender = ""
                    if senderID == self.userId
                    {
                        sender = "Me"
                    }
                    else
                    {
                        sender = "Buddy"
                    }
                    let body = object["text"] as String!
                    let tempMessage = Message(body: body, sender: sender)
                    self.messages.append(tempMessage)
                }
                if ((self.messages.count > self.messageCount) && self.messageCount != 0)
                {
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                }
                self.messageCount = self.messages.count
                self.startCounter++
                if self.startCounter > 1
                {
                    self.automaticallyScrollsToMostRecentMessage = false
                }
                self.finishReceivingMessage()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "backButton") //Use a selector
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButton()
    {
        chatLoadTimer.invalidate()
        println("Popped Stuff")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        chatLoadTimer = NSTimer(timeInterval: 6.0, target: self, selector: "reloadChatTable", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(chatLoadTimer, forMode: NSRunLoopCommonModes)
    }
    /*
    func avatarLetters(username: String) -> String! {
        let nsstring = username as NSString
        return nsstring.substringToIndex(2)
    }*/
    
    func avatarLetters(username: String) -> String! {
        if username == "Me"
        {
            return "Me"
        }
        else
        {
            return "Bud"
        }
    }
    // MARK: JSQMessagesCollectionViewDataSource
    
    func sender() -> String! {
        return "Me"
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    //Just Like Table View Version
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        var message = self.messages[indexPath.item]
        if message.sender() == "Me" {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        var message = self.messages[indexPath.item]
        
        if message.sender() == "System" {
            return UIImageView(image: self.systemBubbleImageView.image, highlightedImage: self.systemBubbleImageView.highlightedImage)
        }
        
        if message.sender() == "Me" {
            return UIImageView(image: self.outgoingBubbleImageView.image, highlightedImage: self.outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: self.incomingBubbleImageView.image, highlightedImage: self.incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        var message = self.messages[indexPath.item]
        if let avatarImage = self.avatars[message.sender()] {
            return UIImageView(image: avatarImage)
        }
        
        var avatarImage = JSQMessagesAvatarFactory.avatarWithUserInitials(avatarLetters(message.sender()),
            backgroundColor: UIColor(white: CGFloat(0.85), alpha: 1),
            textColor: UIColor(white: 0.6, alpha: 1),
            font: UIFont.systemFontOfSize(14),
            diameter: UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width))
        var systemAvatar = JSQMessagesAvatarFactory.avatarWithImage(UIImage(named: "SHIP"),
            diameter: UInt(self.collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        self.avatars[message.sender()] = avatarImage
        return UIImageView(image: avatarImage)
        //self.avatars[message.sender()] = systemAvatar
        //return UIImageView(image: systemAvatar)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = self.messages[indexPath.item]
        
        if message.sender() == "Me" {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            var previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.sender() == message.sender() {
                return nil
            }
        }
        
        return NSAttributedString(string: message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    //Add My Send Code Here
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        //self.socket?.emit("newMessage", message: text)
        sendChatToServer(text)
        let pushQuery = PFInstallation.query()
        let insideQuery = PFUser.query()
        insideQuery.whereKey("objectId", equalTo: self.friendId)
        pushQuery.whereKey("userId", matchesQuery: insideQuery)
        let push = PFPush()
        push.setQuery(pushQuery)
        //push.setMessage(temp)
        var details = Dictionary<String, String>()
        details["pushType"] = "Chat"
        details["matchId"] = matchId
        details["alert"] = text
        details["sound"] = "MealChat.wav"
        push.setData(details)
        push.sendPushInBackground()
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        var message = JSQMessage(text: text, sender: sender)
        self.messages.append(message)
        self.finishSendingMessage()
    }

    
    func sendChatToServer(temp:String) {

        var theChat = PFObject(className:"Chat")
        theChat["matchId"] = matchId
        theChat["text"] = temp
        theChat["Sender"] = userId
        theChat["Receiver"] = friendId
        theChat.saveInBackgroundWithBlock {
            
            (success: Bool!, error: NSError!) -> Void in
            
            if (success != nil) {
                
                NSLog("Object created with id: \(theChat.objectId)")
                self.reloadChatTable()
            } else {
                
                NSLog("%@", error)
                
            }
            
        }
        
    }
    
    // MARK: JSQMessagesCollectionViewFlowLayout
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var currentMessage = self.messages[indexPath.item]
        if currentMessage.sender() == "Me" {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            var previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.sender() == currentMessage.sender() {
                return 0;
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func viewDidDisappear(animated: Bool) {
        chatLoadTimer.invalidate()
    }
    

    func getFriendUserId()
    {
        let query = PFQuery(className: "Matches")
        var user1:AnyObject = ""
        var user2:AnyObject = ""
        query.whereKey("objectId", equalTo: matchId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                for temp in objects {
                    user1 = temp.objectForKey("user1Id") as PFUser
                    user2 = temp.objectForKey("user2Id") as PFUser
                    println(user1.objectId)
                    println(user2.objectId)
                }
            }
            if user1.objectId == self.userId {self.friendId = user2.objectId} else { self.friendId = user1.objectId }
        }
    }
}
