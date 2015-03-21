//
//  Utilities.swift
//  CafMate
//
//  Created by Jacob Forster on 11/8/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import Foundation
import UIKit

let COLOR_MAIN_BACKGROUND_OFFWHITE = "#eaeaea" //"#0dc5d4" "#eaeaea"   #468499
let COLOR_ACCENT_BLUE = "#0EDBEC"//"#1FB1C3"//
let COLOR_DARKER_BLUE = "#1FB1C3"
let COLOR_ACCENT_GREEN = "#0eec8e" //"#0dd480" //"#0eec8e" //0cd47f
let COLOR_ACCENT_GREEN_DARKER = "#0dd480"
let COLOR_BUTTON_UNPRESSED_GRAY = "#f4f4f4"
let COLOR_BUTTON_PRESSED_GRAY = "#f0f0f0"
let COLOR_COOL_GREY = "#B8B8B8"

let NAV_BAR_HEIGHT = 44
let STATUS_BAR_HEIGHT = 20
let TAB_BAR_HEIGHT = 49
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

func filledImageFrom(source : UIImage, color : UIColor) -> UIImage {
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, false, UIScreen.mainScreen().scale)
    
    // get a reference to that context we created
    var context : CGContextRef = UIGraphicsGetCurrentContext()
    
    // set the fill color
    color.setFill()
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    var rect : CGRect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    var coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}


func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    var rect = CGRectMake(0, 0, size.width, size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

/*FACTOR THIS INTO SWIFT AND USE TO ROUND THE CORNERS!!!!
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
        cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}*/

func showAlert(title:String,message:String)
{
    let alert = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButtonWithTitle("Cancel")
    alert.show()
}
