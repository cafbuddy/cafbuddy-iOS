//
//  SpecialTextField.swift
//  Caf Buddy
//
//  Created by Armaan Bindra2 on 11/15/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import UIKit

class SpecialTextField:UITextField{
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero;
    }
}
