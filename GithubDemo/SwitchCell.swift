//
//  SwitchCell.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    var switchIdentifier: AnyObject = "" as AnyObject
    weak var delegate: ToggleCellDelegate?
    
    @IBAction func didToggleSwitch(_ sender: AnyObject) {
        delegate?.toggleCellDidToggle(self, toggleIdenfifier: switchIdentifier, newValue: onOffSwitch.isOn)
    }
    
}
