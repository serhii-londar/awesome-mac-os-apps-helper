//
//  Language.swift
//  awesome-mac-os-apps-helper
//
//  Created by Serhii Londar on 10/15/18.
//

import Foundation

enum Language: String {
    case c
    case cpp
    case c_sharp
    case clojure
    case coffee_script
    case css
    case elm
    case haskell
    case java
    case javascript
    case lua
    case objective_c
    case python
    case ruby
    case rust
    case swift
    case type_script
    
    static var all: [Language] {
        return [.c, .cpp, .c_sharp, .clojure, .coffee_script, .css, .elm, .haskell, .java, .javascript, .lua, .objective_c, .python, .ruby, .rust, .swift, .type_script]
    }
    var icon: String {
        return self.rawValue + "_icon"
    }
}
