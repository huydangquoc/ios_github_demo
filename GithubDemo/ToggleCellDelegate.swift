//
//  ToggleCellDelegate.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

protocol ToggleCellDelegate: class {
    
    func toggleCellDidToggle(_ cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool)
}
