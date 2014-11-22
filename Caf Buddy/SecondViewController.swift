//
//  SecondViewController.swift
//  CafMate
//
//  Created by Jacob Forster on 11/8/14.
//  Copyright (c) 2014 St. Olaf ACM. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    let statusBarHeight = 20;
    
    let mealTypesArr = ["Breakfast","Lunch","Dinner"]
    let mealStartEndTimes = [["7:00","10:15"],["10:30","14:00"],["16:30","19:30"]]
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var mealTypeLabel = UILabel()
    var mealTypeTextField = SpecialTextField()
    var mealTypePickerView = UIPickerView()
    
    var mealTimeLabel = UILabel()
    var mealTimeTextField = SpecialTextField()
    var mealTimePickerView = UIPickerView()
    
    var scrollViewMain = UIScrollView()
    
    var buttonCreateMeal = UIButton()
    
    var timeRangeDates = NSMutableArray()
    var chosenStartTime :NSDate? = nil
    var chosenEndTime :NSDate? = nil
    var chosenMealType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = colorWithHexString(COLOR_ACCENT_BLUE)
        navigationItem.title = "Find New Buddy"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "adjustLayoutForOpeningKeyboard:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "adjustLayoutForClosingKeyboard:", name: UIKeyboardDidHideNotification, object: nil)
        
        initInterface();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func initInterface() {
        var labelWidth = 325;
        
        self.view.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        
        scrollViewMain.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        scrollViewMain.showsVerticalScrollIndicator = true
        scrollViewMain.showsHorizontalScrollIndicator = false
        scrollViewMain.userInteractionEnabled = true
        
        
        mealTypeLabel.text = "What meal do you want a buddy at?"
        mealTypeLabel.font = UIFont.systemFontOfSize(18)
        mealTypeLabel.numberOfLines = 0;
        mealTypeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
       
        mealTypeLabel.textAlignment = NSTextAlignment.Center
        mealTypeLabel.frame = CGRectMake((screenSize.width - CGFloat(labelWidth))/2, 15, CGFloat(labelWidth), 30)
        
        
        mealTypePickerView.delegate = self
        mealTypePickerView.dataSource = self
        
        
        var textFieldWidth :CGFloat = 300
        mealTypeTextField.delegate = self
        //mealTypeTextField.enabled = false
        mealTypeTextField.frame = CGRectMake((screenSize.width-textFieldWidth)/2, mealTypeLabel.frame.origin.y + mealTypeLabel.frame.size.height + 5, textFieldWidth, 50)
        mealTypeTextField.backgroundColor = UIColor.whiteColor()
        mealTypeTextField.inputView = mealTypePickerView
        mealTypeTextField.layer.cornerRadius = 3.0
        mealTypeTextField.font = UIFont.systemFontOfSize(18)
        mealTypeTextField.textAlignment = NSTextAlignment.Center
        mealTypeTextField.text = mealTypesArr[0]
        
        
        var toolbarMealType = UIToolbar(frame: CGRectMake(0, 0, screenSize.width, CGFloat(TOOLBAR_KEYBOARD_HEIGHT)))
        toolbarMealType.items = NSArray(array: [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action:"closeInput"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Bordered, target: self, action:"advanceToTimeInput")])
        self.mealTypeTextField.inputAccessoryView = toolbarMealType
        
        
        mealTimeLabel.text = "When are you available?"
        mealTimeLabel.font = UIFont.systemFontOfSize(18)
        mealTimeLabel.frame = CGRectMake((screenSize.width - CGFloat(labelWidth))/2, CGFloat(mealTypeTextField.frame.size.height + mealTypeTextField.frame.origin.y + 20), CGFloat(labelWidth), 30)
        mealTimeLabel.textAlignment = NSTextAlignment.Center
        
        mealTimePickerView.delegate = self
        mealTimePickerView.dataSource = self
        getPickerOptions(0)
        mealTimePickerView.reloadAllComponents()
        
        
        mealTimeTextField.frame = CGRectMake((screenSize.width - textFieldWidth)/2, mealTimeLabel.frame.origin.y + mealTimeLabel.frame.size.height + 5, textFieldWidth, 50)
        mealTimeTextField.backgroundColor = UIColor.whiteColor()
        mealTimeTextField.inputView = mealTimePickerView
        
        mealTimeTextField.layer.cornerRadius = 3.0
        mealTimeTextField.font = UIFont.systemFontOfSize(18)
        mealTimeTextField.textAlignment = NSTextAlignment.Center
        mealTimeTextField.placeholder = "Choose A Time Range"
        
        var toolbarMealTime = UIToolbar(frame: CGRectMake(0, 0, screenSize.width, CGFloat(TOOLBAR_KEYBOARD_HEIGHT)))
        toolbarMealTime.items = NSArray(array: [UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.Bordered, target: self, action:"goBackToPreviousInput"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action:"closeInput")])
        self.mealTimeTextField.inputAccessoryView = toolbarMealTime
        
        buttonCreateMeal.titleForState(UIControlState.Normal)
        buttonCreateMeal.setTitle("Lets Eat", forState: UIControlState.Normal)
        buttonCreateMeal.frame = CGRectMake((screenSize.width - textFieldWidth)/2, mealTimeTextField.frame.size.height + mealTimeTextField.frame.origin.y + 40, textFieldWidth, 60)
        buttonCreateMeal.titleLabel?.font = UIFont.systemFontOfSize(20)
        buttonCreateMeal.backgroundColor = colorWithHexString(COLOR_ACCENT_BLUE)
        buttonCreateMeal.layer.cornerRadius = 3.0
        buttonCreateMeal.addTarget(self, action: "sendMealToServer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollViewMain.contentSize = CGSizeMake(screenSize.width, buttonCreateMeal.frame.size.height + buttonCreateMeal.frame.origin.y - CGFloat(NAV_BAR_HEIGHT))
        self.view.addSubview(scrollViewMain)
        
        scrollViewMain.addSubview(mealTypeLabel)
        scrollViewMain.addSubview(mealTypeTextField)
        scrollViewMain.addSubview(mealTimeLabel)
        scrollViewMain.addSubview(mealTimeTextField)
        scrollViewMain.addSubview(buttonCreateMeal)
        
        updateInterface()
    }
    

    
    func updateInterface() {
        
    }
    
    
    func closeInput() {
        if (mealTimeTextField.isFirstResponder()) {
            mealTimeTextField.resignFirstResponder()
        }
        if (mealTypeTextField.isFirstResponder()) {
            mealTypeTextField.resignFirstResponder()
        }
    }
    
    func goBackToPreviousInput() {
        if (mealTimeTextField.isFirstResponder()) {
            mealTimeTextField.resignFirstResponder()
            mealTypeTextField.becomeFirstResponder()
        }
    }
    
    func advanceToTimeInput() {
        if (mealTypeTextField.isFirstResponder()) {
            mealTypeTextField.resignFirstResponder()
            mealTimeTextField.becomeFirstResponder()
        }
    }
    
    func adjustLayoutForOpeningKeyboard(notifcation: NSNotification) {
        scrollViewMain.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - CGFloat(KEYBOARD_HEIGHT) - CGFloat(TOOLBAR_KEYBOARD_HEIGHT))
    }
    
    func adjustLayoutForClosingKeyboard(notifcation: NSNotification) {
        scrollViewMain.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == mealTypePickerView) {
            return 1
        }
        return 2;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == mealTypePickerView) {
            return 3
        }
        return timeRangeDates.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == mealTypePickerView) {
            return mealTypesArr[row]
        }
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        let time = timeRangeDates[row] as? NSDate
        return formatter.stringFromDate(time!)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == mealTypePickerView) {
            chosenMealType = row
            mealTypeTextField.text = mealTypesArr[row]
            getPickerOptions(row)
            mealTimePickerView.reloadAllComponents()
            mealTimeTextField.text = ""
            chosenStartTime = nil
            chosenEndTime = nil
            mealTimePickerView.selectRow(0, inComponent: 0, animated: false)
            mealTimePickerView.selectRow(0, inComponent: 1, animated: false)
        }
        else {
            
            let time = timeRangeDates[row] as? NSDate
            var theTime = time
            
            if (component == 0) {
                chosenStartTime = theTime
                if (chosenEndTime == nil || !chosenTimeRangeIsValid()) {
                    chosenEndTime = theTime
                    mealTimePickerView.selectRow(row, inComponent: 1, animated: true)
                }
            }
            else {
                chosenEndTime = theTime
                if (chosenStartTime == nil || !chosenTimeRangeIsValid()) {
                    chosenStartTime = theTime
                    mealTimePickerView.selectRow(row, inComponent: 0, animated: true)
                }
            }
            displayTimeRange()
        }
    }
    
    func chosenTimeRangeIsValid() -> Bool {
        return chosenStartTime!.compare(chosenEndTime!) != NSComparisonResult.OrderedDescending
        
    }
    
    func displayTimeRange() {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        var theString = "\(formatter.stringFromDate(chosenStartTime!)) - \(formatter.stringFromDate(chosenEndTime!))"
        mealTimeTextField.text = theString
    }
    
    func getPickerOptions(mealType: Int) {        
        //var stringLength = countElements(mealStartEndTimes[mealType][0])
        var stringStart = mealStartEndTimes[mealType][0]
        //stringStart = stringStart.substringToIndex(advance(stringStart.startIndex, stringLength-3))
        var startTime = getCurDateTime(stringStart)
        
        //stringLength = countElements(mealStartEndTimes[mealType][1])
        var stringEnd = mealStartEndTimes[mealType][1]
        //stringEnd = stringEnd.substringToIndex(advance(stringEnd.startIndex, stringLength-3))
        var endTime = getCurDateTime(stringEnd)
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        timeRangeDates = NSMutableArray()
        var nextTime = startTime
        for nextTime ; nextTime.compare(endTime) != NSComparisonResult.OrderedDescending ; nextTime = nextTime.dateByAddingTimeInterval(15*60) {
            timeRangeDates.addObject(nextTime)
            
        }
    }
    
    func getCurDateTime(theTime: String) -> NSDate {
        var now = NSDate()
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var timeArr = theTime.componentsSeparatedByString(":")
        NSLog(timeArr[0])
        var components = calendar?.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: now)
        components?.hour = timeArr[0].toInt()!
        components?.minute = timeArr[1].toInt()!
        var curDate = calendar?.dateFromComponents(components!)
        return curDate!
        
    }
    
    func sendMealToServer(sender:UIButton!) {
        
        //this works because chosen start time and chosen end time are actuall found using real date object instead of the  string one since we have two arrays
        var theMeal = PFObject(className:"Meals")
        theMeal["matched"] = false
        theMeal["start"] = chosenStartTime!
        //println("ChosenStartTime is \(convertFromLocalToUTCTime(chosenStartTime!))")
        theMeal["end"] = chosenEndTime
        theMeal["type"] = chosenMealType
        theMeal["userId"] = PFUser.currentUser()
        //theMeal["userId"] = PFUser.currentUser().objectId
        theMeal.saveInBackgroundWithBlock {
            
            (success: Bool!, error: NSError!) -> Void in
            
            if (success != nil) {
                
                NSLog("Object created with id: \(theMeal.objectId)")
                
            } else {
                
                NSLog("%@", error)
                
            }
            
        }
        
        
        self.tabBarController?.selectedIndex = 0
        //var fvc = self.tabBarController?.selectedViewController as FirstViewController
        //fvc.reloadTableFromServer()
        
    }


}

