//
//  User+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


public class User: NSManagedObject, Fillable
{
    private static let entityName = "User"
    
	class func createEntityFrom(dictionary: [String: AnyObject])
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? User {
			if let id = dictionary["id"] as? Int64 {
				entity.id = id
			}
			entity.name = dictionary["name"] as? String
			entity.username = dictionary["username"] as? String
			entity.email = dictionary["email"] as? String
			entity.phone = dictionary["phone"] as? String
			entity.website = dictionary["website"] as? String
			
			if let addressDictionary = dictionary["address"] as? [String: AnyObject] {
				entity.address = Address.createEntityFrom(dictionary: addressDictionary, user: entity)
			}
			if let companyDictionary = dictionary["company"] as? [String: AnyObject] {
				entity.company = Company.createEntityFrom(dictionary: companyDictionary, user: entity)
			}
		}
	}
	
	static func saveInCoreDataWith(array: [[String: AnyObject]])
	{
		for item in array {
			createEntityFrom(dictionary: item)
		}
		do {
			try CBCoreDataStack.sharedInstance.persistentContainer.viewContext.save()
		} catch let error {
			fatalError("Unresolved error \(error.localizedDescription)")
		}
	}
    
    class func getUserWithId(_ id: Int64) -> User?
    {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %ld", id)
        
        var users = [User]()
        do {
            users = try CBCoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            fatalError("Unresolved error \(error.localizedDescription)")
        }
        if users.count > 0 {
            return users.first
        }
        else {
            return nil
        }
    }
    
	static func deleteAll()
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		do {
			guard let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
				else {
					return
			}
			for object in objects {
				context.delete(object)
			}
			CBCoreDataStack.sharedInstance.saveContext()
		} catch let error {
			fatalError("Unresolved error \(error.localizedDescription)")
		}
	}
}
