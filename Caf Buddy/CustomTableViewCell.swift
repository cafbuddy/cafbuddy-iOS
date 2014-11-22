//
//  CustomTableViewCell.swift
//  CafMate
//
//  Created by Andrew Turnblad on 11/8/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import Foundation

import UIKit

class CustomTableViewCell: UITableViewCell {
    var whichMeal = UILabel()
    var timeRange = UILabel()
    var mealTime = UILabel()
    var isMatched = UILabel()
    
    func loadItem(theMeal: String, rangeOfTIme: String, timeOfMeal: String, matching: String) {
        whichMeal.text = theMeal
        whichMeal.font = UIFont.systemFontOfSize(22)
        whichMeal.textAlignment = NSTextAlignment.Center
        whichMeal.frame = CGRectMake(0, 0, contentView.frame.size.width, 50)
        
        timeRange.text = rangeOfTIme
        timeRange.textAlignment = NSTextAlignment.Center
        timeRange.font = UIFont.systemFontOfSize(20)
        timeRange.frame = CGRectMake(0, whichMeal.frame.size.height + whichMeal.frame.origin.y + 5, contentView.frame.size.width, 30)
        
        mealTime.text = timeOfMeal
        //mealTime.frame = CGRectMake(15, self.frame.height+100, 100, 15)
        mealTime.textAlignment = NSTextAlignment.Center
        mealTime.font = UIFont.systemFontOfSize(20)
        mealTime.frame = CGRectMake(0, whichMeal.frame.size.height + whichMeal.frame.origin.y + 5, contentView.frame.size.width, 30)
        
        isMatched.text = "\(matching)..."
        isMatched.textAlignment = NSTextAlignment.Center
        isMatched.font = UIFont(name: "Helvetica-Bold", size: 18)
        isMatched.frame = CGRectMake(0, timeRange.frame.size.height + timeRange.frame.origin.y + 15, contentView.frame.size.width, 30)
        
        
        contentView.addSubview(whichMeal)
        contentView.addSubview(timeRange)
        contentView.addSubview(mealTime)
        contentView.addSubview(isMatched)
    }

    //override func awakeFromNib() {
       // super.awakeFromNib()
        /*
        whichMeal.setTranslatesAutoresizingMaskIntoConstraints(false)
        timeRange.setTranslatesAutoresizingMaskIntoConstraints(false)
        mealTime.setTranslatesAutoresizingMaskIntoConstraints(false)
        isMatched.setTranslatesAutoresizingMaskIntoConstraints(false)
*/
    
        /*
        self.contentView.addSubview(whichMeal)
        contentView.addSubview(timeRange)
        contentView.addSubview(mealTime)
        contentView.addSubview(isMatched)
        
        var viewsDict = ["meal" : whichMeal, "availableTime" : timeRange, "time" : mealTime, "match" : isMatched]
        
        //whichMeal.frame = CGRectMake(10, self.frame.height-10, 40, 15)
        
        timeRange.frame = CGRectMake(10, self.frame.height-30, 40, 15)
        mealTime.frame = CGRectMake(10, self.frame.height-30, 40, 15)
        isMatched.frame = CGRectMake(self.frame.width-50, self.frame.height-30, 40, 15)*/
        
        /*contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[match]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[meal]-[availableTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[meal]-[time]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[meal]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[availableTime]-[match]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[time]-[match]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))*/
   // }
}