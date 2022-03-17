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
    static let urlYoutube = "https://imdb-api.com/API/YouTube?apiKey={apiKeyImdb}v={idVideo}"
    static let patternIdVideoYoutube = "{idVideo}"
    
    // Search
    static let urlSearchMovies = "https://imdb-api.com/en/API/SearchMovie/{apiKeyImdb}/{keyWordsTitleMovie}"
    static let strPatternKeyWordsTitleMovie = "{keyWordsTitleMovie}"
    
    // Static name
    static let nameApiKeyImdb = "keyImdb"
    static let strTopFilms = "topFilms"
    static let strTopTvs = "topTvs"
    
    // Text
    static let txtEdit = "Edit"    
    static let txtSave = "Save"
    
    // https://imdb-api.com/API/YouTube?apiKey=k_faxfi11b&v=8hP9D6kZseM
}
