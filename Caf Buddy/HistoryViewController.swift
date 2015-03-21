//
//  HistoryViewController.swift
//  Caf Buddy
//
//  Created by Lydia Narum on 3/20/15.
//  Copyright (c) 2015 St. Olaf Acm. All rights reserved.
//

/*import Foundation

class HistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    class LogInViewController: UIViewController,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        var collectionViewMain : UICollectionView?
        var pastMeal_date = 
        var showChatScreen = false
        var chatScreenMatchId = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            println("View Did Load")
            startMealScreen()
            
        }

    
    func initInterface() {
        var screenWidth = Float(self.view.frame.size.width)
        var screenHeight = Float(self.view.frame.size.height)
        
        let collectionViewLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        collectionViewLayout.itemSize = CGSizeMake(screenSize.width - 30, 150)
        collectionViewLayout.headerReferenceSize = CGSizeMake(screenSize.width, 40)
        
        collectionViewMain = UICollectionView(frame: CGRectMake(0, CGFloat(NAV_BAR_HEIGHT) + CGFloat(STATUS_BAR_HEIGHT), screenSize.width, screenSize.height - (CGFloat(NAV_BAR_HEIGHT) + CGFloat(STATUS_BAR_HEIGHT) + CGFloat(TAB_BAR_HEIGHT))), collectionViewLayout: collectionViewLayout)
        
        collectionViewMain!.delegate = self;
        collectionViewMain!.dataSource = self;
        collectionViewMain!.alwaysBounceVertical = true
        collectionViewMain!.registerClass(MealListingCell.self, forCellWithReuseIdentifier: "mealCell")
        collectionViewMain!.registerClass(MealListingHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionViewMain!.backgroundColor = colorWithHexString(COLOR_MAIN_BACKGROUND_OFFWHITE)
        
        self.view.addSubview(collectionViewMain!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let mealCell = collectionViewMain!.dequeueReusableCellWithReuseIdentifier("mealCell", forIndexPath: indexPath) as MealListingCell
        mealCell.backgroundColor = UIColor.whiteColor()
        
        var theMealStatus = MealStatus.Confirmed
        if (indexPath.section == 1) {
            theMealStatus = MealStatus.Pending
        }
        if (indexPath.item%3 == 0) {
            mealCell.setMealDetails(MealType.Breakfast, theMealStatus : theMealStatus)
        }
        else if (indexPath.item%3 == 1) {
            mealCell.setMealDetails(MealType.Lunch, theMealStatus : theMealStatus)
        }
        else {
            mealCell.setMealDetails(MealType.Dinner, theMealStatus : theMealStatus)
        }
        
        mealCell.buttonChatAndStatus.addTarget(self, action: "chatButtonWasPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return mealCell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    
};*/