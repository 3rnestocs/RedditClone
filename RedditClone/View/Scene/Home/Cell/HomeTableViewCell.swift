//
//  HomeTableViewCell.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    // MARK: - Constant
    static let cellIdentifier = String(describing: HomeTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var subredditImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subredditImageView.layer.cornerRadius = self.subredditImageView.frame.width / 2
    }
    
    // MARK: - Setup
    func setupCell(post: RedditPost) {
        authorLabel.text = post.author
        subredditLabel.text = post.subredditNamePrefixed
        tagLabel.text = post.tag
        postTitleLabel.text = post.title
        postLabel.text = post.description
        dateLabel.text = DateFormatter.unixToStringDate(post.createdUTC)
        scoreLabel.text = post.stringScore()
        commentsLabel.text = post.stringComments()
        
        
        let placeholder = UIImage(named: "reddit")
        if let thumbnail = post.subredditDetail?.iconImage {
            subredditImageView.sd_setImage(with: URL(string: thumbnail), placeholderImage: placeholder)
        }
        
        bottomImageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        if let preview = post.imageUrl {
            bottomImageView.sd_setImage(with: preview)
        } else {
            bottomImageView.image = nil
            bottomImageView.isHidden = true
        }
        
        hideComponents()
    }
    
    private func hideComponents() {
        authorLabel.isHidden = authorLabel.text == nil
        subredditImageView.isHidden = subredditImageView.image == nil
        tagLabel.isHidden = tagLabel.text == nil
        postTitleLabel.isHidden = postTitleLabel.text == nil
        postLabel.isHidden = postLabel.text == nil
        dateLabel.isHidden = dateLabel.text == nil
        scoreLabel.isHidden = scoreLabel.text == nil
        bottomImageView.isHidden = bottomImageView.image == nil
    }
    
    // MARK: - Actions
    @IBAction private func shareButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func commentButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func downvoteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func upvoteButtonTapped(_ sender: UIButton) {
    }
}
