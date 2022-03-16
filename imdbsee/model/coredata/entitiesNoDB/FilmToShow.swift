//
//  FilmToShow.swift
//  imdbsee
//
//  Created by Gilles David on 14/03/2022.
//

import Foundation

struct FilmToShow {
    var id: String = ""
    var rank: Int16 = 0
    var title: String = ""
    var year: Int16 = 0
    var image: String = ""
    var imDbRating: Double = 0.0
    var imDbRatingCount: Int32 = 0
    var crews: String = ""
    var urlImg: String = ""
    var dataImg: Data?
}
