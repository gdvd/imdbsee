//
//  Top+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 15/03/2022.
//
//

import Foundation
import CoreData


extension Top {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Top> {
        return NSFetchRequest<Top>(entityName: "Top")
    }

    @NSManaged public var dateModif: Date?
    @NSManaged public var name: String?
    @NSManaged public var topToFilmtotop: NSSet?

}

// MARK: Generated accessors for topToFilmtotop
extension Top {

    @objc(addTopToFilmtotopObject:)
    @NSManaged public func addToTopToFilmtotop(_ value: FilmToTop)

    @objc(removeTopToFilmtotopObject:)
    @NSManaged public func removeFromTopToFilmtotop(_ value: FilmToTop)

    @objc(addTopToFilmtotop:)
    @NSManaged public func addToTopToFilmtotop(_ values: NSSet)

    @objc(removeTopToFilmtotop:)
    @NSManaged public func removeFromTopToFilmtotop(_ values: NSSet)

}
