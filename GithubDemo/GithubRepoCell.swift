//
//  GithubRepoCell.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class GithubRepoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var ownerAvatarImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentWithRepo(repo: GithubRepo) {
//        nameLabel.text = repo.name
//        ownerLabel.text = repo.ownerHandle
//        if let stars = repo.stars {
//            starsLabel.text = String(stars)
//        }
//        
//        if let forks = repo.forks {
//            forksLabel.text = String(forks)
//        }
//        
//        if let urlString = repo.ownerAvatarURL {
//            let ownerAvatarURL = NSURL(string: urlString)!
//            ownerAvatarImage.setImageWithURL(ownerAvatarURL)
//        }
//        descriptionLabel.text = repo.description
    }
}
