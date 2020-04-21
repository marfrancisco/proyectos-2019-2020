//
//  Task+CoreDataProperties.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 14/04/2019.
//  Copyright © 2019 Jacobo Diego Pita Hernandez. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var checkPoint: String?
    @NSManaged public var createDate: NSDate?
    @NSManaged public var dateFinishCount: NSDate?
    @NSManaged public var idTask: String?
    @NSManaged public var name: String?
    @NSManaged public var opcFinishCount: Bool
    @NSManaged public var opcShowPhotoInDays: Bool
    @NSManaged public var stateDashboard: Int16
    @NSManaged public var timerActive: Bool
    @NSManaged public var useDate: NSDate?
    @NSManaged public var days: NSOrderedSet?

}

// MARK: Generated accessors for days
extension Task {

    @objc(insertObject:inDaysAtIndex:)
    @NSManaged public func insertIntoDays(_ value: Day, at idx: Int)

    @objc(removeObjectFromDaysAtIndex:)
    @NSManaged public func removeFromDays(at idx: Int)

    @objc(insertDays:atIndexes:)
    @NSManaged public func insertIntoDays(_ values: [Day], at indexes: NSIndexSet)

    @objc(removeDaysAtIndexes:)
    @NSManaged public func removeFromDays(at indexes: NSIndexSet)

    @objc(replaceObjectInDaysAtIndex:withObject:)
    @NSManaged public func replaceDays(at idx: Int, with value: Day)

    @objc(replaceDaysAtIndexes:withDays:)
    @NSManaged public func replaceDays(at indexes: NSIndexSet, with values: [Day])

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSOrderedSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSOrderedSet)

}
