//
//  GithubLanguages.swift
//  GithubDemo
//
//  Created by Dang Quoc Huy on 6/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

// Link: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml

// Credit: YamlSwift
// https://github.com/behrang/YamlSwift

import Foundation
import AFNetworking

private let repoLanguagesUrl = "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"

// struct that represents a GitHub Language
// type:              - Either data, programming, markup, prose, or nil
// aliases:           - An Array of additional aliases (implicitly
//                      includes name.downcase)
// ace_mode:          - A String name of the Ace Mode used for highlighting whenever
//                      a file is edited. This must match one of the filenames in http://git.io/3XO_Cg.
//                      Use "text" if a mode does not exist.
// wrap:              - Boolean wrap to enable line wrapping (default: false)
// extensions:        - An Array of associated extensions (the first one is
//                      considered the primary extension, the others should be
//                      listed alphabetically)
// interpreters:      - An Array of associated interpreters
// searchable:        - Boolean flag to enable searching (defaults to true)
// search_term:       - Deprecated: Some languages maybe indexed under a
//                      different alias. Avoid defining new exceptions.
// color:             - CSS hex color to represent the language.
// tm_scope:          - The TextMate scope that represents this programming
//                      language. This should match one of the scopes listed in
//                      the grammars.yml file. Use "none" if there is no grammar
//                      for this language.
// group:             - Name of the parent language. Languages in a group are counted
//                      in the statistics as the parent language.
struct GithubLanguage {
    
    // to save time, only store language name
    // later, if needed, will add more attributes
    var name = ""
    var active = true
}

func fetchGithubLanguage(successCallback: ([GithubLanguage]) -> Void) {
    if let url = NSURL(string: repoLanguagesUrl) {
        do {
            // parse config file
            let contents = try NSString(contentsOfURL: url, usedEncoding: nil)
            let lines = (contents as String).componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            var languages: [GithubLanguage] = []
            for line in lines {
                if line.characters.last == ":" && line.characters.first != " " {
                    let langName = line.characters.dropLast()
                    languages.append(GithubLanguage.init(name: String(langName), active: true))
                }
            }
            successCallback(languages)
        } catch {
            print("bad thing happened")
        }
    } else {
        print("bad thing happened")
    }
}
