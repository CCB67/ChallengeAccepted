//
//  Fillable.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 20.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import Foundation

protocol Fillable
{
    static func saveInCoreDataWith(array: [[String: AnyObject]])
	static func deleteAll()
}

