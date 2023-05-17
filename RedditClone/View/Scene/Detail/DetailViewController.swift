//
//  DetailViewController.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 17/5/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var subredditImageView: UIImageView!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: DetailViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Setup
    private func setup() {
        self.setupUI()
    }
    
    func setupViewModel(with post: RedditPost) {
        self.viewModel = DetailViewModel(post: post)
    }
    
    private func setupUI() {
        setupTitle()
        setupContent()
        hideComponents()
    }
    
    private func setupTitle() {
        self.title = viewModel.getPost().subredditDetail?.title
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    private func setupContent() {
        authorLabel.text = viewModel.getPost().getAuthor()
        subredditLabel.text = viewModel.getPost().subredditNamePrefixed
        tagLabel.text = viewModel.getPost().tag
        if let hexColor = viewModel.getPost().subredditDetail?.primaryColor {
            let colorString = hexColor == "#ffffff" ? "#000000" : hexColor
            tagLabel.textColor = UIColor(hex: colorString)
        }
        postTitleLabel.text = viewModel.getPost().title
        postLabel.text = viewModel.getPost().description
        dateLabel.text = DateFormatter.unixToStringDate(viewModel.getPost().createdUTC, format: "MMM d, h:mm a")
        scoreLabel.text = viewModel.getPost().stringScore()
        commentsLabel.text = viewModel.getPost().stringComments()
        
        
        let placeholder = UIImage(named: "reddit")
        subredditImageView.layer.cornerRadius = 24
        if let thumbnail = viewModel.getPost().subredditDetail?.iconImage {
            subredditImageView.sd_setImage(with: URL(string: thumbnail), placeholderImage: placeholder)
        }
        
        bottomImageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        if let preview = viewModel.getPost().imageUrl {
            bottomImageView.sd_setImage(with: preview)
        } else {
            bottomImageView.image = nil
        }
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
}
