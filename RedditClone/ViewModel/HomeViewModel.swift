//
//  HomeViewModel.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation
import SDWebImage

class HomeViewModel {
    
    // MARK: - Properties
    var didFailed: ((String?) -> Void)?
    var displayAlert: (() -> ())?
    private var posts: [RedditPost]?
    private var pagesArray: [String] = [] {
        didSet {
            self.requestList()
        }
    }
    private var nextPage: String?
    
    // MARK: - Setup
    init() {
        requestPosts()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePostsRequest), name: .retrievePosts, object: nil)
    }

    // MARK: - Public methods
    func getPosts() -> [RedditPost] {
        self.posts ?? []
    }
    
    func paginate() {
        if let nextPage = self.nextPage {
            pagesArray.append(nextPage)
        }
    }
    
    // MARK: - Networking
    private func requestPosts() {
        /// Check if the first posts page exist in CoreData.
        CoreDataManager.shared.getPosts { persistedPosts in
            if persistedPosts.isEmpty {
                DispatchQueue.main.async {
                    self.displayAlert?()
                }
            } else {
                /// Display the posts fetched from CoreData.
                self.posts = persistedPosts.map({RedditPost.persisted(from: $0)})
                self.nextPage = self.posts?.first?.nextPage
                self.updatePreviewsURLs()
            }
        }
    }
    
    func requestTokenAPIs() {
        /// Check if user has secret client id.
        if Helper.isAuthenticated() {
            /// Check if user has session token.
            if Helper.hasToken() {
                /// Request the posts.
                self.requestList()
            } else {
                /// Fetch the token and save it on UserDefaults.
                NetworkManager.shared.requestSessionToken { isSuccess in
                    if isSuccess {
                        /// Request the posts.
                        self.requestList()
                    } else {
                        /// Handle error on token fetch.
                        print("T3ST failed isSuccess", isSuccess)
                    }
                }
            }
        } else {
            /// Request the secret client id and save it on UserDefaults.
            NetworkManager.shared.requestSecretClientID()
        }
    }
    
    private func requestList() {
        var params: [String: Any] = [
            "sr_detail": "expand subreddits",
            "raw_json": 1
        ]
        if let nextPage = self.nextPage {
            params["after"] = nextPage
        }

        /// Fetch the posts from the /top endpoint.
        NetworkManager.shared.request(api: API.topPosts, parameters: params, type: GeneralResponse.self, headers: NetworkManager.tokenHeader) { result in
            switch result {
            case .success(let response):
                /// Assign the next page to be retrieved.
                self.nextPage = response?.data.after

                /// Assign the retrieved posts to the class variable.
                if self.pagesArray.isEmpty {
                    self.posts = response?.data.children.map({$0.data})
                    self.posts?.indices.forEach({
                        self.posts?[$0].nextPage = response?.data.after
                    })
                } else {
                    var newPosts = response?.data.children.map({$0.data}) ?? []
                    newPosts.indices.forEach({
                        newPosts[$0].nextPage = response?.data.after
                    })
                    self.posts?.append(contentsOf: newPosts)
                }

                /// Update the URL property of each post.
                self.updatePreviewsURLs()

                /// Save first page of posts in CoreData.
                if self.pagesArray.isEmpty {
                    CoreDataManager.shared.savePosts(self.posts?.map({$0}))
                }
            case .failure(let error):
                /// Handle error on posts fetch.
                self.didFailed?(error.localizedDescription)
            }
        }
    }
    
    private func updatePreviewsURLs() {
        /// Create an array of URLs and assign them to the posts array.
        if let posts = self.posts {
            for (index, post) in posts.enumerated() {
                if let string = post.preview?.images.first?.source.url,
                   let url = URL(string: string) {
                    self.posts?[index].imageUrl = url
                }
            }
        }
        
        DispatchQueue.main.async {
            CoreDataManager.shared.saveContext()
            self.didFailed?(nil)
        }
    }
    
    // MARK: - Action
    @objc private func handlePostsRequest(_ notification: Notification) {
        /// Request posts after notification triggered when  token is received.
        requestList()
    }
}
