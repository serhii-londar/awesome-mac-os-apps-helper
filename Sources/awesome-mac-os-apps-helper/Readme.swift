//
//  Readme.swift
//  BaseAPI
//
//  Created by Serhii Londar on 10/15/18.
//

import Foundation
import GithubAPI

class Readme {
    func generateNewReadme() {
        guard let lines = getLinesFromReadme() else {
            return
        }
        var newReadmeLines = [String]()
        var processLine = false
        for line in lines {
            if line == Constants.startProcessString {
                processLine = true
                continue
            } else if line == Constants.endProcessString {
                processLine = false
                break
            }
            if processLine {
                let urls = line.extractURLs()
                guard let repoURL = urls.first else {
                    newReadmeLines.append(line)
                    continue
                }
                let components = repoURL.absoluteString.components(separatedBy: "/")
                guard components.count == 5 else { continue }
                let owner = components[3]
                let repo = components[4]
                let response = RepositoriesContentsAPI(authentication: TokenAuthentication(token: "c7d13ae14eebcfd5b9c70f7d0e925c81a385fd99")).getReadmeSync(owner: owner, repo: repo)
                let readme = response.0
                if response.1 != nil {
                    sleep(5)
                }
                guard let readmeContent = readme?.content?.replacingOccurrences(of: "\n", with: "").base64Decoded() else { continue }
                
                let imageLocalUrls = Readme.getLocalImageUrls(readmeContent, owner: owner, repo: repo)
                if imageLocalUrls.count > 0 {
                    print(imageLocalUrls)
                }
                let readmeUrls = readmeContent.extractURLs()
                var imageUrls = readmeUrls.filter({ $0.absoluteString.hasSuffix(".png") || $0.absoluteString.hasSuffix(".jpg") || $0.absoluteString.hasSuffix(".gif") }).map({ $0.absoluteString })
                imageUrls.append(contentsOf: imageLocalUrls)
                //1:
                //https://github.com/shibiao/SBPlayerClient/blob/master/images/0x0ss.jpg
                //https://raw.githubusercontent.com/shibiao/SBPlayerClient/master/images/0x0ss.jpg
                //2:
                //https://raw.github.com/sonoramac/Sonora/master/screenshot.png
                //https://raw.raw.githubusercontent.com/sonoramac/Sonora/master/screenshot.png
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
                    var newLine = line
                    newLine += (" " + Constants.detailsBeginString + " ")
                    imageUrls.forEach({
                        newLine += (" " + (NSString(format: Constants.srcLinePattern as NSString, $0 as CVarArg) as String) + " ")
                    })
                    newLine += (" " + Constants.detailsEndString + " ")
                    newReadmeLines.append(newLine)
                } else {
                    newReadmeLines.append(line)
                }
            }
        }
        let newReadme = readmeStringFromLines(newReadmeLines)
        try? newReadme.data(using: .utf8)?.write(to: URL(fileURLWithPath: "./NEWREADME.md"))
        print("!!!!!FINISHED!!!!!")
    }

    static func getLocalImageUrls(_ readme: String, owner: String, repo: String) -> [String] {
        let imageNames1 = readme.capturedGroups(withRegex: Constants.regex(for: "png")) + readme.capturedGroups(withRegex: Constants.regex(for: "jpg")) + readme.capturedGroups(withRegex: Constants.regex(for: "gif")) + readme.capturedGroups(withRegex: Constants.regex(for: "jpeg")) + readme.capturedGroups(withRegex: Constants.regex(for: "bmp"))
        let imageNames2 = readme.capturedGroups(withRegex: Constants.regex1(for: "png")) + readme.capturedGroups(withRegex: Constants.regex1(for: "jpg")) + readme.capturedGroups(withRegex: Constants.regex1(for: "gif")) + readme.capturedGroups(withRegex: Constants.regex1(for: "jpeg")) + readme.capturedGroups(withRegex: Constants.regex1(for: "bmp"))
        var imageNames = imageNames1 + imageNames2
        imageNames = imageNames.map({ $0.replacingOccurrences(of: "(", with: "") })
        imageNames = imageNames.map({ $0.replacingOccurrences(of: "\"", with: "") })
        imageNames = imageNames.filter({ $0.isURL == false })
        return imageNames.map({ "https://raw.githubusercontent.com/\(owner)/\(repo)/master/\($0)" })
    }
    
    func getLinesFromReadme() -> [String]? {
        guard let data = FileManager.default.contents(atPath: "./README.md") else { return nil }
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        let lines = string.components(separatedBy: CharacterSet.newlines).map({ String($0) })
        return lines
    }
    
    func readmeStringFromLines(_ lines: [String]) -> String {
        var result = ""
        for line in lines {
            result += line + "\n"
        }
        return result
    }
    func oldRegex(with type: String) -> String {
        return "\\!\\[(.+)\\]\\((.+\\.\(type)\\))"
    }
    
}
