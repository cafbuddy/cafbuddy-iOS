//
//  Utilities.swift
//  CafMate
//
//  Created by Jacob Forster on 11/8/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import Foundation
import UIKit

let COLOR_MAIN_BACKGROUND_OFFWHITE = "#eaeaea"
let COLOR_ACCENT_BLUE = "#0EDBEC"

let NAV_BAR_HEIGHT = 44
let STATUS_BAR_HEIGHT = 20
let KEYBOARD_HEIGHT = 216
let TOOLBAR_KEYBOARD_HEIGHT = 35

let BUTTON_WIDTH = 300

func convertFromLocalToUTCTime(targetDate: NSDate) ->NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // superset of OP's format
    let str = dateFormatter.stringFromDate(targetDate)
    //let str = "2012-12-17 01:00:25";
    
    let utcDf:NSDateFormatter  = NSDateFormatter()
    //[gmtDf setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    utcDf.timeZone = NSTimeZone(name: "UTC")
    utcDf.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    let utcDate = utcDf.dateFromString(str)
    return utcDate!
}


func colorWithHexString (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (countElements(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rString = (cString as NSString).substringToIndex(2)
    var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func showAlert(title:String,message:String)
{
    let alert = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButtonWithTitle("Cancel")
    alert.show()
}
