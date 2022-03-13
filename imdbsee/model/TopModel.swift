//
//  TopModel.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import Foundation

enum ResultTopFilms {
    case Success(response: Top)
    case ZeroData
    case Failure(failure: RequestError)
}

class TopModel {
    
    public static let shared = TopModel()
    private init() {}
    
    private let manageCoredata = ManageCoreData.shared
    private let download = Download.shared
    
    private func getApiKey(keyName: String) -> String? {
        return manageCoredata.getOneKey(keyName: keyName)
    }
    public func loadListTops(type: String, completionHandler: @escaping(ResultTopFilms) -> Void ){
        
        print("loadListTopFilms")
                
        // Select url wanted (top250Movies or top250TVs, else return)
        var url = ""
        switch type {
        case Constants.strTopFilms:
            url = Constants.urlTopMovies
        case Constants.strTopTvs:
            url = Constants.urlTopTv
        default:
            return
        }
        
        // Add the ApiKey to the url (if doesn't exist -> return)
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { return }
        url = url.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        
        // Download data
        download.downloadVideoImdb(url: url) { 
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .Success(response: let resp):
                if resp.count > 0 {
                    if self.manageCoredata.saveDataTop(resp: resp, type: type) {
                        
                        ////////////
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { 
                        
                        let topOpt = self.manageCoredata.getAllDataTop(withName: type)
                        if let top = topOpt {
                            completionHandler(.Success(response: top))
                        } else {
                            completionHandler(.ZeroData)
                        }
                        
                        ////////////
                        })
                        
                    }
                    //TODO: Next
                    //completionHandler(.Success(response: ))
                    
                } else {
                    //TODO: Next
                    completionHandler(.ZeroData)
                }
            case .Failure(failure: let error):
                //TODO: Next
                print("error", error.localizedDescription)
                //completionHandler(.Failure(failure: error))
            }
        }
    }

    
//    public func loadListTopTvs(){
//        print("loadListTopTvs")
//    }
}
