//
//  PostTableViewCell.swift
//  Master-Reddit
//
//  Created by Cameron Stuart on 4/28/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var postCellImageView: UIImageView!
    @IBOutlet weak var postCellTitleLabel: UILabel!
    @IBOutlet weak var postCellUPSLabel: UILabel!
    
    // MARK: - Properties
    var post: Post? {
        // When the post is changing then the updateViews run. didSet is observing it.
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Override function
    // Prepare to reuse before the the cell appear, if no imamge using the default image.
    override func prepareForReuse() {
        postCellImageView.image = UIImage(named: "imageNotAvailable")
    }
    
    // MARK: - Helper Fuctions
    func updateViews() {
        guard let post = post else { return }
        postCellTitleLabel.text = post.title
        postCellUPSLabel.text = "👍 \(post.ups)"
        // This thumbnail is for image.
        // print(post.title)
        PostController.fetchThumbnail(for: post) { (result) in
            switch result {
            case .success(let thumbnail):
                // Dispatch here to deal with UIImage
                DispatchQueue.main.async {
                    self.postCellImageView.image = thumbnail
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}
