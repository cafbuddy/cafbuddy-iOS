//
//  MealListingCell.swift
//  Caf Buddy
//
//  Created by Jacob Forster on 2/26/15.
//  Copyright (c) 2015 St. Olaf Acm. All rights reserved.
//

import Foundation
import UIkit

enum MealType {
    case Dinner
    case Lunch
    case Breakfast
}

enum MealStatus {
    case Confirmed
    case Pending
}


class MealListingCell : UICollectionViewCell {
    
    var labelMealType = UILabel()
    var imageMealType = UIImageView()
    var buttonChatAndStatus = UIButton()
    var buttonAddCalendar = UIButton()
    var buttonSearching = UIButton()
    var labelMealDate = UILabel()
    var labelMealTime = UILabel()
    
    //initializes everything in the cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorderDecoration()
        intializeCellContents()
        
    }
    
    //just needed to initialize the parent cell
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    
    }
    
    func setBorderDecoration() {
        
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(0, 0)
        
    }
    
    func intializeCellContents() {
        
        imageMealType.frame = CGRectMake(15, 10, 32, 32)
        
        var endOfImage = imageMealType.frame.origin.x + imageMealType.frame.width
        labelMealType.font = UIFont.systemFontOfSize(22)
        labelMealType.textAlignment = NSTextAlignment.Center
        //labelMealType.textColor = colorWithHexString()
        labelMealType.frame = CGRectMake(0, 17.5, contentView.frame.size.width, 20)
        
        
        var buttonHeight : CGFloat = 40
        buttonChatAndStatus.frame = CGRectMake(self.contentView.frame.width/2, self.contentView.frame.height - buttonHeight, self.contentView.frame.width/2, buttonHeight)
        buttonChatAndStatus.layer.cornerRadius = 3.0
        buttonChatAndStatus.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_UNPRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Normal)
        buttonChatAndStatus.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_PRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Highlighted)
        buttonChatAndStatus.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_PRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Selected)
        buttonChatAndStatus.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 25)
        buttonChatAndStatus.setTitleColor(colorWithHexString(COLOR_ACCENT_GREEN), forState: UIControlState.Normal)
        buttonChatAndStatus.titleLabel?.font = UIFont.systemFontOfSize(13)
        //CGRectMake(<#x: CGFloat#>, <#y: CGFloat#>, <#width: CGFloat#>, <#height: CGFloat#>)
        var leftBorder : UIView = UIView(frame: CGRectMake(1, 0, 1, buttonChatAndStatus.frame.size.height))
        leftBorder.backgroundColor = colorWithHexString(COLOR_BUTTON_PRESSED_GRAY)
        buttonChatAndStatus.addSubview(leftBorder)
        
        
        buttonAddCalendar.frame = CGRectMake(0, self.contentView.frame.height - buttonHeight, self.contentView.frame.width/2, buttonHeight)
        buttonAddCalendar.layer.cornerRadius = 3.0
        //buttonChatAndStatus.backgroundColor = colorWithHexString(COLOR_BUTTON_UNPRESSED_GRAY)
        buttonAddCalendar.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_UNPRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Normal)
        buttonAddCalendar.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_PRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Highlighted)
        buttonAddCalendar.setBackgroundImage(getImageWithColor(colorWithHexString(COLOR_BUTTON_PRESSED_GRAY), CGSizeMake(self.contentView.frame.width, buttonHeight)), forState: UIControlState.Selected)
        buttonAddCalendar.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 25)
        buttonAddCalendar.setTitleColor(colorWithHexString(COLOR_ACCENT_GREEN), forState: UIControlState.Normal)
        buttonAddCalendar.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        var rightBorder : UIView = UIView(frame: CGRectMake(buttonAddCalendar.frame.size.width, 0, 1, buttonAddCalendar.frame.size.height))
        rightBorder.backgroundColor = colorWithHexString(COLOR_BUTTON_PRESSED_GRAY)
        buttonAddCalendar.addSubview(rightBorder)
        
        
        buttonSearching.frame = CGRectMake(0, self.contentView.frame.height - buttonHeight, self.contentView.frame.width, buttonHeight)
        buttonSearching.layer.cornerRadius = 3.0
        buttonSearching.backgroundColor = colorWithHexString(COLOR_BUTTON_UNPRESSED_GRAY)
        buttonSearching.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25)
        buttonSearching.setTitleColor(colorWithHexString(COLOR_ACCENT_GREEN), forState: UIControlState.Normal)
        buttonSearching.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        labelMealDate.font = UIFont.systemFontOfSize(15)
        labelMealDate.textAlignment = NSTextAlignment.Center
        //labelMealType.textColor = colorWithHexString()
        labelMealDate.frame = CGRectMake(0, labelMealType.frame.origin.y + labelMealType.frame.height + 10, contentView.frame.size.width, 20)
        
        labelMealTime.font = UIFont.systemFontOfSize(15)
        labelMealTime.textAlignment = NSTextAlignment.Center
        //labelMealType.textColor = colorWithHexString()
        labelMealTime.frame = CGRectMake(0, labelMealDate.frame.origin.y + labelMealDate.frame.height + 5, contentView.frame.size.width, 20)
        
        
        self.contentView.addSubview(labelMealType)
        self.contentView.addSubview(imageMealType)
        self.contentView.addSubview(buttonChatAndStatus)
        self.contentView.addSubview(buttonAddCalendar)
        self.contentView.addSubview(buttonSearching)
        self.contentView.addSubview(labelMealDate)
        self.contentView.addSubview(labelMealTime)
        
    }
    
    func setMealDetails(theMealType : MealType, theMealStatus : MealStatus) {
        
        
        //for the times can do something like.. just words below - but in smaller font...
        //Wednesday at 3:00 PM
        //Thursday, March 30th Between 3:00 PM and 4:15 PM
        
        //we need to add an add to calendar button next to the chat with buddy button!!!!!! Perfect!!!!
        
        if (theMealType == MealType.Dinner) {
            labelMealType.text = "Dinner";
            imageMealType.image = filledImageFrom(UIImage(named: "steak")!, colorWithHexString(COLOR_DARKER_BLUE))
        }
        else if (theMealType == MealType.Lunch){
            labelMealType.text = "Lunch"
            imageMealType.image = filledImageFrom(UIImage(named: "apple")!, colorWithHexString(COLOR_DARKER_BLUE))
        }
        else {
            labelMealType.text = "Breakfast"
            imageMealType.image = filledImageFrom(UIImage(named: "toast")!, colorWithHexString(COLOR_DARKER_BLUE))
        }
        
        if (theMealStatus == MealStatus.Confirmed) {
            
            buttonSearching.hidden = true
            buttonChatAndStatus.hidden = false
            buttonAddCalendar.hidden = false
            
            buttonChatAndStatus.setTitle("Chat W/ Buddy", forState: UIControlState.Normal)
            buttonChatAndStatus.setImage(filledImageFrom(UIImage(named: "chat2")!, colorWithHexString(COLOR_ACCENT_GREEN)), forState: UIControlState.Normal)
            buttonChatAndStatus.enabled = true
            
            buttonAddCalendar.setTitle("Add To Calendar", forState: UIControlState.Normal)
            buttonAddCalendar.setImage(filledImageFrom(UIImage(named: "addCal")!, colorWithHexString(COLOR_ACCENT_GREEN)), forState: UIControlState.Normal)
            buttonAddCalendar.enabled = true
        }
        else {
            
            buttonChatAndStatus.hidden = true
            buttonAddCalendar.hidden = true
            buttonSearching.hidden = false
            
            buttonSearching.setTitle("Searching For A Buddy...", forState: UIControlState.Normal)
            buttonSearching.setImage(filledImageFrom(UIImage(named: "buddy")!, colorWithHexString(COLOR_ACCENT_GREEN)), forState: UIControlState.Normal)
            buttonSearching.enabled = false
        }
        
        labelMealDate.text = "Wednesday, September 2nd"
        labelMealTime.text = "At 3:30 PM"
    }
    
    
    
}