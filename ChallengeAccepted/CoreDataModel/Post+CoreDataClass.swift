//
//  Post+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData

public class Post: NSManagedObject, Fillable
{
    private static let entityName = "Post"
    
	class func createEntityFrom(dictionary: [String: AnyObject])
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Post {
			if let id = dictionary["id"] as? Int64 {
				entity.id = id
			}
			if let userId = dictionary["userId"] as? Int64 {
				entity.userId = userId
			}
			entity.title = dictionary["title"] as? String
			entity.body = dictionary["body"] as? String
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
