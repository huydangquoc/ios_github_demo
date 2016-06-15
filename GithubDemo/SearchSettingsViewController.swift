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
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let minStarsCell = tableView.dequeueReusableCellWithIdentifier("ValueSliderCell") as! ValueSliderCell
        
        minStarsCell.configure("Mininum Stars", valueMinimum: 0, valueMaximum: 5000)
        minStarsCell.slider.value = Float(settings.minStars)
        minStarsCell.valueLabel.text = String(settings.minStars)
        minStarsCell.valueIdentifer = "Mininum Stars"
        minStarsCell.delegate = self
        
        return minStarsCell
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



