//
//  Address+CoreDataProperties.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//
//

import Foundation
import CoreData


extension Address
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var latitude: NSDecimalNumber?
    @NSManaged public var longitude: NSDecimalNumber?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var user: User?

}
