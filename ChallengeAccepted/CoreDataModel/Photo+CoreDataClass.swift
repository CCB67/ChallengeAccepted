//
//  Photo+CoreDataClass.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


public class Photo: NSManagedObject, Fillable
{
    private static let entityName = "Photo"
    
	class func createEntityFrom(dictionary: [String: AnyObject])
	{
		let context = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		if let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Photo {
			if let id = dictionary["id"] as? Int64 {
				entity.id = id
			}
			if let albumId = dictionary["albumId"] as? Int64 {
				entity.albumId = albumId
			}
			entity.title = dictionary["title"] as? String
			entity.url = dictionary["url"] as? String
			entity.thumbnailUrl = dictionary["thumbnailUrl"] as? String
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
	
	class func getPhotosWithAlbumId(_ albumId: Int64) -> [Photo]
	{
		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "albumId = %ld", albumId)
		
		var photos = [Photo]()
		do {
			photos = try CBCoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest)
		} catch let error {
			fatalError("Unresolved error \(error.localizedDescription)")
		}
		return photos
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
