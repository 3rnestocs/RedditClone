//
//  DetailViewModel.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 17/5/23.
//

import Foundation

class DetailViewModel {
    private var redditPost: RedditPost!
    
    init(post: RedditPost) {
        self.redditPost = post
    }
    
    func getPost() -> RedditPost {
        self.redditPost
    }
}
