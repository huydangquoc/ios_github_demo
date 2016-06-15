//
//  ValueSliderCellDelegate.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

protocol ValueSliderCellDelegate: class {
    
    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float)
}