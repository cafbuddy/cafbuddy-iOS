//
//  ChatViewController.swift
//  Caf Buddy
//
//  Created by Armaan Bindra2 on 11/24/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import UIKit

let messageFontSize: CGFloat = 17
let toolBarMinHeight: CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)

class ChatViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {
     let screenSize: CGRect = UIScreen.mainScreen().bounds
    let sendButton = UIButton()
    let messageTableView:UITableView!
    var tabHeight:CGFloat = 49.0
    var textFieldHeight :CGFloat = 0.0
    var textFieldWidth :CGFloat = 0.0
    var sendButtonWidth :CGFloat = 0.0
    var matchId = ""
    var friendId = ""
    var userId = ""
    var numRows = 0
    
    /*Special Vars*/
    var toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
    var textView = InputTextView(frame: CGRectZero)
    var keyboardHeight:CGFloat!
    
    override var inputAccessoryView: UIView! {
        get {
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                //        textView.placeholder = "Message"
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("Send", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendMessage", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            return toolBar
        }
    }
    
    init(myMatchId:String) {
        matchId = myMatchId
        userId = PFUser.currentUser().objectId
        println("My match ID is \(matchId)")
        super.init(nibName: nil, bundle: nil)
        messageTableView = UITableView(frame: screenSize, style: .Plain)
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
                    //println(temp.objectForKey("user1Id"))
                    //println(temp.objectForKey("user2Id"))
                    user1 = temp.objectForKey("user1Id") as PFUser
                    user2 = temp.objectForKey("user2Id") as PFUser
                    println(user1.objectId)
                    println(user2.objectId)
                }
            }
            if user1.objectId == self.userId {self.friendId = user2.objectId} else { self.friendId = user1.objectId }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfRows = messageTableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            messageTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendUserId()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadChatTable", name:ReloadChatTableNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object:nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardWillHideNotification, object:nil )
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
        messageTableView.flashScrollIndicators()
        textFieldWidth = screenSize.width - screenSize.width/4
        textFieldHeight = screenSize.height/11
        sendButtonWidth = screenSize.width/4
        println("Chat View Controller ViewDidAppear")
        let chatFont = UIFont(name: "times", size: 18)
        sendButton.frame = CGRectMake(textFieldWidth, (screenSize.height - tabHeight) - textFieldHeight, sendButtonWidth, textFieldHeight )
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.keyboardDismissMode = .Interactive
        messageTableView.estimatedRowHeight = 44
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        messageTableView.contentInset = edgeInsets
        //messageTableView.backgroundColor = colorWithHexString("#00FF00")
        messageTableView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - tabHeight)
        messageTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(messageTableView)
        //self.view.addSubview(messageField)
        //self.view.addSubview(sendButton)
        self.view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        reloadChatTable()
    }
    
    
    func reloadChatTable()
    {
        let myArray = DataModel.loadMessagesFromPlist(matchId) as NSMutableArray
        numRows = myArray.count
        self.messageTableView.reloadData()
        if numRows > 1 {
        var iPath = NSIndexPath(forRow: self.messageTableView.numberOfRowsInSection(0)-1,
            inSection: self.messageTableView.numberOfSections()-1)
        self.messageTableView.scrollToRowAtIndexPath(iPath,
            atScrollPosition: UITableViewScrollPosition.Bottom,
            animated: true)
        }
    }
    
    
    func keyboardWillShow(notification:NSNotification)
    {
      let keyboardInfo = notification.userInfo as NSDictionary?
      let keyboardFrameBegin = keyboardInfo?.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
      let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
      keyboardHeight = keyboardFrameBeginRect.size.height
       //messageField.frame = CGRectMake(0,screenSize.height-(tabHeight) - keyboardHeight - 5.0, textFieldWidth,textFieldHeight )
       //sendButton.frame = CGRectMake(textFieldWidth, (screenSize.height - tabHeight) - keyboardHeight - 5.0, sendButtonWidth, textFieldHeight )
        //messageTableView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - textFieldHeight - keyboardHeight)
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let insetNewBottom = messageTableView.convertRect(frameNew, fromView: nil).height
        let insetOld = messageTableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = messageTableView.contentSize.height - (messageTableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.messageTableView.tracking || self.messageTableView.decelerating) {
                // Move content with keyboard
                if overflow > 0 {                   // scrollable before
                    self.messageTableView.contentOffset.y += insetChange
                    if self.messageTableView.contentOffset.y < -insetOld.top {
                        self.messageTableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow { // scrollable after
                    self.messageTableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardDidShow(notification:NSNotification)
    {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let insetNewBottom = messageTableView.convertRect(frameNew, fromView: nil).height
        
        // Inset `tableView` with keyboard
        let contentOffsetY = messageTableView.contentOffset.y
        messageTableView.contentInset.bottom = insetNewBottom
        messageTableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.messageTableView.tracking || self.messageTableView.decelerating {
            messageTableView.contentOffset.y = contentOffsetY
        }
    }
    
    func textViewDidChange(textView: UITextView!) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }
    
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        var heightDifference = (newHeight+8*2-0.5) - oldHeight
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            //toolBar.frame.size.height = newHeight + 8*2 - 0.5
            //textView.frame.size.height = newHeight + 8*2 - 0.5
        }
        //moveToolbarAboveKeyboard()
    }
    
    func moveToolbarAboveKeyboard()
    {
            toolBar.frame.origin.y = screenSize.height - keyboardHeight - toolBar.frame.origin.y - toolBar.frame.height
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func keyboardDidHide(notification:NSNotification)
    {
        //messageField.frame = CGRectMake(0 , (screenSize.height - tabHeight) - textFieldHeight , textFieldWidth, textFieldHeight)
        //sendButton.frame = CGRectMake(textFieldWidth, (screenSize.height - tabHeight) - textFieldHeight, sendButtonWidth, textFieldHeight )
        //messageTableView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - textFieldHeight)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func sendMessage()
    {
        
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
        var temp = textView.text
        DataModel.addMessageToPlist("me", message: temp, matchId: matchId)
        textView.text = ""
        updateTextViewHeight()
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
        details["alert"] = temp
        details["sound"] = "MealChat.wav"
        push.setData(details)
        push.sendPushInBackground()
        reloadChatTable()
        tableViewScrollToBottomAnimated(true)
    }
    
    //All Table View Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "chatCell")
        var incoming = true
        let cell = MessageBubbleCell(style: .Default, reuseIdentifier: "chatCell")
        let myArray = DataModel.loadMessagesFromPlist(matchId) as NSMutableArray
        let thisItem = myArray.objectAtIndex(indexPath.row) as NSDictionary
        /*cell.textLabel.text = thisItem.objectForKey("Message") as? String
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        */
        if thisItem.objectForKey("User") as String == "me"
        {
            //cell.backgroundColor = colorWithHexString("#2980b9")
            incoming = false
        }
        else
        {
            //cell.backgroundColor = colorWithHexString("#e74c3c")
        }

        // Add gesture recognizers #CopyMessage
        //let action: Selector = "messageShowMenuAction:"
        //let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        //doubleTapGestureRecognizer.numberOfTapsRequired = 2
        //cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
        //cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
        let message = thisItem.objectForKey("Message") as? String
        cell.configureWithMessage(message!,incoming: incoming)
        return cell
    }
    
    func messageCopyTextAction(menuController: UIMenuController) {
        let selectedIndexPath = messageTableView.indexPathForSelectedRow()
        let myArray = DataModel.loadMessagesFromPlist(matchId) as NSMutableArray
        let thisItem = myArray.objectAtIndex(selectedIndexPath!.row-1) as NSDictionary
        let selectedMessage = thisItem.objectForKey("Message") as? String
        UIPasteboard.generalPasteboard().string = selectedMessage
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
            textViewDidChange(textView)
            textView.becomeFirstResponder()
    }
}

class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if (delegate as ChatViewController).messageTableView.indexPathForSelectedRow() != nil {
            return action == "messageCopyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    // More specific than implementing `nextResponder` to return `delegate`, which might cause side effects?
    func messageCopyTextAction(menuController: UIMenuController) {
        (delegate as ChatViewController).messageCopyTextAction(menuController)
    }
}