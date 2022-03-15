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
