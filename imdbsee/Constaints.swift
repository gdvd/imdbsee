//
//  Constaints.swift
//  imdbsee
//
//  Created by Gilles David on 07/03/2022.
//

import Foundation

enum Constants {
    // Top
    static let urlTopMovies = "https://imdb-api.com/fr/API/Top250Movies/{apiKeyImdb}"
    static let urlTopTv = "https://imdb-api.com/fr/API/Top250TVs/{apiKeyImdb}"
    
    static let strPatternApikey = "{apiKeyImdb}"
    
    // Youtube
    static let urlYoutube = "https://imdb-api.com/{language}/API/YouTubeTrailer/{apiKeyImdb}/{idVideo}"
    static let patternIdVideo = "{idVideo}"
    
    // Wikipedia
    static let urlWiki = "https://imdb-api.com/{language}/API/Wikipedia/{apiKeyImdb}/{idVideo}"
    static let patternLanguage = "{language}"
    
    // IMDB.com
    static let urlImdbWithTitle = "https://www.imdb.com/title/"
    
    // Search
    static let urlSearchMovies = "https://imdb-api.com/en/API/SearchMovie/{apiKeyImdb}/{keyWordsTitleMovie}"
    static let strPatternKeyWordsTitleMovie = "{keyWordsTitleMovie}"
    
    // FullCast
    static let urlFullcast = "https://imdb-api.com/en/API/FullCast/{apiKeyImdb}/{idVideo}"
    
    // Static name
    static let nameApiKeyImdb = "keyImdb"
    static let strTopFilms = "topFilms"
    static let strTopTvs = "topTvs"
    
    // Text
    static let txtEdit = "Edit"    
    static let txtSave = "Save"
    
    
}
enum Language: String {
    case Fr = "fr"
    case En = "en"
}
