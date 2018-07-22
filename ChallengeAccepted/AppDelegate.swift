//
//  AppDelegate.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
	var window: UIWindow?
	var masterVC: CBMasterViewController?
	var updateTableContentAfterBecomeActive = false
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = self

		let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
		masterVC = masterNavigationController.topViewController as? CBMasterViewController
		masterVC?.managedObjectContext = CBCoreDataStack.sharedInstance.persistentContainer.viewContext
		
		if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
			print(url.absoluteString)
		}
		return true
	}

	func applicationWillResignActive(_ application: UIApplication)
	{
		updateTableContentAfterBecomeActive = true
	}

	func applicationDidBecomeActive(_ application: UIApplication)
	{
		if updateTableContentAfterBecomeActive == true {
			masterVC?.updateTableContent()
		}
	}
	
	func applicationWillTerminate(_ application: UIApplication)
	{
		CBCoreDataStack.sharedInstance.saveContext()
	}

	// MARK: - Split view

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool
	{
	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
	    guard let topAsDetailController = secondaryAsNavController.topViewController as? CBDetailViewController else { return false }
	    if topAsDetailController.detailItem == nil {
	        return true
	    }
	    return false
	}

}

