//
//  FilmToTop+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 13/03/2022.
//
//

import Foundation
import CoreData


extension FilmToTop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmToTop> {
        return NSFetchRequest<FilmToTop>(entityName: "FilmToTop")
    }

    @NSManaged public var rank: Int16
    @NSManaged public var ftpToFilm: Film?
    @NSManaged public var ftpToTop: Top?

}
