//
//  PostController.swift
//  Master-Reddit
//
//  Created by Lee McCormick on 1/27/21.
//  Copyright © 2021 Cameron Stuart. All rights reserved.
//

import UIKit

class PostController {
    
    // https://www.reddit.com/r/funny.json
    static let baseURL = URL(string: "https://www.reddit.com")
    
    // `/ === component`
    static let redditEndpoint = "r"
    static let funnyComponent = "funny"
    
    // `. === extension`
    static let jsonExtension = "json"
    
    static func fetchPosts(completion: @escaping (Result<[Post],PostError>) -> Void) {
        // 1) URL
        // in order to access baseURL in static function, baseURL needed to be static as well.
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        // https://www.reddit.com
        let redditURL = baseURL.appendingPathComponent(redditEndpoint)
        // https://www.reddit.com/r
        let funnyURL = redditURL.appendingPathComponent(funnyComponent)
        // https://www.reddit.com/r/funny
        
        let finalURL = funnyURL.appendingPathExtension(jsonExtension)
        // https://www.reddit.com/r/funny.json
        
        print(finalURL)
        
        // 2) Connect to Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3) Handler Error
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            // 4) Make sure if you have data, gurad let == make sure
            guard let data = data else { return completion(.failure(.noData))}
            
            // 5) Decode data
            do {
                // Always decode from the topLevelOject down >>>>> SecondeLevelObject >> Thired LevelObject >> Post
                // Once we get to the topLevelObject we can access all the below level object.
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                //let posts = topLevelObject.data.children
                
                // Create S.O.T.
                var posts: [Post] = []
                for object in topLevelObject.data.children {
                    // Get Post of each object
                    let post = object.data
                    posts.append(post) // and append to posts
                }
                completion(.success(posts))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchThumbnail(for post: Post, completion: @escaping (Result<UIImage,PostError>) -> Void) {
        
        guard let url = URL(string: post.thumbnail) else { return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            // decode the image to our image.
            guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            completion(.success(thumbnail))
        }.resume()
    }
}
