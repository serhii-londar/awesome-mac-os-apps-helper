//
//  ReadmeGenerator.swift
//  awesome-mac-os-apps-helper
//
//  Created by Serhii Londar on 11/12/18.
//

import Foundation

let header = """
<p align="center">
<img src="./icons/icon.png">
</p>

# Awesome macOS open source applications

<p align="left">
<a href="https://github.com/sindresorhus/awesome"><img alt="Awesome" src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg" /></a>
<a href="https://gitter.im/open-source-mac-os-apps/Lobby?utm_source=share-link&utm_medium=link&utm_campaign=share-link"><img alt="Join the chat at gitter" src="https://badges.gitter.im/Join%20Chat.svg" /></a>
</p>

## Support
Hey friend! Help me out for a couple of :beers:!  <span class="badge-patreon"><a href="https://www.patreon.com/serhiilondar" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>


List of awesome open source applications for macOS. This list contains a lot of native, and cross-platform apps. The main goal of this repository is to find free open source apps and start contributing. Feel free to [contribute](CONTRIBUTING.md) to the list, any suggestions are welcome!

You can see in which language an app is written. Currently there are following languages:

- ![c_icon] - C language.
- ![cpp_icon] - C++ language.
- ![c_sharp_icon] - C# language.
- ![clojure_icon] - Clojure language.
- ![coffee_script_icon] - CoffeeScript language.
- ![css_icon] - CSS language.
- ![elm_icon] - Elm language.
- ![haskell_icon] - Haskell language.
- ![javascript_icon] - JavaScript language.
- ![lua_icon] - Lua language.
- ![objective_c_icon] - Objective-C language.
- ![python_icon] - Python language.
- ![ruby_icon] - Ruby language.
- ![rust_icon] - Rust language.
- ![swift_icon] - Swift language.
- ![type_script_icon] - TypeScript language.


## Contents
- [Audio](#audio)
- [Backup](#backup)
- [Browser](#browser)
- [Chat](#chat)
- [Cryptocurrency](#cryptocurrency)
- [Database](#database)
- [Development](#development)
    - [Git](#git)
    - [iOS / macOS](#ios--macos)
    - [JSON Parsing](#json-parsing)
    - [Web development](#web-development)
    - [Other](#other)
- [Downloader](#downloader)
- [Editors](#editors)
    - [CSV](#csv)
    - [JSON](#json)
    - [Markdown](#markdown)
    - [TeX](#tex)
    - [Text](#text)
- [Extensions](#extensions)
- [Finder](#finder)
- [Games](#games)
- [Graphics](#graphics)
- [IDE](#ide)
- [Images](#images)
- [Keyboard](#keyboard)
- [Mail](#mail)
- [Menubar](#menubar)
- [Music](#music)
- [News](#news)
- [Notes](#notes)
- [Other](#other-1)
- [Podcast](#podcast)
- [Productivity](#productivity)
- [Screensaver](#screensaver)
- [Security](#security)
- [Sharing Files](#sharing-files)
- [Social Networking](#social-networking)
- [Streaming](#streaming)
- [System](#system)
- [Terminal](#terminal)
- [Utilities](#utilities)
- [VPN & Proxy](#vpn--proxy)
- [Video](#video)
- [Wallpaper](#wallpaper)
- [Window Management](#window-management)

## Applications

"""

let footer = """

## Contributors

Thanks to all the people who contribute:

<a href="https://github.com/serhii-londar/open-source-mac-os-apps/graphs/contributors"><img src="https://opencollective.com/open-source-mac-os-apps/contributors.svg?width=890&button=false" /></a>

[app_store]: ./icons/app_store-16.png 'App Store.'
[c_icon]: ./icons/c-16.png 'C language.'
[cpp_icon]: ./icons/cpp-16.png 'C++ language.'
[c_sharp_icon]: ./icons/csharp-16.png 'C# Language'
[clojure_icon]: ./icons/clojure-16.png 'Clojure Language'
[coffee_script_icon]: ./icons/coffeescript-16.png 'CoffeeScript language.'
[css_icon]: ./icons/css-16.png 'CSS language.'
[elm_icon]: ./icons/elm-16.png 'Elm Language'
[haskell_icon]: ./icons/haskell-16.png 'Haskell language.'
[java_icon]: ./icons/java-16.png 'Java language.'
[javascript_icon]: ./icons/javascript-16.png 'JavaScript language.'
[lua_icon]: ./icons/Lua-16.png 'Lua language.'
[objective_c_icon]: ./icons/objective-c-16.png 'Objective-C language.'
[python_icon]: ./icons/python-16.png 'Python language.'
[ruby_icon]: ./icons/ruby-16.png 'Ruby language.'
[rust_icon]: ./icons/rust-16.png 'Rust language.'
[swift_icon]: ./icons/swift-16.png 'Swift language.'
[type_script_icon]: ./icons/typescript-16.png 'TypeScript language.'
"""

