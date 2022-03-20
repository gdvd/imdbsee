//
//  FilmDetailModel.swift
//  imdbsee
//
//  Created by Gilles David on 18/03/2022.
//

import Foundation

enum ResultWiki {
    case Success(response: ResponseWiki)
    case Failure(failure: DataTopError)
}
enum ResultYoutube {
    case Success(response: ResponseYoutube)
    case Failure(failure: DataTopError)
}

class FilmDetailModel {
    
    public static let shared = FilmDetailModel()
    private init() {}
    
    private let manageCoredata = ManageCoreData.shared
    private let download = DownloadManager.shared
    
    private func getApiKey(keyName: String) -> String? {
        return manageCoredata.getOneKey(keyName: keyName)
    }
    
    public func getUrlYoutube(idTtImdb: String, language: Language, completionHandler: @escaping(ResultYoutube) -> Void ){
        
        //Prepare urlString
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { 
            completionHandler(.Failure(failure: .downloadError(response: "ApiKeyError"))) 
            return }
        var req = Constants.urlYoutube.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        req = req.replacingOccurrences(of: Constants.patternLanguage, with: language.rawValue)
        req = req.replacingOccurrences(of: Constants.patternIdVideo, with: idTtImdb)
        print("======RequestYoutube :",req)
        
        download.downloadInfoYoutube(url: req) { 
            //[weak self] 
            response in
            //guard let self = self else { return }
            
            switch response {
            case .Success(response: let resp):
                completionHandler(.Success(response: resp))
            case .Failure(failure: let err):
                completionHandler(.Failure(failure: .downloadError(response: err.localizedDescription)))
            }
        }
    }
    
    public func getInfoWiki(idTtImdb: String, language: Language, completionHandler: @escaping(ResultWiki) -> Void ){
        
        //Prepare urlString
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { 
            completionHandler(.Failure(failure: .downloadError(response: "ApiKeyError"))) 
            return }
        var req = Constants.urlWiki.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        req = req.replacingOccurrences(of: Constants.patternLanguage, with: language.rawValue)
        req = req.replacingOccurrences(of: Constants.patternIdVideo, with: idTtImdb)
        print("======RequestWiki :",req)
        
        download.downloadInfoWiki(url: req) { 
            //[weak self] 
            response in
            //guard let self = self else { return }
            
            switch response {
            case .Success(response: let resp):
                completionHandler(.Success(response: resp))
            case .Failure(failure: let err):
                completionHandler(.Failure(failure: .downloadError(response: err.localizedDescription)))
            }
        }
    }
    
}
