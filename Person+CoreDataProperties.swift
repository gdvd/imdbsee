//
//  Person+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 13/03/2022.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var idName: String?
    @NSManaged public var name: String?
    @NSManaged public var personToFilmtoperson: NSSet?

}

// MARK: Generated accessors for personToFilmtoperson
extension Person {

    @objc(addPersonToFilmtopersonObject:)
    @NSManaged public func addToPersonToFilmtoperson(_ value: FilmToPerson)

    @objc(removePersonToFilmtopersonObject:)
    @NSManaged public func removeFromPersonToFilmtoperson(_ value: FilmToPerson)

    @objc(addPersonToFilmtoperson:)
    @NSManaged public func addToPersonToFilmtoperson(_ values: NSSet)

    @objc(removePersonToFilmtoperson:)
    @NSManaged public func removeFromPersonToFilmtoperson(_ values: NSSet)

}
