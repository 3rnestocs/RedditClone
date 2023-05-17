//
//  CoreDataManager.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 16/5/23.
//

import CoreData

enum CoreDataModel: String {
    case post = "Posts"
}

class CoreDataManager {
    private let modelName: String
    
    static let shared = CoreDataManager(modelName: .post)

    init(modelName: CoreDataModel) {
        self.modelName = modelName.rawValue
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = self.storeContainer.viewContext

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func savePosts(_ posts: [RedditPost]?) {
        for post in posts ?? [] {
            let newPost = PostData(context: context)
            newPost.setValue(post.author, forKey: #keyPath(PostData.author))
            newPost.setValue(post.title, forKey: #keyPath(PostData.title))
            newPost.setValue(post.description, forKey: #keyPath(PostData.postDescription))
            newPost.setValue(post.tag, forKey: #keyPath(PostData.tag))
            newPost.setValue(post.createdUTC, forKey: #keyPath(PostData.date))
            newPost.setValue(post.numComments, forKey: #keyPath(PostData.comments))
            newPost.setValue(post.score, forKey: #keyPath(PostData.score))
            newPost.setValue(post.subredditNamePrefixed, forKey: #keyPath(PostData.subreddit))
            newPost.setValue(post.imageUrl, forKey: #keyPath(PostData.image))
            newPost.setValue(post.nextPage, forKey: #keyPath(PostData.nextPage))
            if let data = try? JSONEncoder().encode(post.subredditDetail) {
                newPost.setValue(data, forKey: #keyPath(PostData.subredditDetail))
            }
        }
    }
    
    func getPosts(completion: @escaping(([PostData]) -> Void)) {
        let noteFetch: NSFetchRequest<PostData> = PostData.fetchRequest()
        do {
            let results = try context.fetch(noteFetch)
            completion(results)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
