//
//  collectionViewHeader.swift
//  Caf Buddy
//
//  Created by Jacob Forster on 3/1/15.
//  Copyright (c) 2015 St. Olaf Acm. All rights reserved.
//

import Foundation

class MealListingHeader : UICollectionReusableView {
    
    var headerTitle = UILabel()
    var rightLine = UIView()
    var leftLine = UIView()

    func setTitle(title: String, sectionIndex : Int) {

        headerTitle.text = title
        headerTitle.font = UIFont.boldSystemFontOfSize(22)
        headerTitle.textColor = colorWithHexString(COLOR_DARKER_BLUE)
        headerTitle.textAlignment = NSTextAlignment.Center
        
        var offset : Int = 0
        if (sectionIndex == 0) {
            offset = 5
        }
        
        headerTitle.frame = CGRectMake(0, CGFloat(offset), self.frame.size.width, 40)
        
        offset = 0
        if (sectionIndex == 1) {
            offset = 5
        }
        
        rightLine.frame = CGRectMake(10, 25 - CGFloat(offset), (self.frame.size.width / 2) - 70, 2)
        rightLine.backgroundColor = colorWithHexString(COLOR_DARKER_BLUE)
        leftLine.frame = CGRectMake(self.frame.size.width - (self.frame.size.width / 2) + 60, 25 - CGFloat(offset), (self.frame.size.width / 2) - 70, 2)
        leftLine.backgroundColor = colorWithHexString(COLOR_DARKER_BLUE)
        
        self.addSubview(rightLine)
        self.addSubview(leftLine)
        
        self.addSubview(headerTitle)
    
    }

}