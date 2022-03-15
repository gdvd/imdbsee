//
//  Film+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 15/03/2022.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var idFilm: String?
    @NSManaged public var rating: Double
    @NSManaged public var ratingCount: Int32
    @NSManaged public var title: String?
    @NSManaged public var urlImg: String?
    @NSManaged public var year: Int16
    @NSManaged public var crews: String?
    @NSManaged public var filmToFilmtotop: NSSet?
    @NSManaged public var idfilmToFilmtoperson: NSSet?

}

// MARK: Generated accessors for filmToFilmtotop
extension Film {

    @objc(addFilmToFilmtotopObject:)
    @NSManaged public func addToFilmToFilmtotop(_ value: FilmToTop)

    @objc(removeFilmToFilmtotopObject:)
    @NSManaged public func removeFromFilmToFilmtotop(_ value: FilmToTop)

    @objc(addFilmToFilmtotop:)
    @NSManaged public func addToFilmToFilmtotop(_ values: NSSet)

    @objc(removeFilmToFilmtotop:)
    @NSManaged public func removeFromFilmToFilmtotop(_ values: NSSet)

}

// MARK: Generated accessors for idfilmToFilmtoperson
extension Film {

    @objc(addIdfilmToFilmtopersonObject:)
    @NSManaged public func addToIdfilmToFilmtoperson(_ value: FilmToPerson)

    @objc(removeIdfilmToFilmtopersonObject:)
    @NSManaged public func removeFromIdfilmToFilmtoperson(_ value: FilmToPerson)

    @objc(addIdfilmToFilmtoperson:)
    @NSManaged public func addToIdfilmToFilmtoperson(_ values: NSSet)

    @objc(removeIdfilmToFilmtoperson:)
    @NSManaged public func removeFromIdfilmToFilmtoperson(_ values: NSSet)

}
