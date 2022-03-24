//
//  FakeResponseData.swift
//  imdbseeTests
//
//  Created by Gilles David on 24/03/2022.
//

import Foundation
import UIKit

class FakeResponseData {
    
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200, 
                                            httpVersion: nil, 
                                            headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                     statusCode: 500, 
                                     httpVersion: nil, 
                                     headerFields: nil)!
    
    class DownloadError: Error {}    
    
    static var downloadCorrectDataWiki: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Wikipedia", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var downloadCorrectDataYoutube: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "YouTubeTrailer", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var dataImg: Data {
        let data = UIImage(named: "filmByDefault")?.pngData()
        return data!
    }
    
    static let downloadIncorrectData = "erreur".data(using: .utf8)!
}
