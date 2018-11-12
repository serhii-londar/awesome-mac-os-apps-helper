//
//  main.swift
//  helper
//
//  Created by Serhii Londar on 7/25/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation

func main() {
    let argumetsCount = CommandLine.arguments.count
    guard argumetsCount == 7 || argumetsCount == 2 else {
        print("Invalid parameters count. Please check: awesome-mac-os-apps-helper --help.")
        return
    }
    
    for i in 1...CommandLine.arguments.count - 1 {
        let argument = CommandLine.arguments[i]
        switch argument {
        case "--help":
            print("--repoUrl - repository url \n--description - repository description \n--language - repository language \n--languages - view all avalaible languages")
            return
        case "--languages":
            Language.all.forEach({ print($0.rawValue) })
            return
        case "--repoUrl":
            Params.repositoryURL = CommandLine.arguments[i + 1]
        case "--description":
            Params.repositoryDescription = CommandLine.arguments[i + 1]
        case "--language":
            Params.language = CommandLine.arguments[i + 1]
        default: break
        }
    }
    guard let repositoryURL =  Params.repositoryURL, let repositoryDescription =  Params.repositoryDescription, let language = Params.language else {
        print("Invalid parameters. Please check: awesome-mac-os-apps-helper --help.")
        return
    }
    guard let lang = Language(rawValue: language.lowercased()) else {
        print("Please set correct language. Please check awesome-mac-os-apps-helper --language")
        return
    }
    Markdown().generateMarkdownForRepo(repositoryURL, description: repositoryDescription, language: lang)
}

//main()

//JSONExtraxtor().generateJSON()

ReadmeGenerator().generateReadme()
