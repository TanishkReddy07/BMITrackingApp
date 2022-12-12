//
//  HistoryRepository.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import Foundation
import CoreData

class HistoryRepository {
    
    static let shared = HistoryRepository()
    
    private init () {}
    
    let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    func getAllHistory() async throws->  [History] {
        let historyFetch: NSFetchRequest<History> = History.fetchRequest()
        
        do {
            let results = try context.fetch(historyFetch)
            var history: [History] = []
            for result in results {
                history.append(result)
            }
            return history
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            fatalError()
        }
        
    }
    
    
    
    func addcar(bmi: Double, weight: Double, date: Date) async -> History? {
        let newRecord = History(context: context)
        newRecord.setValue(bmi, forKey: #keyPath(History.bmi))
        newRecord.setValue(weight, forKey: #keyPath(History.weight))
        newRecord.setValue(date, forKey: #keyPath(History.date))
        
        await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        
        return newRecord
    }
}
