//
//  Album+CoreDataProperties.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


extension Album
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

	@NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var userId: Int64

}
