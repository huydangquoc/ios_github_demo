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
    static let ScopeSearchIn = "Scope to search"
    static let SearchIn = "in:"
    static let SortBy = "Sort by"
    static let SortField = "Sort field"
    static let CreatedWithin = "Created within"
    static let DateFilter = "Date filter"
}

struct CellIdentifier {
    static let ValueSliderCell = "ValueSliderCell"
    static let SwitchCell = "SwitchCell"
    static let CheckMarkCell = "CheckMarkCell"
}

enum PrefSection : Int {
    case mininumStars = 0
    case filterByLanguage
    case scopeSearchIn
    case sortBy
    case createdWithin
}

class SearchSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var settings: GithubRepoSearchSettings!
    let tableStructure: [[String]] = [[PrefRowIdentifier.MininumStars],
                                      [PrefRowIdentifier.FilterByLanguage, PrefRowIdentifier.Language],
                                      [PrefRowIdentifier.ScopeSearchIn, PrefRowIdentifier.SearchIn],
                                      [PrefRowIdentifier.SortBy, PrefRowIdentifier.SortField],
                                      [PrefRowIdentifier.CreatedWithin, PrefRowIdentifier.DateFilter]]

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
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.tableStructure.count
    }
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numOfRows = 0
        
        switch PrefSection(rawValue: section)! {
        case .mininumStars:
            numOfRows = 1
        case .filterByLanguage:
            if settings.shouldFilterLanguages {
                numOfRows = 1 + languages.count
            } else {
                numOfRows = 1
            }
        case .scopeSearchIn:
            if settings.shouldScopeSearchIn {
                numOfRows = 1 + searchInFields.count
            } else {
                numOfRows = 1
            }
        case .sortBy:
            if settings.shouldSortBy {
                numOfRows = 1 + sortBys.count
            } else {
                numOfRows = 1
            }
        case .createdWithin:
            if settings.shouldFilterCreatedDate {
                numOfRows = 1 + createdIns.count
            } else {
                numOfRows = 1
            }
        }
        
        return numOfRows
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch PrefSection(rawValue: indexPath.section)! {
        case .mininumStars:
            return cellForMininumStars(tableView, cellForRowAtIndexPath: indexPath)
        case .filterByLanguage:
            return cellForFilterByLanguage(tableView, cellForRowAtIndexPath: indexPath)
        case .scopeSearchIn:
            return cellSearchIn(tableView, cellForRowAtIndexPath: indexPath)
        case .sortBy:
            return cellSortBy(tableView, cellForRowAtIndexPath: indexPath)
        case .createdWithin:
            return cellCreatedWithin(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func cellForMininumStars(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let minStarsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ValueSliderCell) as! ValueSliderCell
        
        minStarsCell.configure(PrefRowIdentifier.MininumStars, valueMinimum: 0, valueMaximum: 5000)
        minStarsCell.slider.value = Float(settings.minStars)
        minStarsCell.valueLabel.text = String(settings.minStars)
        minStarsCell.valueIdentifer = PrefRowIdentifier.MininumStars as AnyObject
        minStarsCell.delegate = self
        
        return minStarsCell
    }
    
    func cellForFilterByLanguage(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let filterLanguagesCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SwitchCell) as! SwitchCell
            filterLanguagesCell.descriptionLabel.text = PrefRowIdentifier.FilterByLanguage
            filterLanguagesCell.switchIdentifier = PrefRowIdentifier.FilterByLanguage as AnyObject
            filterLanguagesCell.onOffSwitch.isOn = settings.shouldFilterLanguages
            filterLanguagesCell.delegate = self
            return filterLanguagesCell
        } else {
            let languageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckMarkCell) as! CheckMarkCell
            languageCell.descriptionLabel.text = languages[indexPath.row - 1]
            languageCell.switchIdentifier = PrefRowIdentifier.Language as AnyObject
            languageCell.key = languages[indexPath.row - 1]
            languageCell.isChecked = settings.includeLanguage[indexPath.row - 1].active
            languageCell.delegate = self
            return languageCell
        }
    }
    
    func cellSearchIn(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let scopeSearchInCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SwitchCell) as! SwitchCell
            scopeSearchInCell.descriptionLabel.text = PrefRowIdentifier.ScopeSearchIn
            scopeSearchInCell.switchIdentifier = PrefRowIdentifier.ScopeSearchIn as AnyObject
            scopeSearchInCell.onOffSwitch.isOn = settings.shouldScopeSearchIn
            scopeSearchInCell.delegate = self
            return scopeSearchInCell
        } else {
            let searchInCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckMarkCell) as! CheckMarkCell
            searchInCell.descriptionLabel.text = "Search in \(searchInFields[indexPath.row - 1])"
            searchInCell.switchIdentifier = PrefRowIdentifier.SearchIn as AnyObject
            searchInCell.key = searchInFields[indexPath.row - 1]
            searchInCell.isChecked = settings.includeSearchFields[indexPath.row - 1]
            searchInCell.delegate = self
            return searchInCell
        }
    }
    
    func cellSortBy(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let sortByCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SwitchCell) as! SwitchCell
            sortByCell.descriptionLabel.text = PrefRowIdentifier.SortBy
            sortByCell.switchIdentifier = PrefRowIdentifier.SortBy as AnyObject
            sortByCell.onOffSwitch.isOn = settings.shouldSortBy
            sortByCell.delegate = self
            return sortByCell
        } else {
            let sortFieldCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckMarkCell) as! CheckMarkCell
            sortFieldCell.descriptionLabel.text = sortBys[indexPath.row - 1]
            sortFieldCell.switchIdentifier = PrefRowIdentifier.SortField as AnyObject
            sortFieldCell.key = sortBys[indexPath.row - 1]
            sortFieldCell.isChecked = sortFieldCell.key == settings.sortBy
            sortFieldCell.delegate = self
            return sortFieldCell
        }
    }
    
    func cellCreatedWithin(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let createdWithinCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SwitchCell) as! SwitchCell
            createdWithinCell.descriptionLabel.text = PrefRowIdentifier.CreatedWithin
            createdWithinCell.switchIdentifier = PrefRowIdentifier.CreatedWithin as AnyObject
            createdWithinCell.onOffSwitch.isOn = settings.shouldFilterCreatedDate
            createdWithinCell.delegate = self
            return createdWithinCell
        } else {
            let dateFilterCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CheckMarkCell) as! CheckMarkCell
            dateFilterCell.descriptionLabel.text = createdIns[indexPath.row - 1]
            dateFilterCell.switchIdentifier = PrefRowIdentifier.DateFilter as AnyObject
            dateFilterCell.key = createdIns[indexPath.row - 1]
            dateFilterCell.isChecked = CreatedIn(rawValue: dateFilterCell.key)! == settings.createdBefore
            dateFilterCell.delegate = self
            return dateFilterCell
        }
    }
}

