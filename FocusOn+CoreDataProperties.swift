//
//  FocusOn+CoreDataProperties.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 03/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//
//

import Foundation
import CoreData


extension FocusOn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusOn> {
        return NSFetchRequest<FocusOn>(entityName: "FocusOn")
    }

    @NSManaged public var achieved: Bool
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var type: String?

}
