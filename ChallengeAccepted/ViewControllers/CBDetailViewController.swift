//
//  CBDetailViewController.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 19.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit

class CBDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching
{
	@IBOutlet var postTitelLabel: UILabel!
	@IBOutlet var postBodyLabel: UILabel!
	@IBOutlet var albumCollectionView: UICollectionView!
	
	var items = [(title:String?, collapsed: Bool, photos:[Photo])]()
	var detailItem: Post?
	{
		didSet {
			configureView()
		}
	}

	func configureView()
	{
		if let detail = detailItem {
		    if let label = postTitelLabel {
		        label.text = detail.title
				label.sizeToFit()
		    }
			if let label = postBodyLabel {
				label.text = detail.body
				label.sizeToFit()
			}
			let albums = Album.getAlbumsWithUserId(detail.userId)
			//print("albums = ", albums)
			
			for album in albums {
				let photos = Photo.getPhotosWithAlbumId(album.id)
				//print("photos = ", photos)
				items.append((title: album.title, collapsed: true, photos: photos))
			}
		}
		else {
			if let label = postTitelLabel {
				label.text = ""
				label.sizeToFit()
			}
			if let label = postBodyLabel {
				label.text = ""
				label.sizeToFit()
			}
			items = []
		}
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()
		navigationItem.title = "Challenge Accepted!"
		albumCollectionView.delegate = self
		albumCollectionView.dataSource = self
		albumCollectionView.prefetchDataSource = self
		let layout = albumCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
		layout?.sectionHeadersPinToVisibleBounds = true

		configureView()
	}
	
	// MARK: - button Action
	
	@IBAction func expandCollapseButtonAction(_ sender: CBExpandCollapseButton)
	{
		sender.isSelected = !sender.isSelected
		items[sender.section].collapsed = !sender.isSelected
		albumCollectionView.reloadData()
	}
	
	// MARK: - UICollectionViewDataSource
	
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		let album = items[section]
		if album.collapsed == true {
			return 0
		}
		return album.photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	{
		var reusableview: UICollectionReusableView? = nil
		if kind == UICollectionElementKindSectionHeader {
			reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumCellHeader", for: indexPath)
			let labelHeader = reusableview?.viewWithTag(1) as! UILabel
			let currentAlbum = items[indexPath.section]
			labelHeader.text = currentAlbum.title
			let expandCollapseButton = reusableview?.viewWithTag(2) as! CBExpandCollapseButton
			expandCollapseButton.section = indexPath.section
			expandCollapseButton.isSelected = !currentAlbum.collapsed
		}
		return reusableview!
	}
	
	internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath as IndexPath) as! CBAlbumCollectionViewCell
		
		let currentAlbum = items[indexPath.section]
		let currentPhoto = currentAlbum.photos[indexPath.row]
		cell.thumbnailView.image = nil
		if let thumbnail = CBCaches.sharedInstance.thumbnailCache[currentPhoto.id] { // id found in cache, take chashed image
			cell.thumbnailView.image = thumbnail
		}
		else if let endPoint = currentPhoto.thumbnailUrl?.replacingOccurrences(of: "http:/", with: "https:/") { // load thumbnail
			if let url = URL(string: endPoint) {
				URLSession.shared.dataTask(with: url, completionHandler: {
					(data, response, error) -> Void in
					DispatchQueue.main.async {
						if let data = data {
							let visibleIndexPaths = self.albumCollectionView.indexPathsForVisibleItems
							if visibleIndexPaths.contains(indexPath) {
								cell.thumbnailView.image = UIImage(data: data)
							}
							CBCaches.sharedInstance.thumbnailCache[currentPhoto.id] = UIImage(data: data) //cell.thumbnailView.image
						}
					}
				}).resume()
			}
		}
		
		cell.backgroundColor = UIColor.gray
		
		return cell
	}
	
	// MARK: - UICollectionViewDataSourcePrefetching
	
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
	{
		for indexPath in indexPaths
		{
			let currentAlbum = items[indexPath.section]
			let currentPhoto = currentAlbum.photos[indexPath.row]
			
			if CBCaches.sharedInstance.thumbnailCache[currentPhoto.id] == nil { // not yet cached
				if let endPoint = currentPhoto.thumbnailUrl?.replacingOccurrences(of: "http:/", with: "https:/") { // load thumbnail
					if let url = URL(string: endPoint) {
						URLSession.shared.dataTask(with: url, completionHandler: {
							(data, response, error) -> Void in
							if let data = data {
								DispatchQueue.main.async {
									CBCaches.sharedInstance.thumbnailCache[currentPhoto.id] = UIImage(data: data)
								}
							}
						}).resume()
					}
				}
			}
		}
	}

}

