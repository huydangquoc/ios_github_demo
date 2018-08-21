//
//  GithubRepo.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

// sample query: https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc

import Foundation
import AFNetworking

private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = nil
private let clientSecret: String? = nil

// Model class that represents a GitHub repository
class GithubRepo: CustomStringConvertible {

    var name: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    var desc: String?
    
    // Initializes a GitHubRepo from a JSON dictionary
    init(jsonResult: NSDictionary) {
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int? {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int? {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
        if let description = jsonResult["description"] as? String {
            self.desc = description
        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchRepos(_ settings: GithubRepoSearchSettings, successCallback: @escaping ([GithubRepo]) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings);
        
        manager.get(reposUrl, parameters: params, success: { (operation ,responseObject) -> Void in
            if let response = responseObject as? [String:Any],
                   let results = response["items"] as? NSArray {
                var repos: [GithubRepo] = []
                for result in results as! [NSDictionary] {
                    repos.append(GithubRepo(jsonResult: result))
                }
                successCallback(repos)
            }
        }, failure: { (operation, requestError) -> Void in
            if let errorCallback = error {
                errorCallback(requestError as NSError)
            }
        })
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings(_ settings: GithubRepoSearchSettings) -> [String: String] {
        var params: [String:String] = [:];
        if let clientId = clientId {
            params["client_id"] = clientId;
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret;
        }
        
        var q = "";
        if let searchString = settings.searchString {
            q = q + searchString;
        }
        
        q = q + " stars:>\(settings.minStars)";
        
        // set filter for search
        if settings.shouldScopeSearchIn {
            for (index, searchInField) in searchInFields.enumerated() {
                if settings.includeSearchFields[index] {
                    q = q + " in:\(searchInField)"
                }
            }
        }
        
        if settings.shouldFilterLanguages {
            for (index, language) in languages.enumerated() {
                if settings.includeLanguage[index].active {
                    q = q + " language:\"\(language)\""
                }
            }
        }
        
        if settings.shouldFilterCreatedDate {
            q = q + " created:>" + getDateAsSelection(settings.createdBefore)
        }
        
        params["q"] = q;
        if settings.shouldSortBy {
            params["sort"] = settings.sortBy;
        }
        params["order"] = "desc";
        
        return params;
    }
    
    // ref: http://stackoverflow.com/questions/28587311/how-do-you-get-last-weeks-date-in-swift-in-yyyy-mm-dd-format
    fileprivate class func getDateAsSelection(_ selection: CreatedIn) -> String {
        
        let calendar = Calendar.current
        let current = Date()
        let styler = DateFormatter()
        let option = NSCalendar.Options()
        styler.dateFormat = "yyyy-MM-dd"
        
        var date: Date
        switch selection {
        case .LastWeek:
            date = (calendar as NSCalendar).date(byAdding: .weekOfYear, value: -1, to: current, options: option)!
        case .LastMonth:
            date = (calendar as NSCalendar).date(byAdding: .month, value: -1, to: current, options: option)!
        case .LastYear:
            date = (calendar as NSCalendar).date(byAdding: .year, value: -1, to: current, options: option)!
        }
        
        return styler.string(from: date)
    }

    // Creates a text representation of a GitHub repo
    var description: String {
        return "[Name: \(self.name!)]" +
            "\n\t[Stars: \(self.stars!)]" +
            "\n\t[Forks: \(self.forks!)]" +
            "\n\t[Owner: \(self.ownerHandle!)]" +
            "\n\t[Avatar: \(self.ownerAvatarURL!)]" +
            "\n\t[Description: \(self.desc!)]"
    }
}
