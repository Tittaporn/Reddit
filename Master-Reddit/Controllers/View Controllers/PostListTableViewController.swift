//
//  PostListTableViewController.swift
//  Master-Reddit
//
//  Created by Cameron Stuart on 1/27/21.
//  Copyright © 2021 Cameron Stuart. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var posts: [Post] = []
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
    }
    
    // MARK: - Helper Fuctions
    func fetchPost() {
        PostController.fetchPosts { (result) in
            // Call it in the main thread Using DispatchQueue.main.async because UIView UITableView to reload data
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    // Assign our posts we get to the posts S.O.T.
                    self.posts = posts
                    // DO NOT FORGET TO RELOADATA()
                    self.tableView.reloadData()
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        cell.post = post
        
        return cell
    }
}
