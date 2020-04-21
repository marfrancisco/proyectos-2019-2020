//
//  Day+CoreDataProperties.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 14/04/2019.
//  Copyright © 2019 Jacobo Diego Pita Hernandez. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var coments: String?
    @NSManaged public var dateRecord: NSDate?
    @NSManaged public var photoAdd: NSData?
    @NSManaged public var rating: Int16
    @NSManaged public var saveWithCrono: Bool
    @NSManaged public var totalTimer: String?
    @NSManaged public var task: Task?

}
