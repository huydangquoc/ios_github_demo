//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

struct PrefRowIdentifier {
    static let MininumStars = "Mininum Stars"
    static let FilterByLanguage = "Filter by Language"
    static let Language = "language:"
    static let SearchIn = "in:"
}

struct CellIdentifier {
    static let ValueSliderCell = "ValueSliderCell"
    static let SwitchCell = "SwitchCell"
    static let CheckMarkCell = "CheckMarkCell"
}

enum PrefSection : Int {
    case MininumStars = 0
    case FilterByLanguage
    case SearchIn
}

class SearchSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var settings: GithubRepoSearchSettings!
    let tableStructure: [[String]] = [[PrefRowIdentifier.MininumStars],
                                      [PrefRowIdentifier.FilterByLanguage, PrefRowIdentifier.Language],
                                      [PrefRowIdentifier.SearchIn]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // remove empty rows by setting empty footer
        // ref: http://stackoverflow.com/questions/14520185/how-to-remove-empty-cells-in-uitableview
        tableView.tableFooterView = UIView()
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
        
        return self.tableStructure.count
    }
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numOfRows = 0
        
        switch PrefSection(rawValue: section)! {
        case .MininumStars:
            numOfRows = 1
        case .FilterByLanguage:
            if settings.shouldFilterLanguages {
                numOfRows = 1 + languages.count
            } else {
                numOfRows = 1
            }
        case .SearchIn:
            numOfRows = searchInFields.count
        }
        
        return numOfRows
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch PrefSection(rawValue: indexPath.section)! {
        case .MininumStars:
            return cellForMininumStars(tableView, cellForRowAtIndexPath: indexPath)
        case .FilterByLanguage:
            return cellForFilterByLanguage(tableView, cellForRowAtIndexPath: indexPath)
        case .SearchIn:
            return cellSearchIn(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func cellForMininumStars(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let minStarsCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.ValueSliderCell) as! ValueSliderCell
        
        minStarsCell.configure(PrefRowIdentifier.MininumStars, valueMinimum: 0, valueMaximum: 5000)
        minStarsCell.slider.value = Float(settings.minStars)
        minStarsCell.valueLabel.text = String(settings.minStars)
        minStarsCell.valueIdentifer = PrefRowIdentifier.MininumStars
        minStarsCell.delegate = self
        
        return minStarsCell
    }
    
    func cellForFilterByLanguage(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let filterLanguagesCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.SwitchCell) as! SwitchCell
            filterLanguagesCell.descriptionLabel.text = PrefRowIdentifier.FilterByLanguage
            filterLanguagesCell.switchIdentifier = PrefRowIdentifier.FilterByLanguage
            filterLanguagesCell.onOffSwitch.on = settings.shouldFilterLanguages
            filterLanguagesCell.delegate = self
            return filterLanguagesCell
        } else {
            let languageCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CheckMarkCell) as! CheckMarkCell
            languageCell.descriptionLabel.text = languages[indexPath.row - 1]
            languageCell.switchIdentifier = PrefRowIdentifier.Language
            languageCell.key = languages[indexPath.row - 1]
            languageCell.isChecked = settings.includeLanguage[indexPath.row - 1]
            languageCell.delegate = self
            return languageCell
        }
    }
    
    func cellSearchIn(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let searchInCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CheckMarkCell) as! CheckMarkCell
        
        searchInCell.descriptionLabel.text = "Search in \(searchInFields[indexPath.row])"
        searchInCell.switchIdentifier = PrefRowIdentifier.SearchIn
        searchInCell.key = searchInFields[indexPath.row]
        searchInCell.isChecked = settings.includeSearchFields[indexPath.row]
        searchInCell.delegate = self
        
        return searchInCell
    }
    
}

extension SearchSettingsViewController: UITableViewDelegate {
    
    // Asks the delegate for the height to use for the header of a particular section.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    // Asks the delegate for a view object to display in the header of the specified section of the table view.
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    
//        let frame = tableView.frame
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
//        headerView.backgroundColor = UIColor.clearColor()
//    
//        return headerView
//    }
    
    // Tells the delegate that the specified row is now selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension SearchSettingsViewController: ValueSliderCellDelegate {
    
    func sliderValueDidChange(cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float) {
        
        if let identifier = valueIdentifier as? String {
            if identifier == PrefRowIdentifier.MininumStars {
                settings?.minStars = Int(newValue)
                tableView.reloadData()
            }
        }
    }
}

extension SearchSettingsViewController: ToggleCellDelegate {
    
    func toggleCellDidToggle(cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool) {
        
        if let identifier = toggleIdenfifier as? String {
            if identifier == PrefRowIdentifier.FilterByLanguage {
                settings?.shouldFilterLanguages = newValue
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.Language {
                let languageCell = cell as! CheckMarkCell
                if let index = languages.indexOf(languageCell.key) {
                    settings.includeLanguage[index] = newValue
                }
            } else if identifier == PrefRowIdentifier.SearchIn {
                let searchInCell = cell as! CheckMarkCell
                if let index = searchInFields.indexOf(searchInCell.key) {
                    settings.includeSearchFields[index] = newValue
                }
            }
        }
    }
}

