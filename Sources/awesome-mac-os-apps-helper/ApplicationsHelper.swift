//
//  Applications.swift
//  awesome-mac-os-apps-helperPackageDescription
//
//  Created by Serhii Londar on 12/5/18.
//

import Foundation

class ApplicationsHelper {
	func removeLanguageDuplications() {
		guard let applicationsData = try? Data(contentsOf: URL(fileURLWithPath: FilePaths.applications.rawValue)) else { return }
		let jsonDecoder = JSONDecoder()
		guard let applicationsObject = try? jsonDecoder.decode(JSONApplications.self, from: applicationsData) else { return }
		applicationsObject.applications.forEach { (application) in
			application.languages = [String](Set(application.languages))
		}
		
		let jsonEncoder = JSONEncoder()
		jsonEncoder.outputFormatting = .prettyPrinted
		guard let data = try? jsonEncoder.encode(applicationsObject) else { return }
		
		let string = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
		try? string?.write(to: URL(fileURLWithPath: FilePaths.applications.rawValue), atomically: true, encoding: .utf8)
	}
}
