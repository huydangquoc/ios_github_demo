//
//  GithubRepoSearchSettings.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

var languages: [String] = []

let searchInFields = ["name",
                    "description",
                    "readme"]

let sortBys = ["stars",
               "forks",
               "updated"]

enum CreatedIn : String {
    case LastWeek = "last week"
    case LastMonth = "last month"
    case LastYear = "last year"
    
    static func toArray() -> [String] {
        return [LastWeek.rawValue,
                LastMonth.rawValue,
                LastYear.rawValue]
    }
}

let createdIns = CreatedIn.toArray()

// Model class that represents the user's search settings
struct GithubRepoSearchSettings {
    
    var searchString: String? = nil
    var minStars = 0
    var shouldFilterLanguages = false
    var includeLanguage: [GithubLanguage] = []
    var shouldScopeSearchIn = false;
    var includeSearchFields = [true,    // name
                               true,    // description
                               true]    // readme
    var shouldSortBy = false
    var sortBy = sortBys[0]
    var shouldFilterCreatedDate = false
    var createdBefore = CreatedIn.LastWeek
}
