//
//  PostsViewModel.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation
import CoreData

class PostsViewModel: NSObject {
    
    // MARK: - Properties
    private var cdHandler: CDHandler?
    private var apiHandler: APIHandler?
    
    private(set) var posts: [Post] = [Post]()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
    }
    
    // MARK: - Methods
    func getPostsData(completion: @escaping ([Post]?, Error?) -> ()) {
        cdHandler = CDHandler()
        cdHandler?.fetchPostsFromCoreData { (posts, isSucceed) in
            if isSucceed {
                self.posts = posts!
                completion(posts, nil)
            } else {
                self.apiHandler = APIHandler()
                self.apiHandler?.getPostsFromAPI { (posts, error) in
                    guard let _ = posts else {
                        completion(nil, error)
                        return
                    }
                    self.posts = posts!
                    self.cdHandler?.saveInCoreDataWith(posts: posts!)
                    completion(posts, nil)
                }
            }
        }
    }
}

fileprivate class APIHandler {
    
    // MARK: - Properties
    private var networkProvider: NetworkManager = NetworkManager()
    
    // MARK: - Methods
    func getPostsFromAPI(completion: @escaping ([Post]?, Error?) -> ()) {
        
        networkProvider.getPosts { (posts, error) in
            if let _ = error {
                completion(nil, error)
            } else{
                completion(posts, nil)
            }
        }
    }
}

fileprivate class CDHandler {
    
    // MARK: - CoreData Methods
    private func createPostEntityFrom(resultPost: Post) -> NSManagedObject? {

            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let post = NSEntityDescription.insertNewObject(forEntityName: "PostEntity", into: context) as? PostEntity {
            post.body = resultPost.body
            post.id = Int16(resultPost.id)
            post.userId = Int16(resultPost.userId)
            post.title = resultPost.title
            return post
        }
        return nil
    }
    
    func saveInCoreDataWith(posts: [Post]) {
            _ = posts.map{self.createPostEntityFrom(resultPost: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func fetchPostsFromCoreData(completion: @escaping ([Post]?, _ isSucceed: Bool) -> ()) {
        var CDPosts = [Post]()
        let postsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        do {
            let fetchedPosts = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(postsFetch) as! [PostEntity]
            print(fetchedPosts)
            for postEntity in fetchedPosts {
                CDPosts.append(Post(id: postEntity.id, userId: postEntity.userId, title: postEntity.title, body: postEntity.body))
            }
            if fetchedPosts.count < 1 {
                return completion(nil, false)
            }
            return completion(CDPosts, true)
        } catch {
            return completion(nil, false)
        }
    }
}
