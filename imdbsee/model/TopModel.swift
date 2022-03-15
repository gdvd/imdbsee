//
//  TopModel.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import Foundation

enum ResultTopFilms {
    case Success(response: [FilmToShow])
    case ZeroData
    case Failure(failure: DataTopError)
}
enum DataTopError: Error {
    case downloadError(response: String)
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
        let topOpt = manageCoredata.getAllDataTop(withName: type)
        
        if let tops = topOpt {
            if let ftps = tops.topToFilmtotop {
                let listFilmToShow = transformFilmtotopToFilmtoshow(filmtotop: ftps as! Set<FilmToTop>)
                completionHandler(.Success(response: listFilmToShow))
            } else {
                let urlOpt = prepareUrlToDownloadTop(type: type)
                //downloadData(urlOpt: urlOpt)
            }
        } else {
            let urlOpt = prepareUrlToDownloadTop(type: type)
            if let url = urlOpt {
                download.downloadVideoImdb(url: url) {
                    [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .Success(response: let tblRespVideoImdb):
                        self.manageCoredata.saveTop(resp: tblRespVideoImdb, type: type)
                        let listFilmToShow:[FilmToShow] = self.transformTblrespvideoimdbToFilmtoshow(resp: tblRespVideoImdb)
                        completionHandler(.Success(response: listFilmToShow))
                    case .Failure(failure: let failure):
                        completionHandler(.Failure(failure: .downloadError(response: failure.localizedDescription)))
                    }
                }
            } else {
                //TODO: comppletionHandler with error
            }
        }
    }
    private func transformTblrespvideoimdbToFilmtoshow(resp: [ResponseVideoImdb]) -> [FilmToShow] {
        var listFilmToShow:[FilmToShow] = []
        resp.forEach({ rvi in
            var fts = FilmToShow()
            if let id = rvi.id {
                fts.id = id
                if let rank = rvi.rank {
                    fts.rank = Int16(rank)!
                }
                if let title = rvi.title {
                    fts.title = title
                }
                if let year = rvi.year {
                    fts.year = Int16(year)!
                }
                if let img = rvi.image {
                    fts.image = img
                }
                if let rating = rvi.imDbRating {
                    fts.imDbRating = Double(rating) ?? 0.0
                }
                if let ratingCount = rvi.imDbRatingCount {
                    fts.imDbRatingCount = Int32(ratingCount) ?? 0
                }
                listFilmToShow.append(fts)
            }
        }) 
        return listFilmToShow
    }
    private func saveDataTop(){ }
    private func transformFilmtotopToFilmtoshow(filmtotop: Set<FilmToTop>) -> [FilmToShow] {
        var listFilmToShow:[FilmToShow] = []
        for ftp in filmtotop {
            if let film  = ftp.ftpToFilm {
                var filmToShow = transformFilmToFilmtoshow(film: film)
                filmToShow.rank = ftp.rank
                listFilmToShow.append(filmToShow)
            }
        }
        return listFilmToShow
    }
    private func prepareUrlToDownloadTop(type: String) -> String? {
        // Select url wanted (top250Movies or top250TVs, else return)
        var url = ""
        switch type {
        case Constants.strTopFilms:
            url = Constants.urlTopMovies
        case Constants.strTopTvs:
            url = Constants.urlTopTv
        default:
            return nil
        }
        
        // Add the ApiKey to the url (if doesn't exist -> return)
        let apiKeyInDbOptional = getApiKey(keyName: Constants.nameApiKeyImdb)
        guard let apiKeyInDb = apiKeyInDbOptional, apiKeyInDbOptional != "" else { return nil }
        url = url.replacingOccurrences(of: Constants.strPatternApikey, with: apiKeyInDb)
        return url
    }
    private func transformFilmToFilmtoshow(film: Film) -> FilmToShow {
        var filmToShow = FilmToShow()
        filmToShow.id = film.idFilm!
        filmToShow.imDbRatingCount = film.ratingCount
        if let title = film.title {
            filmToShow.title = title
        }
        filmToShow.imDbRating = film.rating
        filmToShow.year = film.year
        if let img = film.urlImg {
            filmToShow.image = img
        }
        return filmToShow
    }

}
