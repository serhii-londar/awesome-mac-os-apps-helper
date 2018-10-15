//
//  Constants.swift
//  BaseAPI
//
//  Created by Serhii Londar on 10/15/18.
//

import Foundation

struct Constants {
    static let detailsBeginString = "<details> <summary> Screenshots </summary> <p float=\"left\">"
    static let detailsEndString = "</p></details>"
    static let srcLinePattern = "<bt><img src='%@' width=\"400\"/>"
    
    static let startProcessString = "### Database"
    static let endProcessString = "### Development"
    
    static func regex(for type: String) -> String {
        return "\\((.+\\.\(type))"
    }
    static func regex1(for type: String) -> String {
        return "\\\"(.+\\.\(type))"
    }
}
