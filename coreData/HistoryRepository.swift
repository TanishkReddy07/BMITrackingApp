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
    
    
    
    func addBMI(bmi: Double,height: Double, weight: Double, date: Date) async -> History? {
        let newRecord = History(context: context)
        newRecord.setValue(bmi, forKey: #keyPath(History.bmi))
        newRecord.setValue(weight, forKey: #keyPath(History.weight))
        newRecord.setValue(date, forKey: #keyPath(History.date))
        newRecord.setValue(height, forKey: #keyPath(History.height))
        await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        
        return newRecord
    }
    
    func updateBMI(history: History, weight: Double, bmi: Double) async {
        history.weight = weight
        history.bmi = bmi
        await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        
    }
    
    // delete a BMI
    func deleteBMI(object: History) async throws -> History? {
        do {
            
            
            context.delete(object)
            
            try context.save()
            return object
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            fatalError()
        }
        
    }
}
