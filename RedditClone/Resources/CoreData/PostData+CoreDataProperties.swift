//
//  PostData+CoreDataProperties.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 16/5/23.
//
//

import Foundation
import CoreData


extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var author: String?
    @NSManaged public var comments: Int32
    @NSManaged public var date: Double
    @NSManaged public var image: URL?
    @NSManaged public var postDescription: String?
    @NSManaged public var score: Int32
    @NSManaged public var subreddit: String?
    @NSManaged public var tag: String?
    @NSManaged public var title: String?
    @NSManaged public var nextPage: String?
    @NSManaged public var subredditDetail: Data?

}

extension PostData : Identifiable {

}