class Categories: Codable {
    let categories: [Category]
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Category].self, forKey: .categories) ?? []
    }
}

class Category: Codable {
    let title, id, description: String
    let parent: String?
    
    init(title: String, id: String, description: String, parent: String?) {
        self.title = title
        self.id = id
        self.description = description
        self.parent = parent
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        parent = try values.decodeIfPresent(String.self, forKey: .parent) ?? ""
    }
}

class ReadmeGenerator {
    var readmeString = ""
    
    func generateReadme() {
        guard let applicationsData = try? Data(contentsOf: URL(fileURLWithPath: "./applications.json")) else { return }
        guard let categoriesData = try? Data(contentsOf: URL(fileURLWithPath: "./categories.json")) else { return }
        let jsonDecoder = JSONDecoder()
        guard let applicationsObject = try? jsonDecoder.decode(JSONApplications.self, from: applicationsData) else { return }
        guard let categoriesObject = try? jsonDecoder.decode(Categories.self, from: categoriesData) else { return }
        
        
        var categories = categoriesObject.categories
        let allSubcategories = categories.filter({ $0.parent != nil && !$0.parent!.isEmpty })
        var applications = applicationsObject.applications
        
        for subcategory in allSubcategories {
            if let index = categories.lastIndex(where: { $0.parent != subcategory.id }) {
                categories.remove(at: index)
            }
        }
        
        categories = categories.sorted { (c1, c2) -> Bool in
            return c1.title < c2.title
        }
        
        applications = applications.sorted(by: { (ap1, ap2) -> Bool in
            return ap1.category < ap2.category
        })
        
        readmeString.append(header)
        
        for category in categories {
            readmeString.append("\n### \(category.title)\n")
            var categoryApplications = applications.filter({ $0.category == category.id })
            categoryApplications = categoryApplications.sorted(by: { (ap1, ap2) -> Bool in
                return ap1.title < ap2.title
            })
            
            for application in categoryApplications {
                var languages: String = ""
                for lang in application.languages {
                    languages.append("![\(lang)] ")
                }
                readmeString.append("- [\(application.title)](\(application.repoURL)) - \(application.shortDescription) \(languages)")
                if application.screenshots.count > 0 {
                    var screenshotsString = ""
                    screenshotsString += (" " + Constants.detailsBeginString + " ")
                    application.screenshots.forEach({
                        screenshotsString += (" " + (NSString(format: Constants.srcLinePattern as NSString, $0 as CVarArg) as String) + " ")
                    })
                    screenshotsString += (" " + Constants.detailsEndString + " ")
                    readmeString.append(screenshotsString)
                }
                readmeString.append("\n")
            }
            
            var subcategories = allSubcategories.filter({ $0.parent == category.id })
            guard subcategories.count > 0 else { continue }
            subcategories = subcategories.sorted { (sc1, sc2) -> Bool in
                return sc1.title < sc2.title
            }
            for subcategory in subcategories {
                readmeString.append("\n#### \(subcategory.title)\n\n")
                var categoryApplications = applications.filter({ $0.category == subcategory.id })
                categoryApplications = categoryApplications.sorted(by: { (ap1, ap2) -> Bool in
                    return ap1.title < ap2.title
                })
                
                for application in categoryApplications {
                    var languages: String = ""
                    for lang in application.languages {
                        languages.append("![\(lang)] ")
                    }
                    
                    readmeString.append("- [\(application.title)](\(application.repoURL)) - \(application.shortDescription) \(languages)")
                    
                    if application.screenshots.count > 0 {
                        var screenshotsString = ""
                        screenshotsString += (" " + Constants.detailsBeginString + " ")
                        application.screenshots.forEach({
                            readmeString += (" " + (NSString(format: Constants.srcLinePattern as NSString, $0 as CVarArg) as String) + " ")
                        })
                        screenshotsString += (" " + Constants.detailsEndString + " ")
                        readmeString.append(screenshotsString)
                    }
                    readmeString.append("\n")
                }
                
            }
        }
        
        
        readmeString.append(footer)
        print(readmeString)

        try? readmeString.data(using: .utf8)?.write(to: URL(fileURLWithPath: "./NEWREADME.md"))
        print("!!!!!FINISHED!!!!!")
    }
}


