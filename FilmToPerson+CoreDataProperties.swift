//
//  FilmToPerson+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 13/03/2022.
//
//

import Foundation
import CoreData


extension FilmToPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmToPerson> {
        return NSFetchRequest<FilmToPerson>(entityName: "FilmToPerson")
    }

    @NSManaged public var actor: Bool
    @NSManaged public var director: Bool
    @NSManaged public var writer: Bool
    @NSManaged public var filmtopersonToPerson: Person?
    @NSManaged public var filmtopersonToFilm: Film?

}
