//
//  CBMasterViewController.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit
import CoreData

class CBMasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate
{
	@IBOutlet var searchBar: UISearchBar!
	var detailViewController: CBDetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext? = nil
	var searchActive = false
	var searchString = ""
	
	override func viewDidLoad()
    {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = editButtonItem
		
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CBDetailViewController
		}
		searchBar.delegate = self
	}

	override func viewWillAppear(_ animated: Bool)
	{
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
		updateTableContent()
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		    let object = fetchedResultsController.object(at: indexPath)
		        let controller = (segue.destination as! UINavigationController).topViewController as! CBDetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
		let post = fetchedResultsController.object(at: indexPath)
		configureCell(cell, withPost: post)
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
    
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete {
		    let context = fetchedResultsController.managedObjectContext
		    context.delete(fetchedResultsController.object(at: indexPath))
		        
		    do {
		        try context.save()
		    } catch {
		        let nserror = error as NSError
		        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		    }
			performSegue(withIdentifier: "showDetail", sender: self) // for deselect DetailView
		}
	}

	// MARK: -
	
	func configureCell(_ cell: UITableViewCell, withPost post: Post)
    {

        if let cell = cell as? CBPostTableViewCell {
            cell.titleLabel.text = post.title
            let user = User.getUserWithId(post.userId)
            cell.emailLabel.text = user?.email
            cell.titleLabel.sizeToFit()
            cell.emailLabel.sizeToFit()
        }
    }

	func updateTableContent()
	{
		do {
			try fetchedResultsController.performFetch()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
		
		let service = CBAPIService()
		service.fillDataFromEndPoint("https://jsonplaceholder.typicode.com/posts/", intoCoraDataType: Post.self) { (message) in
			DispatchQueue.main.async {
				self.showAlertWith(title: "Error", message: message)
			}
		}
		
		service.fillDataFromEndPoint("https://jsonplaceholder.typicode.com/users", intoCoraDataType: User.self) { (message) in
			DispatchQueue.main.async {
				self.showAlertWith(title: "Error", message: message)
			}
		}
		
		service.fillDataFromEndPoint("https://jsonplaceholder.typicode.com/albums", intoCoraDataType: Album.self) { (message) in
			DispatchQueue.main.async {
				self.showAlertWith(title: "Error", message: message)
			}
		}
		
		service.fillDataFromEndPoint("https://jsonplaceholder.typicode.com/photos", intoCoraDataType: Photo.self) { (message) in
			DispatchQueue.main.async {
				self.showAlertWith(title: "Error", message: message)
			}
		}
	}
	
	// MARK: - Fetched results controller

	var fetchedResultsController: NSFetchedResultsController<Post>
	{
	    if _fetchedResultsController != nil {
	        return _fetchedResultsController!
	    }
	    
	    let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
	    fetchRequest.fetchBatchSize = 100
		fetchRequest.fetchLimit = 100
	    let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
	    fetchRequest.sortDescriptors = [sortDescriptor]
		if searchActive == true {
			fetchRequest.predicate = NSPredicate(format: "title contains[cd] %@", searchString)
		}
		
	    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
	    aFetchedResultsController.delegate = self
	    _fetchedResultsController = aFetchedResultsController
		CBCoreDataStack.sharedInstance.fetchedResultsController = aFetchedResultsController
	    
	    return _fetchedResultsController!
	}
	var _fetchedResultsController: NSFetchedResultsController<Post>? = nil
	
	// MARK: - NSFetchedResultsControllerDelegate
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
	    tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
	{
	    switch type {
	        case .insert:
	            tableView.insertRows(at: [newIndexPath!], with: .fade)
	        case .delete:
	            tableView.deleteRows(at: [indexPath!], with: .fade)
	        case .update:
	            configureCell(tableView.cellForRow(at: indexPath!)!, withPost: anObject as! Post)
	        case .move:
	            configureCell(tableView.cellForRow(at: indexPath!)!, withPost: anObject as! Post)
	            tableView.moveRow(at: indexPath!, to: newIndexPath!)
	    }
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
	    tableView.endUpdates()
	}

	// MARK: - show Alert
	
	func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert)
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
		let action = UIAlertAction(title: title, style: .default) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(action)
		self.present(alertController, animated: true, completion: nil)
	}
	
	// MARK: - UISearchBarDelegate

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
	{
		searchActive = searchText.count > 0
		searchString = searchText.lowercased()
		_fetchedResultsController = nil
		
		do {
			try fetchedResultsController.performFetch()
			try CBCoreDataStack.sharedInstance.persistentContainer.viewContext.save()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}

		self.tableView.reloadData()
	}
}

