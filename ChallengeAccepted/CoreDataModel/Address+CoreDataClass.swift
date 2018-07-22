//
//  Address+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


public class Address: NSManagedObject
{
    private static let entityName = "Address"
	
	class func createEntityFrom(dictionary: [String: AnyObject], user: User) -> Address?
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Address {
			entity.street = dictionary["street"] as? String
			entity.suite = dictionary["suite"] as? String
			entity.city = dictionary["city"] as? String
			entity.zipcode = dictionary["zipcode"] as? String
			let geo = dictionary["geo"] as? [String: AnyObject]
			entity.latitude = NSDecimalNumber(string: geo?["lat"] as? String)
			entity.longitude = NSDecimalNumber(string: geo?["lng"] as? String)
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
