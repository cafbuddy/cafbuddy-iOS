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
        buttonChatAndStatus.frame = CGRectMake(0, self.contentView.frame.height - buttonHeight, self.contentView.frame.width, buttonHeight)
        buttonChatAndStatus.layer.cornerRadius = 3.0
        buttonChatAndStatus.backgroundColor = colorWithHexString(COLOR_GRAY)
        buttonChatAndStatus.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25)
        buttonChatAndStatus.setTitleColor(colorWithHexString(COLOR_ACCENT_GREEN), forState: UIControlState.Normal)
        
        
        self.contentView.addSubview(labelMealType)
        self.contentView.addSubview(imageMealType)
        self.contentView.addSubview(buttonChatAndStatus)
        
    }
    
    func setMealDetails(theMealType : MealType, theMealStatus : MealStatus) {
        
        
        //for the times can do something like.. just words below - but in smaller font...
        //Wednesday at 3:00 PM
        //Thursday, March 30th Between 3:00 PM and 4:15 PM
        
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
            imageMealType.image = filledImageFrom(UIImage(named: "hot51")!, colorWithHexString(COLOR_DARKER_BLUE))
        }
        
        if (theMealStatus == MealStatus.Confirmed) {
            buttonChatAndStatus.setTitle("Chat With Buddy", forState: UIControlState.Normal)
            buttonChatAndStatus.setImage(filledImageFrom(UIImage(named: "chat")!, colorWithHexString(COLOR_ACCENT_GREEN)), forState: UIControlState.Normal)
            buttonChatAndStatus.enabled = true
        }
        else {
            buttonChatAndStatus.setTitle("Searching For A Buddy...", forState: UIControlState.Normal)
            buttonChatAndStatus.setImage(filledImageFrom(UIImage(named: "buddy")!, colorWithHexString(COLOR_ACCENT_GREEN)), forState: UIControlState.Normal)
            buttonChatAndStatus.enabled = false
        }
    }
    
    
    
}