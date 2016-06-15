//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var settings: GithubRepoSearchSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchSettingsViewController: UITableViewDataSource {
    
    // Asks the data source to return the number of sections in the table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            if settings.shouldFilterLanguages {
                return 1 + settings.languages.count
            }
            return 1
        }
        
        return 0
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let minStarsCell = tableView.dequeueReusableCellWithIdentifier("ValueSliderCell") as! ValueSliderCell
            minStarsCell.configure("Mininum Stars", valueMinimum: 0, valueMaximum: 5000)
            minStarsCell.slider.value = Float(settings.minStars)
            minStarsCell.valueLabel.text = String(settings.minStars)
            minStarsCell.valueIdentifer = "Mininum Stars"
            minStarsCell.delegate = self
            return minStarsCell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let filterLanguagesCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                filterLanguagesCell.descriptionLabel.text = "Filter by Language"
                filterLanguagesCell.switchIdentifier = "Filter by Language"
                filterLanguagesCell.onOffSwitch.on = settings.shouldFilterLanguages
                filterLanguagesCell.delegate = self
                return filterLanguagesCell
            } else if indexPath.row <= settings.languages.count {
                let languageCell = tableView.dequeueReusableCellWithIdentifier("CheckMarkCell") as! CheckMarkCell
                languageCell.descriptionLabel.text = settings.languages[indexPath.row - 1]
                languageCell.switchIdentifier = "language:" + settings.languages[indexPath.row - 1]
                languageCell.isChecked = settings.includeLanguage[indexPath.row - 1]
                languageCell.delegate = self
                return languageCell
            }
        }
        
        return tableView.dequeueReusableCellWithIdentifier("CheckMarkCell") as! CheckMarkCell
    }
}

extension SearchSettingsViewController: ValueSliderCellDelegate {
    
    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float) {
        
        if let identifier = valueIdentifier as? String {
            if identifier == "Mininum Stars" {
                settings?.minStars = Int(newValue)
                tableView.reloadData()
            }
        }
    }
}

extension SearchSettingsViewController: ToggleCellDelegate {
    
    func toggleCellDidToggle(cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool) {
        
        if let identifier = toggleIdenfifier as? String {
            if identifier == "Filter by Language" {
                settings?.shouldFilterLanguages = newValue
                tableView.reloadData()
            } else if identifier.hasPrefix("language:") {
                // get language identifier and find its index in the array
                let index = identifier.rangeOfString("language:")?.endIndex
                let language = identifier.substringFromIndex(index!)
                let languageIndex = settings.languages.indexOf(language)
                if let languageIndex = languageIndex {
                    settings.includeLanguage[languageIndex] = newValue
                }
            }
        }
    }
}

