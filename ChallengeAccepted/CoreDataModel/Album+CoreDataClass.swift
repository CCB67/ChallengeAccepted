//
//  Album+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData

public class Album: NSManagedObject, Fillable
{
    private static let entityName = "Album"
    
	class func createEntityFrom(dictionary: [String: AnyObject])
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Album {
			if let id = dictionary["id"] as? Int64 {
				entity.id = id
			}
			if let userId = dictionary["userId"] as? Int64 {
				entity.userId = userId
			}
			entity.title = dictionary["title"] as? String
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
	
	class func getAlbumsWithUserId(_ userId: Int64) -> [Album]
	{
		let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "userId = %ld", userId)
		
		var albums = [Album]()
		do {
			albums = try CBCoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest)
		} catch let error {
			fatalError("Unresolved error \(error.localizedDescription)")
		}
		return albums
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
