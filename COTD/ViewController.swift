//
//  ViewController.swift
//  COTD
//
//  Created by Nick Lanasa on 5/27/15.
//  Copyright (c) 2015 Siteworx. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var serachBar: UISearchBar!
    
    private var currentImageData: [String : AnyObject]?
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if count(searchBar.text) > 0 {
            GoogleImageSearchRequest.shared.search("capybara \(searchBar.text)", completion: { (imageData, error) -> () in
                if imageData != nil {
                    self.currentImageData = imageData
                    
                    var stringURL = imageData?["url"] as! String
                    var imageURL = NSURL(string: stringURL)!
                    self.imageView.sd_setImageWithURL(imageURL)
                    
                    NSUserDefaults.standardUserDefaults().setObject(true,
                        forKey: imageData?["imageId"] as! String)
                } else {
                    UIAlertView(title: "Error!",
                        message: nil,
                        delegate: self,
                        cancelButtonTitle: "Ok").show()
                }
            })
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        if currentImageData != nil {
            
            var liked = NSMutableArray()
            
            if let likedData = NSUserDefaults.standardUserDefaults().objectForKey("liked") as? NSData {
                if let likedImages = NSKeyedUnarchiver.unarchiveObjectWithData(likedData) as? [AnyObject] {
                    var imageId = self.currentImageData?["imageId"] as! String
                    for likedImage in likedImages as! [[String : AnyObject]] {
                        if let likedImageId =  likedImage["imageId"] as? String {
                            if imageId == likedImageId {
                                return
                            }
                        }
                    }
                    
                    liked = NSMutableArray(array: likedImages)
                    
                    liked.addObject(self.currentImageData!)
                }
            } else {
                liked.addObject(self.currentImageData!)
            }
            
            let likedData = NSKeyedArchiver.archivedDataWithRootObject(liked)
            NSUserDefaults.standardUserDefaults().setObject(likedData, forKey: "liked")
            
            UIAlertView(title: "Liked!", message: nil, delegate: self, cancelButtonTitle: "Ok").show()
        } else {
            UIAlertView(title: "Error!", message: "Unable to like", delegate: self, cancelButtonTitle: "Ok").show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleImageSearchRequest.shared.search("capybara", completion: { (imageData, error) -> () in
            if imageData != nil {
                self.currentImageData = imageData
                
                var stringURL = imageData?["url"] as! String
                var imageURL = NSURL(string: stringURL)!
                self.imageView.sd_setImageWithURL(imageURL)
                
                NSUserDefaults.standardUserDefaults().setObject(true,
                    forKey: imageData?["imageId"] as! String)
            } else {
                UIAlertView(title: "Error!",
                    message: nil,
                    delegate: self,
                    cancelButtonTitle: "Ok").show()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

