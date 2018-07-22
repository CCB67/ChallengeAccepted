//
//  CBCaches.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 21.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit

class CBCaches: NSObject
{
	static let sharedInstance = CBCaches()
	private override init() {}
	
	var thumbnailCache = [Int64 : UIImage]()
}
