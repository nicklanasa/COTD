//
//  LikedCollectionViewController.swift
//  COTD
//
//  Created by Nick Lanasa on 5/27/15.
//
//

import Foundation
import UIKit

class LikedCollectionViewController: UICollectionViewController {
    
    var images: [AnyObject]? {
        get {
            if let likedData = NSUserDefaults.standardUserDefaults().objectForKey("liked") as? NSData {
                if let likedImages = NSKeyedUnarchiver.unarchiveObjectWithData(likedData) as? [AnyObject] {
                    return likedImages
                }
            }
            return nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("LikedCollectionViewCell", forIndexPath: indexPath) as! LikedCollectionViewCell
        
        var imageData = self.images?[indexPath.row] as! [String:AnyObject]
        var stringURL = imageData["url"] as! String
        var imageURL = NSURL(string: stringURL)!
        cell.imageView.sd_setImageWithURL(imageURL)
        
        return cell
    }
}