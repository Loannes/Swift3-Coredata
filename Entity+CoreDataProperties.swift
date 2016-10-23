//
//  Entity+CoreDataProperties.swift
//  swift3-coredata
//
//  Created by Loannes on 2016. 10. 16..
//  Copyright © 2016년 Loannes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity");
    }

    @NSManaged public var attr1: String?
}
