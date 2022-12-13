//
//  PersonRespository.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import Foundation
import CoreData

class PersonRespository {
    
    static let shared = PersonRespository()
    
    private init () {}
    
    let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    func getPerson() async throws->  Person? {
        let personFetch: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let results = try context.fetch(personFetch)
            return results.first
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            fatalError()
        }
        
    }
    
    
    
    func addPerson(name: String, age: Int, gender: String, weight: Double, height: Double) async -> Person? {
        
        let personFetch: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let results = try context.fetch(personFetch)
            if results.first == nil {
                let newRecord = Person(context: context)
                newRecord.setValue(name, forKey: #keyPath(Person.name))
                newRecord.setValue(age, forKey: #keyPath(Person.age))
                newRecord.setValue(gender, forKey: #keyPath(Person.gender))
                newRecord.setValue(weight, forKey: #keyPath(Person.weight))
                newRecord.setValue(height, forKey: #keyPath(Person.height))
                
                await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
                
                return newRecord
            } else {
                results.first?.name = name
                results.first?.age = Int64(age)
                results.first?.gender = gender
                results.first?.weight = weight
                results.first?.height = height
                await AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
                
                return results.first!
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            fatalError()
        }
        
        
    }
}
