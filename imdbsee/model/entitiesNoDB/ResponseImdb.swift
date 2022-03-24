//
//  ResponseVideoImdb.swift
//  imdbsee
//
//  Created by Gilles David on 11/03/2022.
//

import Foundation

struct ResponseItemVideoImdb: Codable {
    var items: [ResponseVideoImdb]
}
struct ResponseVideoImdb: Codable {
    var id: String?
    var rank: String?
    var title: String?
    var year: String?
    var image: String?
    var crew: String?
    var imDbRating: String?
    var imDbRatingCount: String?
    
}

struct ResponseSearch: Codable {
    var searchType: String?
    var expression: String?
    var results: [ResultSearch]?
    var errorMessage: String?
}
struct ResultSearch: Codable {
    var id: String?
    var resultType: String?
    var image: String?
    var title: String?
    var description: String?
}

struct ResponseWiki: Codable {
    var imDbId: String?
    var title: String?
    var fullTitle: String?
    var type: String?
    var year: String?
    var language: String?
    var titleInLanguage: String?
    var url: String?
    var plotShort: PlotWiki?
    var plotFull: PlotWiki?
}
struct PlotWiki: Codable {
    var plainText: String?
}
struct ResponseYoutube: Codable {
    var imDbId: String?
    var title: String?
    var fullTitle: String?
    var type: String?
    var year: String?
    var videoId: String?
    var videoUrl: String?
    var errorMessage: String?
}
struct ResponseFullcast: Codable {
    var imDbId: String?
    var title: String?
    var fullTitle: String?
    var type: String?
    var year: String?
    var directors: ResponseDirectorsItems?
    var writers: ResponseWritersItems?
    var actors: [ResponsePerson]?
    var errorMessage: String?
}
struct ResponseDirectorsItems: Codable {
    var items: [ResponsePerson]?
}
struct ResponseWritersItems: Codable {
    var items: [ResponsePerson]?
}
struct ResponsePerson: Codable {
    var id: String?
    var name: String?
    var image: String?
}
