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

let ENTITY_NAME: String = "Entity"

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: ENTITY_NAME);
    }

    @NSManaged public var attr1: String?
    
    public class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    public class func getFetchedResults() -> NSArray {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            
            return ManagedParser.convertToArray(managedObjects: searchResults as NSArray?)
        } catch {
            print("Error with request: \(error)")
        }
        
        return []
    }
    
    public class func saveContext(saveText : String) -> String {
        
        // Save Core Data
        let context = Entity.getContext()
        let entityMain =  NSEntityDescription.entity(forEntityName: ENTITY_NAME, in: context)
        let transc = NSManagedObject(entity: entityMain!, insertInto: context)
        
        //set the entity values
        transc.setValue( saveText, forKey: "attr1")
        
        do {
            //save data
            try context.save()
            return "success"
        }catch let error as NSError {
            print ("faild! \(error.localizedFailureReason)")
            return "failed"
        }
    }
}
