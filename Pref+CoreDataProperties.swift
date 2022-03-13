//
//  Pref+CoreDataProperties.swift
//  imdbsee
//
//  Created by Gilles David on 13/03/2022.
//
//

import Foundation
import CoreData


extension Pref {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pref> {
        return NSFetchRequest<Pref>(entityName: "Pref")
    }

    @NSManaged public var apiKeyName: String?
    @NSManaged public var key: String?

}
