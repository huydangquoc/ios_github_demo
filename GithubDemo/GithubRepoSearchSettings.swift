//
//  GithubRepoSearchSettings.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

let languages = ["Java",
                 "JavaScript",
                 "Objective-C",
                 "Python",
                 "Ruby",
                 "Swift"]

let searchInFields = ["name",
                    "description",
                    "readme"]

let sortBys = ["stars",
               "forks",
               "updated"]

//enum Language : String {
//    case Java = "Java"
//    case JavaScript = "JavaScript"
//    case Objective_C = "Objective-C"
//    case Python = "Python"
//    case Ruby = "Ruby"
//    case Swift = "Swift"
//    
//    static var count: Int {
//        // this work but may not work in future
//        return Language.Swift.hashValue + 1
//    }
//}

// Model class that represents the user's search settings
struct GithubRepoSearchSettings {
    
    var searchString: String? = nil
    var minStars = 0
    var shouldFilterLanguages = false
    var includeLanguage = [true,    // Java
                           true,    // JavaScript
                           true,    // Objective-C
                           true,    // Python
                           true,    // Ruby
                           true]    // Swift
    var shouldScopeSearchIn = false;
    var includeSearchFields = [true,    // name
                               true,    // description
                               true]    // readme
    var shouldSortBy = false
    var sortBy = sortBys[0]
}
