//
//  Readme.swift
//  BaseAPI
//
//  Created by Serhii Londar on 10/15/18.
//

import Foundation
import GithubAPI

class Markdown {
    func generateMarkdownForRepo(_ repoUrl: String, description: String, language: Language) {
        let autentification = TokenAuthentication(token: "")
        let components = repoUrl.components(separatedBy: "/")
        guard components.count == 5 else { return }
        let owner = components[3]
        let repo = components[4]
        var line = "- [\(repo)](\(repoUrl) - \(description) ![\(language)]"
        let response = RepositoriesContentsAPI(authentication: autentification).getReadmeSync(owner: owner, repo: repo)
        let readme = response.0
        guard let readmeContent = readme?.content?.replacingOccurrences(of: "\n", with: "").base64Decoded() else { return }
        let imageLocalUrls = Readme.getLocalImageUrls(readmeContent, owner: owner, repo: repo)
        if imageLocalUrls.count > 0 {
            print(imageLocalUrls)
        }
        let readmeUrls = readmeContent.extractURLs()
        var imageUrls = readmeUrls.filter({ $0.absoluteString.hasSuffix(".png") || $0.absoluteString.hasSuffix(".jpg") || $0.absoluteString.hasSuffix(".gif") }).map({ $0.absoluteString })
        imageUrls.append(contentsOf: imageLocalUrls)
        imageUrls = imageUrls.map { (input) -> String in
            var output = input
            //Fix 1:
            if output.contains("https://github.com") {
                output = output.replacingOccurrences(of: "github.com", with: "raw.githubusercontent.com").replacingOccurrences(of: "/blob", with: "")
            }
            //Fix 2:
            if output.contains("https://raw.github.com") {
                output = output.replacingOccurrences(of: "github.com", with: "githubusercontent.com")
            }
            return output
        }
        if imageUrls.count > 0 {
            line += (" " + Constants.detailsBeginString + " ")
            imageUrls.forEach({
                line += (" " + (NSString(format: Constants.srcLinePattern as NSString, $0 as CVarArg) as String) + " ")
            })
            line += (" " + Constants.detailsEndString + " ")
        }
        guard let data = line.data(using: .utf8) else { return }
        try? data.write(to: URL(fileURLWithPath: "./\(repo).md"))
        print("Saved to - ./\(repo).md")
    }
}
