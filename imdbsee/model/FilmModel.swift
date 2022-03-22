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
        
        //Prepare urlString
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { 
            completionHandler(.Failure(failure: .downloadError(response: "ApiKeyError"))) 
            return }
        let reqKeyWords = withKeyword.replacingOccurrences(of: " ", with: "%20")
        var req = Constants.urlSearchMovies.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        req = req.replacingOccurrences(of: Constants.strPatternKeyWordsTitleMovie, with: reqKeyWords)
        
        download.searchVideoImdb(url: req) { 
            [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .Success(response: let responseSearchFilm):
                completionHandler(.Success(response: self.transformResultsearchToVideotoshow(resultssearch: responseSearchFilm)))
            case .Failure(failure: let error):
                print("********serachFilm>", error.localizedDescription)
                completionHandler(.Failure(failure: .downloadError(response: error.localizedDescription)))
            }
        }
        
    }
    private func transformResultsearchToVideotoshow(resultssearch: [ResultSearch]) -> [VideoToShow] {
        var listFilmToShow:[VideoToShow] = []
        resultssearch.forEach { res in
            var fts = VideoToShow()
            if let id = res.id {
                fts.id = id
            }
            if let img = res.image {
                fts.urlImg = img
            }
            if let title = res.title {
                fts.title = title
            }
            if let desc = res.description {
                fts.crews = desc
            }
            listFilmToShow.append(fts)
        }
        return listFilmToShow
    }
    public func searchOneImage(url: String, completionHandler: @escaping (ResultData) -> Void) {
        download.downloadImage(url: url) { resultData in
            switch resultData {
            case .Success(response: let data):
                completionHandler(ResultData.Success(response: data))
            case .Failure(failure: let error):
                completionHandler(ResultData.Failure(failure: error))
            }
        }
    }
}
