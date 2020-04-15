//
//  PeriodData.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 4/14/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class PeriodData {
    static func retrieveItems(item: String)  -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:item)
        var fetchedResults:[NSManagedObject]? = nil
        let user =  Auth.auth().currentUser
        
        if ((user) != nil) {
            let predicate = NSPredicate(format: "userID == %@", user!.uid)
            request.predicate = predicate
            do {
                try fetchedResults = context.fetch(request) as? [NSManagedObject]
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            return(fetchedResults)!
        } else {
          return []
        }
    }
}

