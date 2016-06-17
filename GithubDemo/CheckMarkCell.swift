//
//  CheckMarkCell.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CheckMarkCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var switchIdentifier: AnyObject = ""
    var isChecked: Bool = false
        {
        didSet {
            if isChecked {
                self.accessoryType = .Checkmark
            } else {
                self.accessoryType = .None
            }
        }
    }
    var key: String = ""
    weak var delegate: ToggleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Sets the selected state of the cell, optionally animating the transition between states.
    override func setSelected(selected: Bool, animated: Bool) {
        
        if selected && !self.selected {
            super.setSelected(true, animated: true)
            isChecked = !isChecked
            delegate?.toggleCellDidToggle(self, toggleIdenfifier: switchIdentifier, newValue: isChecked)
            super.setSelected(false, animated: true)
        }
    }
}
