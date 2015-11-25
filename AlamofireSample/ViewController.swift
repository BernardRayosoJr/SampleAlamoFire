//
//  ViewController.swift
//  AlamofireSample
//
//  Created by bernard on 11/24/15.
//  Copyright © 2015 Designplus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {

    var x: String = "dsadsadsa"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1"

        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            print("dsadsadas")
            
            return
        }

        
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
        })
        task.resume()
        
    
        
        // Create new post
        let postsEndpoint: String = "http://jsonplaceholder.typicode.com/posts"
        guard let postsURL = NSURL(string: postsEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let postsUrlRequest = NSMutableURLRequest(URL: postsURL)
        
        postsUrlRequest.HTTPMethod = "POST"
        
        let newPost: NSDictionary = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1]
        do {
            let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            postsUrlRequest.HTTPBody = jsonPost
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let createTask = session.dataTaskWithRequest(postsUrlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                
                // parse the result as json, since that's what the API provides
                let post = JSON(data: responseData)
                if let postID = post["id"].int {
                    print("The post ID is \(postID)")
                }
            })
            createTask.resume()
        } catch {
            print("Error: cannot create JSON from post")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

