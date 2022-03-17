//
//  SearchModel.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import Foundation

enum ResultFilm {
    case Success(response: [VideoToShow])
    case ZeroData
    case Failure(failure: DataTopError)
}

class FilmModel {
    
    public static let shared = FilmModel()
    private init() {}
    
    private let manageCoredata = ManageCoreData.shared
    private let download = DownloadManager.shared
    
    private func getApiKey(keyName: String) -> String? {
        return manageCoredata.getOneKey(keyName: keyName)
    }
    
    public func serachFilm(withKeyword: String, completionHandler: @escaping(ResultFilm) -> Void){
        
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { return }
        
        let reqKeyWords = withKeyword.replacingOccurrences(of: " ", with: "+")
        var req = Constants.urlSearchMovies.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        req = req.replacingOccurrences(of: Constants.strPatternKeyWordsTitleMovie, with: reqKeyWords)
        print("Request :",req)
    }
    
}
