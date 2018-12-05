//
//  JSONExtraxtor.swift
//  awesome-mac-os-apps-helper
//
//  Created by Serhii Londar on 11/9/18.
//

import Foundation
import GithubAPI
import Cocoa

class JSONExtraxtor {
    func generateJSON() {
        guard let lines = getLinesFromReadme() else {
            return
        }
        var category: String = ""
        var subcategory: String? = nil
        var applications = [JSONApplication]()
        for line in lines {
            if line.contains(String.subsection) {
                subcategory = line.replacingOccurrences(of: String.subsection, with: "").replacingOccurrences(of: String.space, with: "-").replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "/", with: "").lowercased()
                continue
            }
            if line.contains(String.section) {
                category = line.replacingOccurrences(of: String.section, with: "").replacingOccurrences(of: String.space, with: "-").replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "/", with: "").lowercased()
                subcategory = nil
                continue
            }
            let regex = try! NSRegularExpression(pattern: "(\\[\\w+\\])(.*)( \\- )(.*)(\\ ?\\!\\[.*\\])(.*)")
            let results = regex.matches(in:line, range:NSMakeRange(0, line.count))
            if let result = results.first {
                var title = (line as NSString).substring(with: result.range(at: 1))
                title = String(title[title.index(title.startIndex, offsetBy: 1)...title.index(title.endIndex, offsetBy: -2)])
                var repoURL = (line as NSString).substring(with: result.range(at: 2))
                repoURL = String(repoURL[repoURL.index(repoURL.startIndex, offsetBy: 1)...repoURL.index(repoURL.endIndex, offsetBy: -2)])
                let shortDescription = (line as NSString).substring(with: result.range(at: 4))
                
                let languageRegex = try! NSRegularExpression(pattern: "\\!\\[[a-zA-z\\_]+_icon\\]")
                let languagesResults = languageRegex.matches(in:line, range:NSMakeRange(0, line.count))
                var languagesArray = [String]()
                for languageResult in languagesResults {
                    var languagesString = (line as NSString).substring(with: languageResult.range(at: 0))
                    languagesString = String(languagesString[languagesString.index(languagesString.startIndex, offsetBy: 2)...languagesString.index(languagesString.endIndex, offsetBy: -2)])
                    languagesArray.append(languagesString)
                }
                var imageUrls = [String]()
                let urlsString = (line as NSString).substring(with: result.range(at: 6))
                print(urlsString)
                let urlRegex = try! NSRegularExpression(pattern: "\\'(.*?)'")
                let urls = urlRegex.matches(in:urlsString, range:NSMakeRange(0, urlsString.count))
                for urlResult in urls {
                    for _ in 0...urlResult.numberOfRanges {
                        var imageUrl = (urlsString as NSString).substring(with: urlResult.range(at: 0))
                        imageUrl = String(imageUrl[imageUrl.index(imageUrl.startIndex, offsetBy: 1)...imageUrl.index(imageUrl.endIndex, offsetBy: -2)])
                        imageUrls.append(imageUrl)
                    }
                }
                let applicationCategory = subcategory ?? category
                let application = JSONApplication(title: title, repoURL: repoURL, shortDescription: shortDescription, languages: languagesArray, screenshots: imageUrls, category: applicationCategory)
                applications.append(application)
			} else {
				print(line)
			}
		}
        for application in applications {
            guard application.screenshots.count == 0 else { continue }
            
            application.screenshots = JSONExtraxtor.getAllImageUrls(from: application.repoURL)
        }
        let applicationsObject = JSONApplications(applications: applications)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(applicationsObject) {
            let string = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
            try? string?.write(to: URL(fileURLWithPath: "./apps.json"), atomically: true, encoding: .utf8)
        }
        
    }
    
    static func getAllImageUrls(from repoURL: String) -> [String] {
        let components = repoURL.components(separatedBy: "/")
        guard components.count == 5 else { return [] }
        let owner = components[3]
        let repo = components[4]
        let response = RepositoriesContentsAPI().getReadmeSync(owner: owner, repo: repo)
        let readme = response.response
        if response.response != nil {
            sleep(2)
        }
        guard let readmeContent = readme?.content?.replacingOccurrences(of: "\n", with: "").base64Decoded() else {
            return [] }
        
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
        for imageUrl in imageUrls {
            guard let imageURL = URL(string: imageUrl), let data = try? Data(contentsOf: imageURL), let image = NSImage(data: data), min(image.size.width, image.size.height) > 200 else {
                let index = imageUrls.firstIndex(of: imageUrl)!
                imageUrls.remove(at: index)
                return []
            }
        }
        return imageUrls
    }
    
    static func getLocalImageUrls(from readmeString: String, owner: String, repo: String) -> [String] {
        let imageNames1 = readmeString.capturedGroups(withRegex: Constants.regex(for: "png")) + readmeString.capturedGroups(withRegex: Constants.regex(for: "jpg")) + readmeString.capturedGroups(withRegex: Constants.regex(for: "gif")) + readmeString.capturedGroups(withRegex: Constants.regex(for: "jpeg")) + readmeString.capturedGroups(withRegex: Constants.regex(for: "bmp"))
        let imageNames2 = readmeString.capturedGroups(withRegex: Constants.regex1(for: "png")) + readmeString.capturedGroups(withRegex: Constants.regex1(for: "jpg")) + readmeString.capturedGroups(withRegex: Constants.regex1(for: "gif")) + readmeString.capturedGroups(withRegex: Constants.regex1(for: "jpeg")) + readmeString.capturedGroups(withRegex: Constants.regex1(for: "bmp"))
        var imageNames = imageNames1 + imageNames2
        imageNames = imageNames.map({ $0.replacingOccurrences(of: "(", with: "") })
        imageNames = imageNames.map({ $0.replacingOccurrences(of: "\"", with: "") })
        imageNames = imageNames.filter({ $0.isURL == false })
        return imageNames.map({ "https://raw.githubusercontent.com/\(owner)/\(repo)/master/\($0)" })
    }
    
    func getLinesFromReadme() -> [String]? {
        guard let data = FileManager.default.contents(atPath: FilePaths.readme.rawValue) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        let lines = string.components(separatedBy: CharacterSet.newlines).map({ String($0) })
        return lines
    }
    
    func readmeStringFromLines(_ lines: [String]) -> String {
        var result = String.empty
        for line in lines {
            result += line + String.enter
        }
        return result
    }
}
