//
//  WebRequest.swift
//  COTD
//
//  Created by Nick Lanasa on 05/27/15.
//  Copyright (c) 2014 Nytek Productions. All rights reserved.
//

import Foundation
import UIKit

let _shared = GoogleImageSearchRequest()

class GoogleImageSearchRequest: NSObject {
    private var baseURL = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0"
    
    private var currentURL: NSURL!
    
    // Singleton
    class var shared : GoogleImageSearchRequest {
        return _shared
    }
    
    func search(searchTerm: String?, completion: (imageData: [String : AnyObject]?, error: NSError?) -> ()) {
        if let term = searchTerm {
            if count(term) > 0 {
                var escapedURLString = (self.baseURL + "&q=\(term)").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                if let url = NSURL(string: escapedURLString!) {
                    
                    self.currentURL = url
                    
                    self.performRequest(url, completion: { (imageData, error) -> () in
                        completion(imageData: imageData, error: error)
                    })
                } else {
                    completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                }
            } else {
                completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
            }
        } else {
            completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
        }
    }
    
    private func performRequest(url: NSURL, completion: (imageData: [String : AnyObject]?, error: NSError?) -> ()) {
        var request = NSURLRequest(URL: url)
        var queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request,
            queue: queue,
            completionHandler: { (response, data, error) -> Void in
                if error != nil {
                    completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                } else {
                    if data != nil {
                        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
                            if let responseData = json["responseData"] as? [String : AnyObject] {
                                if let images = responseData["results"] as? [[String : AnyObject]] {
                                    var image: [String : AnyObject]?
                                    
                                    for imageData in images {
                                        if let imageId = imageData["imageId"] as? String {
                                            if NSUserDefaults.standardUserDefaults().objectForKey(imageId) == nil {
                                                image = imageData
                                                break
                                            }
                                        }
                                    }
                                    
                                    completion(imageData: image, error: nil)
                                } else {
                                    completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                                }
                            } else {
                                completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                            }
                        } else {
                            completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                        }
                    } else {
                        completion(imageData: nil, error: NSError(domain: "ajax.googleapis.com", code: -1, userInfo: nil))
                    }
                }
        })
    }
    
}