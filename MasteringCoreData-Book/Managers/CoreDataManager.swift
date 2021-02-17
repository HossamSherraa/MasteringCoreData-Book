//
//  CoreDataManager.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 17/02/2021.
//

import CoreData
class CoreDataManager{
    static var context : NSManagedObjectContext {
        self.shared.container.viewContext
    }
    
    private static var shared = CoreDataManager()
    
    
   private let container = NSPersistentContainer(name: "Notes")
    
    init() {
        container.loadPersistentStores { (_, error) in
            
        }
    }
    
}
