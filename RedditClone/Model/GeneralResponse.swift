//
//  GeneralResponse.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation

struct GeneralResponse: Codable {
    let data: PostResponse
}

struct PostResponse: Codable {
    let after: String?
    let children: [Post]
}

struct Post: Codable {
    var data: RedditPost
}

struct RedditPost: Codable {
    var subredditNamePrefixed: String?
    var thumbnail: String?
    var title: String?
    var tag: String?
    var description: String?
    var score: Int?
    var preview: Preview?
    var author: String?
    var numComments: Int?
    var imageUrl: URL?
    var createdUTC: Double?
    var nextPage: String?
    var subredditDetail: Subreddit?
    
    func getAuthor() -> String? {
        guard let author = self.author else {
            return nil
        }
        return "u/\(author)"
    }
    
    static func persisted(from post: PostData) -> RedditPost {
        var subreddit: Subreddit?
        if let data = post.subredditDetail {
            subreddit = try? JSONDecoder().decode(Subreddit.self, from: data)
        }
        let persistedPost = RedditPost(subredditNamePrefixed: post.subreddit, title: post.title, tag: post.tag, description: post.postDescription, score: Int(post.score), author: post.author, numComments: Int(post.comments), imageUrl: post.image, createdUTC: post.date, nextPage: post.nextPage, subredditDetail: subreddit)
        return persistedPost
    }
    
    func date() -> String? {
        DateFormatter.unixToStringDate(createdUTC)
    }
    
    func stringScore() -> String? {
        guard let score = self.score else {
            return nil
        }
        return String(score)
    }
    
    func stringComments() -> String? {
        guard let comments = self.numComments else {
            return nil
        }
        return String(comments)
    }

    enum CodingKeys: String, CodingKey {
        case subredditNamePrefixed = "subreddit_name_prefixed"
        case thumbnail
        case title
        case tag = "link_flair_text"
        case description = "selftext"
        case score
        case preview
        case author
        case numComments = "num_comments"
        case createdUTC = "created_utc"
        case subredditDetail = "sr_detail"
    }
}

// MARK: - Subreddit
struct Subreddit: Codable {
    var title: String?
    var primaryColor: String?
    var iconImage: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case primaryColor = "primary_color"
        case iconImage = "icon_img"
        case description = "public_description"
    }
}

// MARK: - Preview
struct Preview: Codable {
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let source: Source
}

// MARK: - Source
struct Source: Codable {
    let url: String
}
