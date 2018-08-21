//
//  ValueSliderCell.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ValueSliderCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var valueIdentifer: AnyObject = "" as AnyObject
    weak var delegate: ValueSliderCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ labelText: String, valueMinimum: Float, valueMaximum: Float) {
        label.text = labelText
        slider.minimumValue = valueMinimum
        slider.maximumValue = valueMaximum
    }
    
    @IBAction func valueDidChange(_ sender: AnyObject) {
        
        delegate?.sliderValueDidChange(self, valueIdentifier: valueIdentifer, newValue: slider.value)
    }
}
