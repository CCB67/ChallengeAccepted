//
//  Post+CoreDataProperties.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


extension Post
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

	@NSManaged public var id: Int64
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var userId: Int64

}
