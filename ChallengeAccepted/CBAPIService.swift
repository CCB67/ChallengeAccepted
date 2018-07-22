//
//  CBAPIService.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit

enum Result <T>
{
	case Success(T)
	case Error(String)
}

class CBAPIService: NSObject
{
	func getDataFromEndPoint(_ endPoint: String,completion: @escaping (Result<[AnyObject]>) -> Void)
	{
		guard let url = URL(string: endPoint) else { return completion(.Error("Invalid URL")) }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard error == nil else { return }
			guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show")) }
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [AnyObject] {
					DispatchQueue.main.async {
						completion(.Success(json))
					}
				}
				else {
					completion(.Error("can't serialize JSON"))
				}
			} catch let error {
				completion(.Error(error.localizedDescription))
			}
			}.resume()
	}
	
	func fillDataFromEndPoint<T: Fillable>(_ endPoint: String, intoCoraDataType coraDataType: T.Type, completion: @escaping (String) -> Void)
	{
		getDataFromEndPoint(endPoint) { (result) in
			switch result {
			case .Success(let data):
				coraDataType.deleteAll()
				coraDataType.saveInCoreDataWith(array: data as! [[String : AnyObject]])
			case .Error(let message):
                completion(String(describing:T.self) + " : " + message)
			}
		}
	}

}