extension SearchSettingsViewController: UITableViewDelegate {
    
    // Asks the delegate for the height to use for the header of a particular section.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchSettingsViewController: ValueSliderCellDelegate {
    
    func sliderValueDidChange(_ cell: ValueSliderCell, valueIdentifier: AnyObject, newValue: Float) {
        
        if let identifier = valueIdentifier as? String {
            if identifier == PrefRowIdentifier.MininumStars {
                settings?.minStars = Int(newValue)
                tableView.reloadData()
            }
        }
    }
}

extension SearchSettingsViewController: ToggleCellDelegate {
    
    func toggleCellDidToggle(_ cell: UITableViewCell, toggleIdenfifier: AnyObject, newValue:Bool) {
        
        if let identifier = toggleIdenfifier as? String {
            if identifier == PrefRowIdentifier.FilterByLanguage {
                settings?.shouldFilterLanguages = newValue
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.Language {
                let languageCell = cell as! CheckMarkCell
                if let index = languages.index(of: languageCell.key) {
                    settings.includeLanguage[index].active = newValue
                }
            } else if identifier == PrefRowIdentifier.ScopeSearchIn {
                settings?.shouldScopeSearchIn = newValue
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.SearchIn {
                let searchInCell = cell as! CheckMarkCell
                if let index = searchInFields.index(of: searchInCell.key) {
                    settings.includeSearchFields[index] = newValue
                }
            } else if identifier == PrefRowIdentifier.SortBy {
                settings?.shouldSortBy = newValue
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.SortField {
                let sortFieldCell = cell as! CheckMarkCell
                settings.sortBy = sortFieldCell.key
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.CreatedWithin {
                settings?.shouldFilterCreatedDate = newValue
                tableView.reloadData()
            } else if identifier == PrefRowIdentifier.DateFilter {
                let dateFilterCell = cell as! CheckMarkCell
                settings.createdBefore = CreatedIn(rawValue: dateFilterCell.key)!
                tableView.reloadData()
            }
        }
    }
}

