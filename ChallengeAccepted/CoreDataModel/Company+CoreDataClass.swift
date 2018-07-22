//
//  Company+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


public class Company: NSManagedObject
{
    private static let entityName = "Company"
	
	class func createEntityFrom(dictionary: [String: AnyObject], user: User) -> Company?
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Company {
			entity.name = dictionary["name"] as? String
			entity.catchPhrase = dictionary["catchPhrase"] as? String
			entity.bs = dictionary["bs"] as? String
			entity.user = user
			return entity
		}
		return nil
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
