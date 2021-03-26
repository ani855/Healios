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
    private var networkProvider: NetworkManager!
    private(set) var posts: [Post]?
    
    // MARK: - Closures
    var bindPostsViewModelToController : ((Error?) -> ()) = {_ in}
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        networkProvider = NetworkManager()
        getPostsData()
    }
    
    // MARK: - Methods
    func getPostsData() {
        networkProvider.getPosts { (posts, error) in
            
            guard error != nil else {
                self.posts = posts
                self.bindPostsViewModelToController(nil)
                return
            }
            self.bindPostsViewModelToController(error)
        }
    }
}
